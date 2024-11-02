---
layout: post
title: "SSO for AWS console using Microsoft Entra ID"
date: 2024-11-02 14:34:00 -0400
modified_date: 2024-11-02 14:34:00 -0400
categories: SSO EntraID AWS Console IAM Identity Center
---

# Microsoft office login to access AWS Console 

## Motivation
Single Sign On (SSO) is considered as a security best practice. Managing users and their access rights centrally help smooth and quick onboarding and offboarding employess in the organization. I wanted to share notes to enable this integration and strategy to implement few use cases.

## Agile style requirements
1. As a organization employee, I should use my office 365 login credentials to login into AWS console.
1. As a infrastructure admin, I should be able to give birth rights access only for employees who needs AWS access.
1. As a AWS user, I should be able to login into AWS console with view only access when I dont intent to make changes.
1. As a infrastructure owner, I want to use SCIM to provision users to have connected user principles across systems.
1. As a infrastructrue owner, I want AWS access assigned to users based on security groups which are provisioned via SCIM.
1. As a infrastructure admin, I should be able to let the application/support team manage Security Group members.

## SSO integration
As both Microsoft and AWS are favouring the need of SSO integration, the steps to integrate is getting easy as time passes. Here are steps and screenshots.

In technical terms, This integration uses SAML based SSO where Microsoft Entra ID act as IDP and AWS IAM Identity Center act as SP. AWS IAM Identity Center also accepting SCIM provisioing to keep User-Group setup in sync with Microsoft Entra ID.

## Create Enterprise Application

1. Go to Azure Portal -> Entra ID -> Manage Enterprise applications -- https://portal.azure.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/menuId~/null
2. Click New Application, Enter "aws" in search. Take time to see options and select the one which says `AWS IAM Identity Center'. 

Now you have successfully created the application. 

### Download SP Metadata
IAM Identity Center act as SP which is allowed to configure only one IDP. By default it is using `Identity Center Directory`. We have to change it by going to `Identity Ceter` -> `Settings` -->   `Identity Source` Actions -> `Change identity source`

Once you  select `External identity provider`, you can download metadata file. If you are not managing IDP `Entra ID`, you should share this with respective team.

### Upload SP Metadata and Download IDP Metadata 
In Azure Portal, Entra ID --> Enterprise applications --> Go to the same application created in earlier setup --> Manage --> `Single Sign-on` -- `Upload (SP) Metadata file` 

Once you upload SP metadata, you can download `Federation (IDP) Metadata XML`.
If you dont manage AWS Identity Center, share it with respective team.

### Upload IDP Metadata
IDP metadata which is required to upload in the same `change identiy source` page in AWS console.

## User Group planning

In Entra ID create security groups to represent the different teams which require AWS access.

Sample naming format:

* sg-infra-aws-<APP>-<ENV>-<role> --> map with the specific account associated with the app and environmet.

where `role` can be developers, data scientists, architects, support etc.,

* sg-infra-aws-users --> map with basic/birth right access (make all the above groups added to this group as members). Test hierarchy works.


## SCIM provisioning

SCIM - System for Cross-domain Identity Management


## AWS Access Setup


## Resources
- [Micorsoft Tutorial](https://learn.microsoft.com/en-us/entra/identity/saas-apps/aws-single-sign-on-tutorial)
- [SCIM Provisioning](https://learn.microsoft.com/en-us/entra/identity/saas-apps/aws-single-sign-on-provisioning-tutorial)
- https://scim.cloud/
- https://docs.aws.amazon.com/singlesignon/latest/developerguide/what-is-scim.html
