---
layout: post
title: "Microsoft License and service plan"
date: 2023-03-29 03:52:00 -0400
modified_date: 2023-03-29 03:52:00 -0400
categories: microsoft license
---

## Motivation

I noticed users levels of access to certain microsoft features getting added and removed. It takes time to figure out the root cause is the change in the license assignment or access grant/deny of features within the license level. Here are my notes while analyzing a challenge.

# Key Points

- Microsoft administrator assigns user licenses.
- Licenses by default come with set of service plans/features (ex: `Microsoft Teams`).
- Microsoft administrator can limit the features selectively.
- User can be assigned with multiple licenses.
- Combined
- Every user can see their subscription at https://portal.office.com/account/?ref=MeControl
- Licenses can be assigned to any security group in Azure AD

## FAQ

- Where can I see the license assigned to me?

  - https://portal.office.com/account/?ref=MeControl#subscriptions

- As an MS Administrator, where can I find the licenses purchased for my organization?

  - Go to https://portal.azure.com --> Search/Navigate `Licenses` --> click `All Products` (https://portal.azure.com/#view/Microsoft_AAD_IAM/LicensesMenuBlade/~/Overview)

- As an MS Administrator, how can I view licenses assigned for particular user?
  - Go to https://portal.azure.com --> Search/Navigate `Azure Active Directory` --> click `Users` --> search the user --> Navigate to the user --> click licenses.
  - Refer `Assignment Paths` to understand how (from which security group) the user got the license assignment

## PowerShell commands

## Resources:

- https://learn.microsoft.com/en-us/azure/active-directory/enterprise-users/licensing-service-plan-reference
- https://learn.microsoft.com/en-us/azure/active-directory/enterprise-users/licensing-groups-assign
