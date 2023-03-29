---
layout: post
title: "Microsoft Power Platform - COE Starter Kit setup"
date: 2022-12-11 07:34:00  -0400
modified_date: 2022-12-12 17:08:00  -0400
categories: microsoft powerplatform governance
---

# Motivation

While Microsoft provides Power Platform solutions like PowerApps, PowerAutomate, PowerBI almost free to get started.
For an enterprise, these solutions need to be evaluated before letting the business to start using it.
It is IT team responsibility to implement a governance around so that we are keeping a manageble environment and support the business with higher qualities of service.

Microsoft recommends to take advantage fo CoE Starter Kit to create a strategy for adopting Microsoft PowerPlatform and implement a governance with the power of data.

## Goal

The Microsoft Power Platform CoE Starter Kit is a collection of components and tools that are designed to help you get started with developing a strategy for adopting and supporting Microsoft Power Platform

Our goal is to setup COE starter kit.

## Required Access

We need power platform adminstrator access which is provided by Microsoft 365 admin by assigning the necessary role.
If the role needs activation, we need to activate it in order to really use it.

Go to portal.azure.com
Home --> Privileged Identity Management(PIM) -> My roles
Azure AD roles - Eligible assignments - Click activate "Power Platform Administrator"

Only when you activate the roles to be a power platform adminstrator, it shows up environments created by others.
It takes time (around 20 mins) to reflect the elivated permission. Until then we will not create(even view some) environment.

## Challenges

We had an admin account to perform the role of Power Platform Adminstration.
But the admin account doesn't have various licenses. email address, etc to perform certain operations.
Lessons learned, we need regular user account which has necessary licenses assigned to perfom COE starter kit installation.
But regular user doesnt have access for all the environments.

## Steps:

Gett started with setup - read prerequisites - use admin account - account must be email enabled

- Dedicated environment
- Power Platform admin account to create environment and manage policies
- A service account (say `pp_coe_admin`) with E5 license to make the most of apps and flows to work.
- Following security groups with email enabled (configure `pp_coe_admin` to add/remove users to these security groups)
  - power_platform_makers (required for `Add Maker to Group` flow - value for `admin_PowerPlatformMakeSecurityGroup`)
  - power_platform_users (required for `Add Maker to Group` flow - value for `admin_PowerPlatformUserGroupID`)
- License - per user license as we work with multiple apps and assign it for above service account
- Azure Active Directory app registration - to configure client id and secret to make Graph API calls by the COE starter kit.
- If MFA enabled, it should have long expiration or conditional access - https://learn.microsoft.com/en-us/troubleshoot/power-platform/power-automate/conditional-access-and-multi-factor-authentication-in-flow

### Create Environment

- Creating environment requires elivated permission (Hint to use/request power platform admin)
- Having dedicated environment for COE governanace will help as we will have more connectors and privillege to install/function COE starter kit
- Request Power Platform administrator to create an enviroment and make the service account (`pp_coe_admin`) as the `System Administor` for that environment.
- Request to enable Power Apps code components for Canvas apps feature in the Environment settings.
- If you have more restriction (normally we do) for `Default DLP policy`, exclude this environment from it by editing the policy.

### Create DLP Policy

- As COE starter kit solutions needs more connectors (some of them are premium), its recommended to have separate DLP policy and assign it to the environment.
- Whenever we get error to due to policy restriction, we need to edit this policy to give permission.

### Importing solutinos to the environment

As a `system administrator` of the environment,

PowerApps
Solutions - Import solution - downloaded - Core componets zip

```
Solution "Creator Kit" imported successfully.
Solution "CreatorKitReferences (MDA)" imported successfully.
Solution "CreatorKitReferences (Canvas)" imported successfully.
Solution "Center of Excellence - Core Components" imported successfully.
16 environment variables need to be updated.
```

Set up the collection (invetory/core) components - https://learn.microsoft.com/en-us/power-platform/guidance/coe/setup-core-components
core
audit log data
power bi report

https://www.youtube.com/embed/Z9Vp2IxFzpU

After import of the Core components and before you turn on flows, set the value of the is All Environments Inventory environment variable to No
This environment variable definition cannot be edited because it is in a managed solution.

After changing the value of an environment variable, you'll need to turn off and on all the flows that use that environment variable to make sure the flows use the latest value.

You will see banner message about missing the environment variables `current value`. Once you set them up, they disappear from the banner and the list on right pane. If you want to change/view the environment variable `current value`, go to https://make.powerautomate.com/ --> `Solutions` -> `Default solution` --> `Environment variables` --> use the context button on the variable to edit.

Admin | Sync Template v3 --> Running this flow will also trigger the rest of the sync flows indirectly

Admin data policy 'Default Policy' restricts use of these apis: Http.

Admin data policy 'Default Policy' restricts use of these apis: /providers/Microsoft.PowerApps/apis/shared_powerappsforadmins.
https://learn.microsoft.com/en-us/power-platform/admin/dlp-combined-effect-multiple-policies
we highly recommended that you apply a minimum number of DLP policies to any given environment

Create new DLP and add [required connectors](https://learn.microsoft.com/en-us/power-platform/guidance/coe/setup#validate-data-loss-prevention-dlp-policies) as busness connectors. Otherwise you get errors similar to one of the `Errors and Resolutions` section

Turn on failed. Flow client error returned with status code "Forbidden" and details "{"error":{"code":"MissingAdequateQuotaPolicy","message":"The user 'd5c8cedf-e3b3-4135-b771-17accc2b3f30' does not have a service plan adequate for the non-Standard connection 'Microsoft Dataverse (legacy)'. https://go.microsoft.com/fwlink/?linkid=2123710","extendedData":{}}}".

Organize internal events such as training workshops and hackathons

Office 365 Management API - Azure APP registration - OAuth 2.0
Redirect URI (generated after updating custom connector) but most like it is standard one - https://global.consent.azure-apim.net/redirect

Permissions:

```
Office 365 Management APIs
ActivityFeed.Read   Delegated
ActivityFeed.Read   Application
ServiceHealth.Read  Application
```

Test the custom connector by creating new connection based on the connector.

### Import Audit Log Solution

Sandbox

Findings:
Create "CoE Admin" distribution list.
Create Power Platform Maker Group ID - https://learn.microsoft.com/en-us/power-platform/guidance/coe/setup#how-will-you-communicate-with-your-admins-makers-and-end-users

Refernces:
https://learn.microsoft.com/en-us/power-platform/guidance/adoption/admin-best-practices
https://learn.microsoft.com/en-us/power-platform/guidance/
https://learn.microsoft.com/en-us/power-platform/guidance/coe/starter-kit

## Excercise

- What is the trend of apps month to month?
- What are the apps not used in last 90 days?
- What are the flows failed and not used/edited for last 90 days?
- What are the apps uses premium connectors?
- Which app consumes most licenses?
- What is the cost of each apps?

Dataverse for teams

## Errors and Resolutions

When enabling "Environment -> Cloud flows --> CLEANUP - Admin | Sync Template v3 (Check Deleted)"...

Turn on failed. Flow client error returned with status code "Forbidden" and details "{"error":{"code":"ApiPolicyApiGroupViolation","message":"Admin data policy 'PP-Admin-Policy' restricts use of these apis: /providers/Microsoft.PowerApps/apis/shared_powerplatformforadmins.","extendedData":{"violation":{"policyId":"/providers/Microsoft.BusinessAppPlatform/scopes/service/environments/f462ca1x-8300-ea79-8129-aab9571ee742/apiPolicies/14cc42c3-6b83-4eae-a253-f0662bcf1997","policyDisplayName":"PP-Admin-Policy","type":"BlockedConnector","parameters":["/providers/Microsoft.PowerApps/apis/shared_powerplatformforadmins"]},"additionalInfo":{}}}}".

https://docs.microsoft.com/connectors/powerplatformforadmins

Move "Power Platform for Admins" to business in the DLP - PP-Admin-Policy

---

Turn on failed. Flow client error returned with status code "Forbidden" and details "{"error":{"code":"ApiPolicyApiGroupViolation","message":"Admin data policy 'PP-Admin-Policy' restricts use of these apis: /providers/Microsoft.PowerApps/apis/shared_flowmanagement.","extendedData":{"violation":{"policyId":"/providers/Microsoft.BusinessAppPlatform/scopes/service/environments/f462ca1x-8300-ea79-8129-aab9571ee742/apiPolicies/14cc42c3-6b83-4eae-a253-f0662bcf1997","policyDisplayName":"PP-Admin-Policy","type":"BlockedConnector","parameters":["/providers/Microsoft.PowerApps/apis/shared_flowmanagement"]},"additionalInfo":{}}}}".

Admin data policy 'PP-Admin-Policy' restricts use of these apis: /providers/Microsoft.PowerApps/apis/shared_powerappsforadmins.

Move "Power Apps for Admins" to business in the DLP - PP-Admin-Policy

---

Turn on failed. Flow client error returned with status code "Forbidden" and details "{"error":{"code":"ApiPolicyApiGroupViolation","message":"Admin data policy 'PP-Admin-Policy' restricts use of these apis: /providers/Microsoft.PowerApps/apis/shared_flowmanagement.","extendedData":{"violation":{"policyId":"/providers/Microsoft.BusinessAppPlatform/scopes/service/environments/f462ca1x-8300-ea79-8129-aab9571ee742/apiPolicies/14cc42c3-6b83-4eae-a253-f0662bcf1997","policyDisplayName":"PP-Admin-Policy","type":"BlockedConnector","parameters":["/providers/Microsoft.PowerApps/apis/shared_flowmanagement"]},"additionalInfo":{}}}}".

Move "Power Automate Management" to business in the DLP - PP-Admin-Policy

---

Turn on failed. Flow client error returned with status code "Forbidden" and details "{"error":{"code":"ApiPolicyDataFlowViolation","message":"Admin data policy 'PP-Admin-Policy' restricts the use of /providers/Microsoft.PowerApps/apis/shared_powerplatformforadmins with /providers/Microsoft.PowerApps/apis/shared_commondataserviceforapps.","extendedData":{"violation":{"policyId":"/providers/Microsoft.BusinessAppPlatform/scopes/service/environments/f462ca1x-8300-ea79-8129-aab9571ee742/apiPolicies/14cc42c3-6b83-4eae-a253-f0662bcf1997","policyDisplayName":"PP-Admin-Policy","type":"BusinessAndNonBusinessConnector","parameters":["/providers/Microsoft.PowerApps/apis/shared_powerplatformforadmins","/providers/Microsoft.PowerApps/apis/shared_commondataserviceforapps"]},"additionalInfo":{}}}}".

---

Turn on failed. Flow client error returned with status code "Forbidden" and details "{"error":{"code":"MissingAdequateQuotaPolicy","message":"The user 'd5c8cedf-e3b3-4135-b771-17accc2b3f30' does not have a service plan adequate for the non-Standard connection 'Microsoft Dataverse'. https://go.microsoft.com/fwlink/?linkid=2123710","extendedData":{}}}".

---

Turn on failed. Flow client error returned with status code "Forbidden" and details "{"error":{"code":"ConnectionAuthorizationFailed","message":"The caller object id is '5e89017c-91db-4706-8553-dd7753b8d655'. Connection '/providers/Microsoft.PowerApps/apis/shared_powerplatformforadmins/connections/5233afd2b5e94e4a9f336517493762f8' to 'shared_powerplatformforadmins' cannot be used to activate this flow, either because this is not a valid connection or because it is not a connection you have access permission for. Either replace the connection with a valid connection you can access or have the connection owner activate the flow, so the connection is shared with you in the context of this flow."}}".

---

Turn on failed. Flow client error returned with status code "Forbidden" and details "{"error":{"code":"MissingAdequateQuotaPolicy","message":"The user 'd5c8cedf-e3b3-4135-b771-17accc2b3f30' does not have a service plan adequate for the non-Standard connection 'Microsoft Dataverse'. https://go.microsoft.com/fwlink/?linkid=2123710","extendedData":{}}}".

---

Add Maker to Group - failed because ListGroupMemebers (https://learn.microsoft.com/en-us/connectors/office365groups/#list-group-members)
Resource '75ad7a41-5ebd-4a9d-85f8-245424758932' does not exist or one of its queried reference-property objects are not present.

---

Flow client error returned with status code "BadRequest" and details "{"error":{"code":"InvalidOpenApiFlow","message":"Flow save failed with code 'WorkflowOperationInputsApiOperationNotFound' and message 'The 'inputs' of workflow operation 'List_audit_log_content' of type 'OpenApiConnection' are not valid. The API operation 'ListContent' could not be found in API 'admin-5foffice-20365-20management-20api-5f55ff5bc0051fd172'.'."}}".

Permissions > Microsoft Purview compliance portal > Roles to assign this role to a role group or contact your admin who can assign permissions. Learn more
