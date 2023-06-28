---
layout: post
title: "SSO - Single and Global Logout"
date: 2023-06-27 21:30:00 -0400
modified_date: 2023-06-27 22:30:00 -0400
categories: sso logout
---

## Motivation

[Mahabharata Abhimanyu](https://www.nhsf.org.uk/2005/12/mahabharata-abhimanyu-and-the-chakra-vyuha/), the courageous son of the great Arjuna learned the technique to penetrate into Chakra-vyuha but did learned about getting out of it.

One way, we can't blame him (baby on the womb) learning as his uncle left without teaching as he finds her mom feel asleep.
Another way, he could have learned as he grow up (maybe due to other priorities).

Thinking of Abhimanyu's situaton when making an application user login successfully and not able to logout. Many IDP providers, Application developers, SSO implementers, and business analysts missed or payed less attention on logout compared to the login flow of single sign on.

In this page, I am describing my understanding of why it is complex and what components are all holds responsibility to complete the logout flow. Also share some of the opensource products and their level of completion as per my knowledge and at the time of writing.

## Major specifications related to SSO

- SAML
- OIDC
- WS-FED
- PassportJS

Even though there are many specification, all of them solves common problem in the way layman can expects the login and logout to work.
For next few section, I refrain myself avoiding technical terms.

## Login and Logout Flow

Reference diagram to understand flow at differnt scenarios.

<img src="/assets/images/sso-logout.png">

### Application Managed Authentication

When the authentication managed by the application, application has full control how the login page should look like, how to validate user credential and where to take the user upon login/logout step.

### SSO Logout Types

#### Single Logout

SSO meant to ask the user to login once and allow to bypass login for other integrated application seemlessly. Some IDP offers logout for the application where user initiated the login. But it is not really useful from security standpoint as it MAY leave the IDP still logged in. Some IDP will ask for user to login if the same application initiates login process. However it will let other application continue to stay logged in.
This is where more confusion happens. It is mostly because IDP's flexibility to configure and the incomplete/incorrect setup.

#### Global Logout

When user initiates logout in any one of the integrated application, IDP properly performs the logout by propagating the user intent to leave the system at its BEST effort to logout by triggering all application to terminate the user session. In order to achive full security, ALL the application must be configured with the logout setting which allows it without asking any user interaction. Not all application supports this. It is not guarenteed as well.

### SSO Identity Provider (IDP) Managed Authentication

When the authentication managed by a SSO solution(IDP), application does not control the login page. Control between application and IDP exchanged via browser redirects. So the setup process involves exchanging urls to redirect after successful login and logout.

In this scenario, when the user clicks logout, application reaches out IDP to logout. IDP will propagate the intent to logout to all logged in applications (this is not visible to the user). Upon successful logout, it redirects the user to the configured logout page by the application which originates the logout.

### SSO Federated login

This method is more complicated as the trust getting transferred across multiple systems. Many variotions of this named like includes chained federation, social login, passport login, cross-tenant etc.,

https://gitlab.com/users/sign_in allows to login with Google, Github, Twitter, Bitbucket, Salesforce
https://www.linkedin.com/ allows to login with Google
https://login.salesforce.com/ allows to login with custom domain (with your company domain)
https://breadbutter.io/ allows to login with
https://kanboard.discourse.group/ allows to login with github, gitlab
https://office.com allows to login with your company/personal microsoft office 365 account

<img src="/assets/images/chained-login.png">

- Imagine you logged in your company domain account as part of accessing https://office.com.
- Now you have logged into office.com application and Microsoft IDP.
- Then you are visiting salesforce where you can choose login with domain in order to skip the login process.
- Now you have automatically logged in to salesforce application and its salesforce IDP.
- Then you are visiting Gitlab using salesforce federation.
- Now you have automatically logged in Gitlab app and Gitlab IDP
- Then you are visiting Kanboard using Gitlab federation
- Now you have automatically logged in Kanboard application.

Now you can see the trust is formed as chain. User may click logout in any one of the application (office, salesforce, gitlab, kanboard)

---

> Note: I have not tried these many federation. But I believe it should work.

---

If ALL these applications and IDP properly implements the global logout with propogation, user can click logout once to terminate all the sessions.
If you are curious, try it out.

## References

- https://www.nhsf.org.uk/2005/12/mahabharata-abhimanyu-and-the-chakra-vyuha/
- https://docs.cyberark.com/Product-Doc/OnlineHelp/Idaptive/Latest/en/Content/Applications/AppsCustom/WsFedSSO.htm
