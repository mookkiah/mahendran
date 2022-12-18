---
layout: post
title: "Quick AWS instance"
date: 2022-12-18 7:17:00 -0400
modified_date: 2022-12-18 7:17:00 -0400
categories: cloud aws cloudformation instance
---

# Motivation
I created AWS EC2 instance many times and almost everyday during certain part of my career. But it is always stressful zone when I work on my personal AWS account for learning  and training purpose. I don't want to leave any resource which could cost me. I want to limit my resources with right security settings so it is getting into wrong hands.

I prepared a budget plan, created default security group limitting my home IP in inbound trafic and keeping the KeyPair safe. These are one time effort. But it is not still bringing peace of mind which makes me to check often.

Most of my personal learning needs only one instance and gain SSH access to it. So I thought why dont we create a AWS cloudformation stack so we can create with few commands quickly without navigating to AWS console.

## Prerequisite
- AWS account (free-tier is enough)
- aws cli 


## Implementation

We need a cloudformation template which takes the IP where we are `MyHomeIP` and KeyName to provision the instance to allow SSH.

### Prepare a cloudformation

Save this file as `quick-ubuntu-in-aws.yaml`
Feel free to change the `ImageId` with your flavor of linux
```yaml
Parameters:
  MyHomeIP: 
    Type: String
    Description: My home IP which is keep changing
  KeyName: 
    Type: String
    Description: Key Pair key name to use ssh connection

Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      # Ubuntu Server 22.04 LTS (HVM), SSD Volume
      ImageId: ami-0574da719dca65348
      InstanceType: t2.micro
      SecurityGroups:
        - !Ref SSHSecurityGroup
      KeyName: !Sub ${KeyName}
      Tags: 
      - Key: "my-lab:purpose"
        Value: "QuickCentOS"

  # our EC2 security group
  SSHSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable SSH access via port 22
      SecurityGroupIngress:
      - CidrIp: !Sub '${MyHomeIP}/32'
        IpProtocol: tcp
        FromPort: 22
        ToPort: 22
```

## Commandline Steps

### Initialize few variable 
```sh
KeyName=quick-key
StackName=quick-ubuntu-in-aws
```

### Generate KeyPair
```
aws ec2 delete-key-pair --key-name $KeyName
aws ec2 create-key-pair --key-name $KeyName | jq -r .KeyMaterial > ${KeyName}.pem
chmod 400 ${KeyName}.pem
```

### create stack
```
aws cloudformation create-stack \
--stack-name ${StackName} --template-body file://quick-ubuntu-in-aws.yaml \
--parameters \
    ParameterKey=MyHomeIP,ParameterValue=$(curl -s http://checkip.amazonaws.com/) \
    ParameterKey=KeyName,ParameterValue=${KeyName} 

aws cloudformation wait stack-create-complete --stack-name ${StackName}
```

### Get Instance Public DNS
```
InstanceHostname=$(aws ec2 describe-instances --filters Name=tag:my-lab:purpose,Values=QuickCentOS --query 'Reservations[].Instances[].PublicDnsName' --output text)
```
### SSH to instance
```
ssh -i ${KeyName}.pem ubuntu@${InstanceHostname}
```

## Ideas
- If you are creating instance to share with someone, you can add entries to `SecurityGroupIngress` by asking their IP.
- 

## Clean up
If you want to reset or cleanup the resources after completing your work, remember to delete.
```sh
aws cloudformation delete-stack --stack-name ${StackName}
aws ec2 delete-key-pair --key-name $KeyName
rm ${KeyName}.pem
```


## Resources
- AWS documentation
- Few Stackoverflow questions
- Udemy course

## Next Steps
- Get instance id from the stack to check status
- Execute few setup/startup commands once instance is up and running.