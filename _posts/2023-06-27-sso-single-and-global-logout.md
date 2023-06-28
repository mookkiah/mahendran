---
layout: post
title: "SSO - Single and Global Logout"
date: 2023-06-27 21:30:00 -0400
modified_date: 2023-06-27 22:30:00 -0400
categories: sso logout
---

## Motivation

[Mahabharata Abhimanyu](https://www.nhsf.org.uk/2005/12/mahabharata-abhimanyu-and-the-chakra-vyuha/), the courageous son of the great Arjuna, learned the technique to penetrate the Chakra-vyuha but did not learn how to get out of it.

One way we can't blame him (as a baby in the womb) for not learning, as his uncle left without teaching him when he found his mother asleep. Another way, he could have learned as he grew up (poor boy with other priorities or considering it as [YAGNI](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it)).



Thinking of Abhimanyu's situation, when making an application, the user can log in successfully but not able to log out. Many IDP providers, application developers, SSO implementers, and business analysts missed or paid less attention to the logout process compared to the login flow of single sign-on.

In this page, I am describing my understanding of why it is complex and which components are responsible for completing the logout flow. I will also share some of the open-source products and their level of completion as per my knowledge and at the time of writing.

## Major specifications related to SSO

- [SAML](http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0.html)
- [OIDC](https://openid.net/specs/openid-authentication-2_0.html)
- [WS-FED](http://docs.oasis-open.org/wsfed/federation/v1.2/os/ws-federation-1.2-spec-os.html)
- [PassportJS](https://www.passportjs.org/packages/)

Although there are many specifications, all of them solve the common problem of how a layman expects the login and logout processes to work. 

For the next few sections, I will try refraining from using technical terms.

## Login and Logout Flow

Please refer to the diagram below to understand the flow in different scenarios.

<img src="/assets/images/sso-logout.png">

### Application Managed Authentication

When authentication is managed by the application, the application has full control over how the login page should look, how to validate user credentials, and where to take the user upon login/logout steps.

### SSO Logout Types

#### Single Logout

SSO aims to ask the user to log in once and then allows them to bypass login for other integrated applications seamlessly. Some IDPs offer logout for the application where the user initiated the login. However, this is not really useful from a security standpoint as it MAY leave the IDP still logged in. Some IDPs will ask the user to log in if the same application initiates the login process. However, this allows other applications to continue to stay logged in, leading to confusion. This is mostly due to the IDP's flexibility to configure and incomplete/incorrect setup.


#### Global Logout

When a user initiates logout in any one of the integrated applications, the IDP properly performs the logout by propagating the user's intent to leave the system at its BEST effort to logout by triggering all applications to terminate the user session. To achieve full security, ALL applications must be configured with the logout setting that allows it without asking for any user interaction. However, not all applications support this, and it is not guaranteed either.


### SSO Identity Provider (IDP) Managed Authentication

When authentication is managed by an SSO solution (IDP), the application does not control the login page. Control between the application and IDP is exchanged via browser redirects. The setup process involves exchanging URLs to redirect after successful login and logout.

In this scenario, when the user clicks logout, the application reaches out to the IDP to logout. The IDP will propagate the intent to logout to all logged-in applications (this is not visible to the user). Upon successful logout, it redirects the user to the configured logout page by the application that originated the logout.

### SSO Federated login

This method is more complicated as trust is transferred across multiple systems. There are many variations of this, such as chained federation, social login, passport login, cross-tenant, etc.


Here are a few examples of federation or social login:

- https://gitlab.com/users/sign_in allows to login with Google, Github, Twitter, Bitbucket, Salesforce
- https://www.linkedin.com/ allows to login with Google
- https://login.salesforce.com/ allows to login with custom domain (with your company domain)
- https://breadbutter.io/ allows to login with
- https://kanboard.discourse.group/ allows to login with github, gitlab
- https://office.com allows to login with your company/personal microsoft office 365 account

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

If ALL these applications and the IDPs are properly implement global logout with propagation, the user can click logout once to terminate all the sessions. 

If you are curious, try it out.


## References

- https://www.nhsf.org.uk/2005/12/mahabharata-abhimanyu-and-the-chakra-vyuha/
- https://docs.cyberark.com/Product-Doc/OnlineHelp/Idaptive/Latest/en/Content/Applications/AppsCustom/WsFedSSO.htm
