---
layout: post
title: "Delegating AWS start and stop"
date: 2022-12-10 08:05:00 -0400
modified_date: 2023-01-01 21:30:00 -0400
categories: aws
---

# Motivation
I want to share an EC2 instance to a team member. I dont want to leave it up and running all the time which would waste resource and increases cost. My thought is to create the instance and find a way to give control to stop and start without he/she get access to AWS when I am not an IAM expert yet. Also I want the EC2 instance to stop automatically if there is no activity on it. This helps incase my team member fogot to stop the instance.

## Thoughts

Create an API (AWS gateway) which is protected by token to call a Lambda function. This lambda function will call AWS api/command to stop or start the EC2.

Configure EC2 instance logs to AWS centralized logging service (???), find opportunity to create an event when specific log (that can tell us when instance used). Create a scheduled poll every X mins which checks the event/log to verify the usage of instance. If it finds that the instance is not used, call the Lambda function to stop the instance and trigger email to stakeholders so they are not surprised.

## Pros and Cons of the implementation

As there are multiple ways to meet the need. There are pros and cons in the implementation.
### Pros
- Let the developers focus on their main work.
- Better than leaving the instance running which adds to bill.


### Cons
- More AWS setup. Hard to manage unless Infrastructure as Code (IaC) in place.

## Questions, Answers & Decisions
- Is there a cost for AWS logging, event and schedule service?
- Is there a cost for using email notification (SNS)?
- Can we pass EC2 instance name to Lambda to make the function generic?
- Does AWS provide any solution for this kind of requirement to save cost?


## Implementation

- Create Policy - LamdaToStartAndStopEC2Instance
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    },
    {
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "arn:aws:sns:us-east-1:895650330533:MyAWSAlert"
        }
  ]
}
```
- Create Role - LambdaAutomation


### Create Lambda to stop EC2 instances

* Go to lamda console 
* Click Create function
* Author from scratch
* Give a function name - StopEC2Instances
* Choose Python as runtime
* Change default execution role - LambdaAutomation
* Advanced settings --> Enable function URL with Auth type as `NONE`


> **Warning**
> 
> Choosing auth type `NONE` is meant to delegate without complexity. Do not share the link in public/group. Imagine for a moment what if the url misused. But understanding the lambda code and configuring right level of permission for lambda will eliminate the fear.

In Code source...
```
import boto3
region = 'us-east-1'
instances = ['i-0db31f8ed02541ce9', 'i-03e4c56c0febe6ecb', 'i-0efc9e4bbb5c9df74']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    return 'Stopped your instances: ' + str(instances)
```


Deploy the function
You can test by creating an event.
Test the function url by using in browser or curl.


Change region and instances.

### Create Lambda to start EC2 instances

Almost all same excepting giving different function name and code source as below.
```
import boto3
import json

region = 'us-east-1'
instances = ['i-0efc9e4bbb5c9df74']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.start_instances(InstanceIds=instances)
    print('Started your instances: ' + str(instances))
    instants_short = []
    descriptions = ec2.describe_instances(InstanceIds=instances)
    print(json.dumps(descriptions, default=str))
    reservations = descriptions['Reservations']
    for reservation in reservations:
        for instance in reservation['Instances']:
            instant_temp = {}
            instant_temp['InstanceId'] = instance['InstanceId']
            instant_temp['PublicDnsName'] = instance['PublicDnsName']
            instant_temp['PublicIpAddress'] = instance['PublicIpAddress']
            instants_short.append(instant_temp)
        
    return json.dumps(instants_short, indent=4)

```

### Enable function URL to trigger via curl/browser
If you add or remove function from the configuratio tab --> Function URL.

## Test

```
mahendran@mm-lab mahendran % curl https://uniquereftoyourfunction.lambda-url.us-east-1.on.aws/
[
    {
        "InstanceId": "i-0efc9e4bbb5c9df74",
        "PublicDnsName": "ec2-34-235-114-133.compute-1.amazonaws.com",
        "PublicIpAddress": "34.235.114.133"
    }
]%                                                                                                    
```

## Alternatives
- Create a AWS user and configure IAM to limit with fine grained permission 
    - We need to be an AWS IAM expert.
    - Open up opportunity for the team member to explore AWS in addition to the main objective.
- Create a AWS user(s) with a budget limittation and let the team manage their account
- Develop CloudFormation stack so we can recreate instead of hanging on one EC2 and manual work on that becomes unmanagible.

## Lessons Used & Learned
- Creating EC2
- Creating IAM Permissions and Roles
- Creating Lambda with Python
- Enabling Function URL
- EC2 ec2:Describe* API actions do not support resource-level permissions, so you cannot control which individual resources users can view in the console. Therefore, the * wildcard is necessary in the Resource element of the above statement
- AWS gives free Elastic IP as long as we keep it running. Without Elastic IP, we may get different IP when instance restarted. Its good to share the Public DNS and IP when starting.


## Next steps
- Send notification (email) when instance started or stopped
- Automatically stop when instance is not used effectively (based on log)
- Schedule to start and stop EC2.
- Respond properly when instance not found (YAGNI).

## Reference:
- https://aws.amazon.com/premiumsupport/knowledge-center/start-stop-lambda-eventbridge/
- https://aws.amazon.com/premiumsupport/knowledge-center/iam-ec2-resource-tags/
- https://aws.amazon.com/premiumsupport/knowledge-center/elastic-ip-charges/
