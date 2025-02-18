---
layout: post
title: "AWS Tagging"
date: 2024-09-05 3:58:00 -0400
modified_date: 2025-02-15 19:00:00 -0400
categories: aws tagging
---

# AWS Tagging

## Notes

- Use namespaces (key name separated by colon :). Example: `company-name:department-name:standard-key'
- Cover RACI (Responsible, Accountable, Consulted and Informed) details with multiple tags.
- Define tags based on the need. What questions we are going to answer and what tags needed for integration.
- Implement process for [Tag strategy iteration and improvement cycle](https://docs.aws.amazon.com/images/whitepapers/latest/tagging-best-practices/images/tagging-strategy-cycle.png)
- Identify and promote a team member who is responsible for implementing and guiding tag strategy.
- Define mandatory tags and apply tagging policies to report or prevent missing tags.
- Plan review/measure the effectiveness of tags against target questions and goals. Downgrade mandatory tags to optional.
- Avoid analysis paralasis on keys as it can be altered with commands/scripting or tools like tag editor.

## Quotes from resources

```
While we(AWS) strongly recommend that you adopt the practices outlined in Organizing Your AWS Environment Using Multiple Accounts whitepaper, realistically customers often find themselves with mixed and complex account structures that take time to migrate away from. Implementing a rigorous and effective tagging strategy is the key in this scenario, followed by activating relevant tags for cost allocation in the Billing and Cost Management console (in AWS Organizations, tags can be activated for cost allocation only from the Management Payer account).
```

## Cost Allocation Tags

Once you defined the taging strategy, define cost allocation tags if the tag can answer any FINOPS questions.

## Pricing Awareness

AWS pricing pages has very detaild documentation with samples. However it takes time to understand and figure out what is the cost of our resource based on the option we have choosen while creating.

We can tag the cost factor in the tag based on the provision we have made. This creates awareness to the engineers. For example cost-factor: $16/month

## Use Tag Editor

Tag editor can be very useful to bulk edit tags to refactor existing tags or add tags by filtering resources.

## Brownfield Tagging - Use programs

Tagging existing infrastructure with 1000s of resources will be a overwhelming task. Especially if the resources are not part of infrastructure as code.
If you can derive the tag values based on existing attributes or names of the resource, then we could write program to select the resource with filtering and apply tags programatically.
Here are few python example bulk tag examples.

### VPC Endpoints

```python
import boto3
import logging

# Configure logging
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

def list_vpc_endpoints(region_name):
    """
    Lists all VPC endpoints in a given AWS region.

    Args:
        region_name (str): The AWS region to list VPC endpoints in (e.g., 'us-east-1').

    Returns:
        list: A list of dictionaries, where each dictionary represents a VPC endpoint.
              Returns an empty list if no VPC endpoints are found or if an error occurs.
    """
    try:
        # Create an EC2 client for the specified region
        ec2_client = boto3.client('ec2', region_name=region_name)

        # Describe VPC endpoints
        response = ec2_client.describe_vpc_endpoints()

        # Extract VPC endpoint information
        vpc_endpoints = response.get('VpcEndpoints', [])  # Safe handling if 'VpcEndpoints' key is missing

        if vpc_endpoints:
            logging.info(f"Found {len(vpc_endpoints)} VPC endpoints in region {region_name}.")
            return vpc_endpoints
        else:
            logging.info(f"No VPC endpoints found in region {region_name}.")
            return []

    except Exception as e:
        logging.error(f"An error occurred: {e}")
        return []



def tag_vpc_endpoint(region_name, endpoint_id, endpoint_service_name):
    """
    Tags a VPC endpoint with the tag "app-name" and the endpoint name as the tag value.

    Args:
        region_name (str): The AWS region where the VPC endpoint exists.
        endpoint_id (str): The ID of the VPC endpoint to tag.
        endpoint_service_name (str): The desired name for the endpoint to be used as the tag value.
    """
    try:
        ec2_client = boto3.client('ec2', region_name=region_name)

        tags = [{
            'Key': 'service-name',
            'Value': endpoint_service_name
        },
        {
            'Key': 'resource-type',
            'Value': 'vpc-endpoint'
        },
        {
            'Key': 'approx-cost',
            'Value': '$16/month' # modify based on your observation/calculation
        }]

        ec2_client.create_tags(Resources=[endpoint_id], Tags=tags)
        logging.info(f"Successfully tagged VPC endpoint {endpoint_id} with app-name:{endpoint_service_name}")

    except Exception as e:
        logging.error(f"Error tagging VPC endpoint {endpoint_id}: {e}")


def main():
    """
    Main function to list VPC endpoints and tag them.
    """

    region = input("Enter the AWS region (e.g., us-east-1): ")
    if not region:
        print("Region cannot be empty. Please provide a valid AWS region.")
        return

    vpc_endpoints = list_vpc_endpoints(region)

    if vpc_endpoints:
        print("\nVPC Endpoints:")
        for endpoint in vpc_endpoints:
            endpoint_id = endpoint['VpcEndpointId']
            endpoint_service_name = endpoint.get('ServiceName', 'UnknownEndpoint') #Default value if ServiceName is empty
            print("------------------------------------")
            print(f"VPC Endpoint ID: {endpoint_id}")
            print(f"VPC ID: {endpoint['VpcId']}")
            print(f"Service Name: {endpoint['ServiceName']}")
            print(f"State: {endpoint['State']}")
            print(f"Creation Timestamp: {endpoint['CreationTimestamp']}")
            # Tag the VPC endpoint
            tag_vpc_endpoint(region, endpoint_id, endpoint_service_name)

    else:
        print(f"No VPC endpoints found or an error occurred in region {region}.")

if __name__ == "__main__":
    main()

```

### DynamoDB

```python
import boto3

sts_client = boto3.client('sts')  # Create STS client
account_id = sts_client.get_caller_identity()['Account']
print(account_id)

def tag_dynamodb_tables():
    """Tags all DynamoDB tables with the 'app-name' tag,
    using the table name as the tag value.
    """
    dynamodb = boto3.client('dynamodb')
    tables = getAllTableByPaginating(dynamodb)
    tagTables(dynamodb, tables)




def getAllTableByPaginating(dynamodb):
    table_names = []
    last_evaluated_table_name = ''

    try:
        # List all DynamoDB tables using pagination
        while True:
            if last_evaluated_table_name:
                response = dynamodb.list_tables(ExclusiveStartTableName=last_evaluated_table_name)
            else:
                response = dynamodb.list_tables()

            table_names.extend(response.get('TableNames', []))

            last_evaluated_table_name = response.get('LastEvaluatedTableName')

            if not last_evaluated_table_name:
                break
    except Exception as e:
        print(f"Error listing tables: {e}")
        return []

    return table_names

def tagTables(dynamodb, tables):
    for table_name in tables:
        try:
                # Check if the table already has the 'app-name' tag.  This avoids unnecessary API calls.
            existing_tags = dynamodb.list_tags_of_resource(
                    ResourceArn=f'arn:aws:dynamodb:{boto3.session.Session().region_name}:{account_id}:table/{table_name}'
                )

            app_name_tag_exists = False
            if 'Tags' in existing_tags:
                for tag in existing_tags['Tags']:
                    if tag['Key'] == 'app-name':
                        app_name_tag_exists = True
                        break

            if not app_name_tag_exists: # Only tag if it doesn't exist.
                    # Tag the table
                dynamodb.tag_resource(
                        ResourceArn=f'arn:aws:dynamodb:{boto3.session.Session().region_name}:{account_id}:table/{table_name}',
                        Tags=[
                            {
                                'Key': 'app-name',
                                'Value': table_name
                            },
                        ]
                    )
                print(f"Tagged table: {table_name}")
            else:
                print(f"Table {table_name} already has the app-name tag. Skipping.")

        except Exception as e:
            print(f"Error tagging table {table_name}: {e}")


if __name__ == "__main__":
    tag_dynamodb_tables()
```

### Workspaces

```python
import boto3

def tag_workspaces():
    """
    Lists all AWS WorkSpaces and adds a tag with Key='primary-owner' and Value equal to the Workspace's username.

    Prerequisites:
        - The IAM role/user running this script needs permission for:
            workspaces:DescribeWorkspaces
            workspaces:CreateTags
    """
    try:
        workspaces = boto3.client('workspaces')
        all_workspaces = []
        next_token = ''

        while True:
            if next_token:
                response = workspaces.describe_workspaces(NextToken=next_token)
            else:
                response = workspaces.describe_workspaces()

            workspaces_data = response.get('Workspaces', [])

            for workspace in workspaces_data:
                workspace_id = workspace.get('WorkspaceId')
                username = workspace.get('UserName')

                if workspace_id and username:
                    try:
                        # Tag the workspace
                        workspaces.create_tags(
                            ResourceId=workspace_id,
                            Tags=[
                                {
                                    'Key': 'primary-owner',
                                    'Value': username
                                }
                            ]
                        )
                        print(f"Successfully tagged Workspace '{workspace_id}' with primary-owner='{username}'")
                    except Exception as tag_err:
                        print(f"Error tagging Workspace '{workspace_id}': {tag_err}")

            next_token = response.get('NextToken')
            if not next_token:
                break


    except Exception as e:
        print(f"Error listing or tagging WorkSpaces: {e}")


if __name__ == "__main__":
    tag_workspaces()
```

## Resources

- https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/tagging-best-practices.html
- https://wellarchitectedlabs.com/cost-optimization/
- https://workshops.aws/categories/Cost%20Management
