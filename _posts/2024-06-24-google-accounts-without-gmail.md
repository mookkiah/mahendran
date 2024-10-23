---
layout: post
title: "Google account without GMail"
date: 2024-06-24 19:58:00 -0400
modified_date: 2024-06-24 19:58:00 -0400
categories: gsuite gdrive
---

## Purpose

Google offers free services for nominal use for both personal and business purpose. For businesses who wants to have their own office workspace solution (like Microsoft O365), google offers GSuite. But it

Often businesses needs to share Google services (ex: GDrive) to outside organization. At the sametime not to allow personal accounts (with gmail domain) from accessing the business documents/resources.

Also it is good not to use personal accounts and avoid mixing personal and business documents, it is recommended getting separate google account.Even better, create a google account so your business partners can simply use your business mail address to share their google storage contents and collaborate.

## Setup global access policy

Configure global setting for Google Shared Drive based on the need.

- Completely disable sharing outside domain
- Allow only whitelisted domains
- Allow only with Google accountss
- Allow public if they know the link

## Protecting GSuite/GDrive by whitelisting domains

https://admin.google.com/ac/domains/allowlisted

## Creating Google account with external domain

- Logout previously logged in google accounts or open browser in "private browsing / incognito" mode
  <img src="/assets/images/google-with-external-account-1.png">

- At the sign in screen, follow create account flow. Choose "For work or my business"
  <img src="/assets/images/google-with-external-account-2.png">

- Fill the required fields
  <img src="/assets/images/google-with-external-account-3.png">

- Google recommends few email address with gmail domain. Because we want to use our business email based google account, select `User your existing email`
  <img src="/assets/images/google-with-external-account-4.png">

- Provide work mail address
  <img src="/assets/images/google-with-external-account-5.png">

- Verify the ownership of the email you provided
  <img src="/assets/images/google-with-external-account-6.png">

- Create password
  <img src="/assets/images/google-with-external-account-7.png">

- Missing screenshot for setting up MFA.
- Confirm the ownership of MFA device
  <img src="/assets/images/google-with-external-account-8.png">

- Skip setting up business unless you want a GSuite account (This is only required if you are the org admin)

<img src="/assets/images/google-with-external-account-9.png">

## For admins global settings

- Individual shared drive members and access can be setup under managedrive settings.
  <img src="/assets/images/google-with-external-account-admin-10.png">

  <img src="/assets/images/google-with-external-account-admin-11.png">

## Resources

- https://apps.google.com/supportwidget/articlehome?hl=en&article_url=https%3A%2F%2Fsupport.google.com%2Fa%2Fanswer%2F60781%3Fhl%3Den&assistant_event=welcome&assistant_id=mega-bot-shared-drive&product_context=60781&product_name=UnuFlow&trigger_context=a&fragment=restrict_sharing_to_domains
