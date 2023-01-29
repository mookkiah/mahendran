---
layout: post
title: "Keep Password Safely and Share Responsibility Securely"
date: 2023-01-17 00:03:00 -0400
modified_date: 2023-01-28 07:45:00 -0400
categories: security
---

## Motivation
Passwords meant to remembered in brain. We are finding new ways to avoid stressing brain with too many passwords to remember and move to password-less space and utilize multi factor authentication. Still we have to admit we are sharing passwords with family members and in small business it is more likely to have more than one person have the credential to some accounts (for various reasons).

At any event storing password as plain text is receipe for disaster. This is my learning while I am in search to find a suitable solution for me. While I may use my product names and my opinion, I am not recommending or writing good/bad review about them.  


## Bad Practices
- Sharing password in shared plain text document (email/one drive/google drive etc).
- Maintaining a hand written book at office safe.
- Having same password for almost all accounts.
- Using predictable pattern.


## Possible solutions
- Allowing browser to remember - Simple but not safe.
- Using secret vault software at user personal computer.
- Using third party SaaS solutions.

## Use token instead of password
There are times we may need to share access with someone else. There are application which allows us to create token with validity. This can be used as temporary password. Example GitHub.


## Password Managers
There are password managers which allows to share password with others view only. If the application has MFA, this is not going to be useful.
Consider this option only if you dont have roles/permission/IAM feature or delegate feature in the application.

## Team/Delegate access
The influence of MFA reduced the sharing password practice. This created demand for applications to offer better option to delegate and work as a team instead of individual. It is good.

- https://www.facebook.com/business/help/129163424435437
- https://www.godaddy.com/help/invite-a-delegate-to-access-my-godaddy-account-12376
- https://www.linkedin.com/help/lms/answer/a425731/user-roles-and-permissions-in-campaign-manager?lang=en
- https://www.linkedin.com/help/recruiter/answer/a478392/hiring-manager-project-level-permissions-overview?lang=en
- https://business.twitter.com/en/help/troubleshooting/multi-user-login-faq.html
- Use AWS IAM User


## General (tool agnostic) best practice
- Use single sign on
- Use multi factor authentication
- Have complex pass phrase as master password
- Perform self audit on security
- Implement Identity and Access Management (IAM)

## Indivdual account and share role/permission
- Enterprise applications provide very good role permission management.
- Cloud infrastructure provides IAM feature free and highly recommend it.


## For Employers Application/Product owners
- Implement SSO
- Add Multi Factor Authentication(MFA)
- Let the end user to choose their prefered MFA.
- Introduce step-up authentication if required.
- Ask user consent before accessing personal information (PII/HIPAA)
- Try to follow how major banks keeps your information safe. Give the same for your customer.
- Constantly have security awareness training program.
- Provide tools to keep password safe within organization and not to mix with personal and professional secrets together.

