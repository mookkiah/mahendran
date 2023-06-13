---
layout: post
title: "Service Accounts"
date: 2023-06-13 04:30:00 -0400
modified_date: 2023-06-13 07:10:00 -0400
categories: security service-accounts
---

# Service Accounts

## Motivation

We develop solutions so many ways to let systems communicate each other to accoplish a goal.
To trust and protect interaction, we create credentials which used to estabilsh the connection.

## What are service accounts

An identity for a non-human solution so that it proves it's identity to another software solution.
The subject which is used mainly in application-to-application integration, automation etc.

---

**_WARN_**
Using an authentication method tied to a single person also means relying on a single point-of-failure.

---

## Types of service accounts in Azure AD

- Manged Identities
- Service Principals
- User accounts

---

> **_NOTE:_**
> Use a managed identity when possible. If you can't use a managed identity, use a service principal. If you can't use a service principal, then use an Azure AD user account.

---

## Governance

- Implement strict approval process for creating service account creation.
- Have owner (still employed) identified and reviewed time to time.
- Define the purpose, lifetime, dependent applications documented somewhere (CMDB).
- Use standard naming such a way that it makes the wrong usage questionable by anyone.
- Grant least privilege and apply conditional policies so that it can't be misused.
- Never add service accounts in any group or Never create a group which can act as a service account.
- Schedule periodic review.
- Plan to change the credential and update only the application listed in CMDB as dependent for the service account.
- Never allow sharing service account which are not under one owner/responsible application.
- Define when this service account can be deleted.
- Send login attempts (both success and failures) to the `Security Information and Event Management (SIEM)`
- Have environment specific service accounts.

## Review/Audit process

- Gather the list of service accounts.
- Employ the ability to validate without involving the owner.
- If violation identified, initiate the audit process with owner.
- If challenge for having audit process, disable account after enough warnings.
- During the review, revisit the permission granted still necessary.
- If no or not enough violations to audit, pick random accounts to have the audit.
- Automate the violation alert and audit process as much as possible.

## References

- https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/govern-service-accounts
- https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals
- https://www.powercommunity.com/introducing-service-principal-and-managed-identity-support-on-azure-devops/
- https://www.imenos.com/en/power-platform-governance/improve-power-platform-governance-strategy-with-service-accounts/
