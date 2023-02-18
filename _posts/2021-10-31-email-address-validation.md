---
layout: post
title: "Email Addresses validation"
date: 2021-10-31 05:21:00 -0400
modified_date: 2023-01-12 19:03:00  -0400
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

|     ID      |          Title           |                                          Description                                          |                                                   Comment                                                   |
| :---------: | :----------------------: | :-------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------: |
|   R-1001    |       Regex Format       |                                     Standard Email format                                     |                                                 regex - TBD                                                 |
| R-1001- 101 | OWASP Recommended Format | Recommendation from [here](https://owasp.org/www-community/OWASP_Validation_Regex_Repository) |               `^[a-zA-Z0-9_+&*-]+(?:\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$`               |
|   R-1002    |    Legitimate domain     |                 Check the vailidity of address by checking the domain exists                  |                                                                                                             |
|   R-1003    |     Veriy MX records     |                                       Ask the MX server                                       |                                           Refer instruction - TBD                                           |
|   R-1004    | Disposable email domain  |                     Have a list of domains which offers disposable email                      |                                        Organization/Client wide list                                        |
|   R-1005    | Alias or Sub-Addressing  |                    Is the email address has charactors between `+` and `@`                    | These email addresses could be valid but application needs to know to avoid duplicate account in production |

## Implementation Help

Defining requirement is somewhat easy, but it is very complex to find ways to validate email address in realtime and give 100% confidence level. We may end up needing to maintain a cache (preferrably masked + hashed - to avoid leaking all email in one shot).

### Domain validation

### MX server existance check

To verify whether an email domain(the value after @ symbol in email address) has real mail exchange servers. We can query the mx records using `nslookup` commands.

We will see one or more `mail exchanger` if there is exchange behind the domain.

```
mahendran@mm-lab ~ % nslookup -q=mx gmail.com
Server:		192.168.1.1
Address:	192.168.1.1#53

Non-authoritative answer:
gmail.com	mail exchanger = 40 alt4.gmail-smtp-in.l.google.com.
gmail.com	mail exchanger = 5 gmail-smtp-in.l.google.com.
gmail.com	mail exchanger = 30 alt3.gmail-smtp-in.l.google.com.
gmail.com	mail exchanger = 10 alt1.gmail-smtp-in.l.google.com.
gmail.com	mail exchanger = 20 alt2.gmail-smtp-in.l.google.com.

Authoritative answers can be found from:
alt3.gmail-smtp-in.l.google.com	internet address = 172.253.62.27
alt1.gmail-smtp-in.l.google.com	has AAAA address 2607:f8b0:400d:c0f::1b
alt2.gmail-smtp-in.l.google.com	internet address = 108.177.12.26
alt4.gmail-smtp-in.l.google.com	internet address = 64.233.186.27
gmail-smtp-in.l.google.com	internet address = 172.217.215.27
gmail-smtp-in.l.google.com	has AAAA address 2607:f8b0:4002:c0f::1a
mahendran@mm-lab ~ % nslookup -q=mx mm-notes.com
Server:		192.168.1.1
Address:	192.168.1.1#53

Non-authoritative answer:
*** Can't find mm-notes.com: No answer

Authoritative answers can be found from:
mm-notes.com
	origin = ns39.domaincontrol.com
	mail addr = dns.jomax.net
	serial = 2021092603
	refresh = 28800
	retry = 7200
	expire = 604800
	minimum = 600

mahendran@mm-lab ~ %
```

The mail exchange server listens one or more of these ports 25(SMTP), 587(SMTP), 465(SMTPS), 2525.

```
mahendran@mm-lab ~ % nc -z -v -u gmail-smtp-in.l.google.com. 587
Connection to gmail-smtp-in.l.google.com. port 587 [udp/submission] succeeded!
mahendran@mm-lab ~ % nc -z -v -u gmail-smtp-in.l.google.com. 25
Connection to gmail-smtp-in.l.google.com. port 25 [udp/smtp] succeeded!
mahendran@mm-lab ~ % nc -z -v -u gmail-smtp-in.l.google.com. 465
Connection to gmail-smtp-in.l.google.com. port 465 [udp/igmpv3lite] succeeded!
mahendran@mm-lab ~ % nc -z -v -u gmail-smtp-in.l.google.com. 2525
Connection to gmail-smtp-in.l.google.com. port 2525 [udp/ms-v-worlds] succeeded!

```

### Verifying an email address with MX server

This section will show how to check with the exchange domain whether the email address exists or not

```
root@my-linux:~# nslookup -q=mx google.com
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
google.com	mail exchanger = 10 smtp.google.com.

Authoritative answers can be found from:

root@my-linux:~#
```

Here is the sample response from exchange server when email address found.

```
root@my-linux:~# telnet smtp.google.com 25
Trying 108.177.98.27...
Connected to smtp.google.com.
Escape character is '^]'.
220 mx.google.com ESMTP f2-20020a63de02000000b00478d123065bsi18165819pgg.402 - gsmtp
helo test
250 mx.google.com at your service
mail from: your.email@gmail.com
250 2.1.0 OK f2-20020a63de02000000b00478d123065bsi18165819pgg.402 - gsmtp
rcpt to: your.email@gmail.com
250 2.1.5 OK f2-20020a63de02000000b00478d123065bsi18165819pgg.402 - gsmtp
quit
221 2.0.0 closing connection f2-20020a63de02000000b00478d123065bsi18165819pgg.402 - gsmtp
Connection closed by foreign host.
```

Here is the sample response from exchange server when email address not found.

```
root@my-linux:~# telnet smtp.google.com 25
Trying 74.125.20.26...
Connected to smtp.google.com.
Escape character is '^]'.
220 mx.google.com ESMTP bm18-20020a656e92000000b004ace066f533si17174429pgb.177 - gsmtp
helo test
250 mx.google.com at your service
mail from: <your.email@gmail.com>
250 2.1.0 OK bm18-20020a656e92000000b004ace066f533si17174429pgb.177 - gsmtp
rcpt to: i_guess_no_one_will_have_this_address@gmail.com
550-5.1.1 The email account that you tried to reach does not exist. Please try
550-5.1.1 double-checking the recipient's email address for typos or
550-5.1.1 unnecessary spaces. Learn more at
550 5.1.1  https://support.google.com/mail/?p=NoSuchUser bm18-20020a656e92000000b004ace066f533si17174429pgb.177 - gsmtp
quit
221 2.0.0 closing connection bm18-20020a656e92000000b004ace066f533si17174429pgb.177 - gsmtp
Connection closed by foreign host.
root@my-linux:~#
```

Sometime we get acceptance even though the email id doesnt exists

```
mail from: i_guess_no_one_will_have_this_address@some.exchange.i.cant.share
250 2.1.0 Sender ok
rcpt to: i_guess_no_one_will_have_this_address@some.exchange.i.cant.share
250 2.1.5 i_guess_no_one_will_have_this_address@some.exchange.i.cant.share... Recipient ok
```

When sending email from an exchange to outside address, it should ask for authentication like this

```
rcpt to: your.email@gmail.com
550 5.7.1 your.email@gmail.com... Relaying denied. Proper authentication required.
```

Another senario - relying denied when trying to outside exchange domain

```
mail from: your.email@gmail.com
250 2.1.0 Sender ok
rcpt to: your.email@gmail.com
550 5.7.1 Relaying denied
rcpt to: your.email@same_domain_which_we_connected.com
250 2.1.5 Recipient ok
```

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

## References

- https://learn.microsoft.com/en-us/exchange/mail-flow/connectors/allow-anonymous-relay
- https://learn.microsoft.com/en-us/exchange/mail-flow/test-smtp-telnet
