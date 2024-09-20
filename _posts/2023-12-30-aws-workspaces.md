---
layout: post
title: "AWS Workspaces"
date: 2023-09-20 03:42:00 -0400
modified_date: 2024-06-12 15:39:00 -0400
categories: aws workspaces
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
aws ds describe-directories
aws workspaces describe-workspaces
aws workspaces describe-workspaces --directory-id <value> --user-name <value>
aws workspaces describe-workspace-directories
aws ds delete-directory --directory-id <value>
```

To get workspace used by a specific user.

```
aws workspaces describe-workspaces --directory-id <value> --user-name <value>
```

Before doing any manitenance activity, workspace state should be started and changed to maintanence mode.

```
aws workspaces modify-workspace-state --workspace-id ws-id --workspace-state ADMIN_MAINTENANCE
aws workspaces modify-workspace-state --workspace-id ws-id --workspace-state AVAILABLE
```

https://docs.aws.amazon.com/workspaces/latest/adminguide/workspace-maintenance.html

#### Migrate workspace

```
Your WorkSpaces are being migrated.
The migration process has started. New WorkSpaces are being created:

New WorkSpace ID ws-newid

If the WorkSpace migration fails, the WorkSpace will be automatically rolled back to its pre-migration state.
```

#### Create Image

In UI, select workspace -> Actions --> Crate image

```
The image was successfully created.
The WorkSpace image wsi-imageid was successfully created. To view more details about this image, visit the image details page.
```

```
aws workspaces start-workspaces --start-workspace-requests WorkspaceId=ws-id
aws workspaces create-workspace-image --name sandbox-image --workspace-id ws-id
```

Note: The WorkSpace must not be encrypted. Image creation from an encrypted WorkSpace is not currently supported.

```
$ aws workspaces create-workspace-image --name sandbox-image --workspace-id  ws-id --description 'it is an encrypted image '

An error occurred (OperationNotSupportedException) when calling the CreateWorkspaceImage operation: The operation couldn't be performed on the specified WorkSpace. Confirm that the WorkSpace is not encrypted and try again.
```

Example

```
[cloudshell-user@ip-10-123-45-67 ~]$ aws workspaces create-workspace-image --name mahendran-image --workspace-id ws-id --description "initial setup of developer machine"
{
    "ImageId": "wsi-id",
    "Name": "mahendran-image",
    "Description": "initial setup of developer machine",
    "OperatingSystem": {
        "Type": "WINDOWS"
    },
    "State": "PENDING",
    "RequiredTenancy": "DEFAULT",
    "Created": "2025-01-15T21:37:38.940000+00:00",
    "OwnerAccountId": "123456789"
}
[cloudshell-user@ip-10-130-81-74 ~]$ aws workspaces describe-workspace-images --image-ids wsi-id
```

When creating image, the source workspace goes to `SUSPENDED` state. Also it takes long time to create the image. Until it is ready, the status of the image is in `PENDING` state.

Once image created, you can copy to another region (not all the region available as target to copy - why?)

You can run this command from the target region or use `--region` to specify the target region.

```
aws workspaces copy-workspace-image \
--name <name-of-the-image-at-target> \
--source-image-id <value>
--source-region <value>
```

#### Create workspaces

```
aws workspaces create-workspaces \
    --workspaces DirectoryId=d-926722edaf,UserName=Mary,BundleId=wsb-0zsvgp8fc,WorkspaceProperties={RunningMode=AUTO_STOP}

```

#### Importing image

If you are migrating from on-prem or trasfering from EC2, you can use `import-workspace-image` command

### Cost saving or clean up after experiments

#### Delete or Terminate workspaces

! Careful - Can't be undone.

```
aws workspaces terminate-workspaces --terminate-workspace-requests <workspace id(s)>
```

## Pricing Notes

- Identify less never or frequently used workspaces and decommision it

```
aws workspaces describe-workspaces-connection-status  --output table
aws workspaces describe-workspaces --workspace-id <workspace-id> --output json
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

Note: AD and AD Connector are made available for your WorkSpace free of charge. If there is no WorkSpace being used with your Simple AD or AD Connnector for 30 days, you might be charged for this directory

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
- [Need resilient workspace?](https://docs.aws.amazon.com/workspaces/latest/adminguide/multi-region-resilience.html)

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

Go to `Directory Service` instead of `Workspace -> Directories` to reset user password

### Capacity constraint

```
Resource handler returned message: "Failed to locate Availability Zone: us-west-2d corresponding to subnet: <subnet-id>. This availability zone may be capacity constrained. : RequestId: f08c14ac-a83c-uuid-c2d6706d5bf6 (Service: Directory, Status Code: 400, Request ID: f08c14ac-uudi-c2d6706d5bf6)" (RequestToken: 1642d8fa-uuid-77a3456422b1, HandlerErrorCode: GeneralServiceException)
```

### Manage Directory

- https://docs.aws.amazon.com/directoryservice/latest/admin-guide/simple_ad_install_ad_tools.html
