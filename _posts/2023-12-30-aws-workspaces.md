---
layout: post
title: "AWS Workspaces"
date: 2023-09-20 03:42:00 -0400
modified_date: 2023-09-20 03:42:00 -0400
categories: aws template
---

# AWS Workspaces

- Amazon WorkSpaces is a managed, secure cloud desktop as a service (DaaS).
- Has concept of WorkDocs

## Purpose

## Characteristics

- Each WorkSpaces instance is associated with a specific VPC and the AWS Directory
  Service.
- The WorkSpaces service requires a minimum of
  two subnets to operate, each in a different Availability Zone (AZ).
- PCoIP (port 4172) --> PC over IP
- WSP (port 4195) --> WorkSpaces Streaming Protocol
- Client applications use port 4172 (PCoIP) and port 4195 (WSP) for pixel streaming to the WorkSpace and ports 4172 and 4195 for network health checks
- A WorkSpace bundle is a combination of an operating system, and storage, compute, and software resources

## AWS Directories

- Act as a storage for user and workspaces (computers) information.
- Has unique registration code per directory which will be shared to all the workspace users.
- Requires two subnets or your VPC.

## Useful AWS commands

```
aws workspaces describe-workspaces
aws workspaces describe-workspaces --output table
aws workspaces describe-workspace-directories


```

### Cost saving or clean up after experiments

```
aws workspaces terinate-workspaces --terminate-workspace-requests <workspace id(s)>
```

## Pricing Notes

- Identify less never or frequently used workspaces and decommision it

```
aws workspaces describe-workspaces-connection-status  --output table
aws workspaces describe-workspaces --workspace-id <workspace-id>
```

To find what are the workspaces connected before/after certain time

```
aws workspaces describe-workspaces-connection-status --query 'WorkspacesConnectionStatus[?LastKnownUserConnectionTimestamp>`2023-12-15T17:55:3S.390Z`]'

```

Client side sort using `jq`

```
aws workspaces describe-workspaces-connection-status | jq -s 'sort_by(.LastKnownUserConnectionTimestamp)'
```

- https://aws.amazon.com/solutions/implementations/cost-optimizer-for-amazon-workspaces/
- https://www.youtube.com/watch?v=jZB1othoc7Y

## Security

- Define security group to limit the inbound and outbound traffic.
- If your company uses HTTP proxy, VPN or Zero-Trust network setup, you may use limit the inbound client connection so that workspaces not available from public network.
- You can limit outbound traffic with [IP range of the region](https://docs.aws.amazon.com/workspaces/latest/adminguide/workspaces-port-requirements.html#gateway_IP) on port 4195 from your corporate network to the AWS.

## Infrastructure as Code (IaC)

Create Simple AD directory using cloudformation

```
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Developer Workspace'

Parameters:
  vpcID: {
    "Type" : "String",
    "Default" : "vpc-default123123",
    "Description" : "VPC where directory will be associated."
  }
  subnetID1: {
    "Type" : "String",
    "Default" : "subnet-one1232",
    "Description" : "Two subnets needed minimum. This is first subnet"
  }
  subnetID2: {
    "Type" : "String",
    "Default" : "subnet-two23432",
    "Description" : "Two subnets needed minimum. This is second subnet"
  }


Resources:
  # Directory creation typically takes between 20 to 45 minutes.
  DevWorkspaceDirectory:
    Type: AWS::DirectoryService::SimpleAD
    Properties:
      Name: "fun.local.corp"
      Password: 'HardCodedBAD#'
      # Password: '{{resolve::ssm-secure:SimpleADPW:1}}'
      Size: Small
      VpcSettings:
        SubnetIds:
          - !Ref subnetID1
          - !Ref subnetID2
        VpcId: !Ref vpcID
```

### CloudFormation Template

```

```

## Resources

- [Pricing](https://aws.amazon.com/workspaces/core/pricing/)
- [CLI Docs](https://docs.aws.amazon.com/cli/latest/reference/workspaces/)
- [Admin Guide](https://docs.aws.amazon.com/workspaces/latest/adminguide/amazon-workspaces.html)
- [Best Practices Workspace VPC](https://d1.awsstatic.com/whitepapers/best-practices-vpcs-networking-amazon-workspaces-deployments.pdf)
- [Cost optimizer for workspaces](https://docs.aws.amazon.com/solutions/latest/cost-optimizer-for-workspaces/overview.html)
- [Youtube - Deploying Directory using CloudFormation](https://www.youtube.com/watch?v=6QLjyxylNDQ)

## Problems and Solutions

### Unauthorized DescribeUsers

```
aws workdocs describe-users --organization-id <directory-id>

An error occurred (UnauthorizedResourceAccessException) when calling the DescribeUsers operation: Principal [arn:aws:iam::account:user/mahendran] is not allowed to execute [workdocs:DescribeUsers] on the resource
```

#### Solution

### Reset user password

- https://www.youtube.com/watch?v=bXS7iSSIWt8

```
You need permissions
You do not have the permission required to perform this operation. Ask your administrator to add permissions.
User: arn:aws:iam::account:user/mahendran is not authorized to perform: ds:ResetUserPassword on resource: arn:aws:ds:eu-west-1:account:directory/d-dirID because no identity-based policy allows the ds:ResetUserPassword action
```

### Manage Directory

- https://docs.aws.amazon.com/directoryservice/latest/admin-guide/simple_ad_install_ad_tools.html
