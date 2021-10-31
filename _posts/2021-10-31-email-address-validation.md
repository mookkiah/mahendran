---
layout: post
title: "Email Addresses validation"
date: 2021-10-31 05:21:00 -0400
categories: blog email-validation
---

# Knowing Email Addresses
Email addresses format has two parts namely the mailbox and the dns address which holds the MX records. They both separated with `@` character.

Here are some valid mail formats
- john.smith@example.com
- john.smith@example.anything
- john.smith@anyhost
- john.smith@1.2.3.4
- john.smith+alias@example.com (Called Alias email or Sub-Addressing)
- john.1123@example.com

Eventhough these could be valid email addresses, some of them scares us to believe/trust to exchange email.
When building application which takes email as user input, it is important to validate to keep the unwanted guests(hacker/DoS attackers) away.

So we must validate the email address before accepting/processing it by the application.

There are regular expressions (regex) which we can use validate the format

- User friendly formats
- Valid format with real domain
- Valid by checking with the mail server about existence of mailbox
- Blocklist certain email domains which are are for meant for testing - called `Disposable Email Address` or not safe/allowed (defined by the organization).

    Note: Eventhough all the above can be defined by one regex - It becomes unmaintainable over a period of time.

## OWASP Recommendation
OWASP advices application to [validate email in various aspect](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html#email-address-validation).


## Organizational Challenge
Implementing email validation in every application is challenging for the organization. And implementing it with all the best practices makes even harder. 

There are three ways to face the challenge
1. Define low level requirement document with regular expressions, block listed domains and process/commands to validate email addresses.
1. Develop/Host an organization wide email validator service.
1. Subscribe commercial email validator service. 

For an enterprise with 100s of application, I would recommend building orgainzation wide email validator service as agile manifesto says `working software over comprehensive documentation` and avoid paying reqular bills. 

## Requirement or Test Cases
Regardless of any option we choose to validate, we should define the requirements for email address validation. Also we should be able to come up with test cases.
Once we start writing requirement, we end up not just have boolean result like valid/not-valid. Not valid email address will have one or more reasons. Application/Client would expect the reasons for not-valid. So it is better to have a response with details and score/confident-level to help application to decide without manual intervention.


### Recommended Requirement with reason

For easy discussion and grouping similar requirements closer, I am using the requirement ID with format R-XXXX-XXX


| ID            | Title    | Description   | Comment     | 
| :----:        |     :----:   |  :----:        | :----: |
| R-1001        | Regex Format       | Standard Email format   | regex - TBD  |
| R-1001- 101 | OWASP Recommended Format| Recommendation from [here](https://owasp.org/www-community/OWASP_Validation_Regex_Repository) | `^[a-zA-Z0-9_+&*-]+(?:\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$]`|
| R-1002     | Legitimate domain        | Check the vailidity of address by checking the domain exists      |  |
| R-1003 | Veriy MX records | Ask the MX server | Refer instruction - TBD|
| R-1004 | Disposable email domain | Have a list of domains which offers disposable email | Organization/Client wide list |
| R-1005 | Alias or Sub-Addressing | Is the email address has charactors between `+` and `@` | These email addresses could be valid but application needs to know to avoid duplicate account in production |


## Implementation Help
Defining requirement is somewhat easy, but it is very complex to find ways to validate email address in realtime and give 100% confidence level. We may end up needing to maintain a cache (preferrably masked + hashed - to avoid leaking all email in one shot).

### Domain validation

### MX server existance check

### Verifying with MX server

### Maintaining Disposable Email Provider List

### Maintaining Blocklisted Domains

### Caching Email Address Safely

### Getting confidence level from email responses
- Ask application to share the vailidty when user reacts. 
- Asking internal mail server to feed from addresses
- 

### Maintaining Do-Not-Email list - Safely


## Real open source implementation
I do follow the princible of `don't develop what you can download` (ofcourse from legitmate source). When I look for docker image which we could use as email address validator as REST service, I did not find one at this time of writing. Maybe not looked properly, please comment(Ah!, I have to find how to get comments on github pages :smile: ) if you find one. 

So decided to write one and use the opportunity to learn a new web programming language.