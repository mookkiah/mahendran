---
layout: post
title:  "Configuring Jenkins with OIDC based SSO"
date:   2021-10-30 8:431:00  -0400
categories: security oidc
---

# Motivation
I needed a SAML SP which supports SingleLogOut(SLO) 

## Pre-requsite
- Jenkins
  - If you don't have one spin up one quickly - Use [this blog](https://mm-notes.com) if you have Kubernetes
- OpenId Connect IDP


## Preparing Jenkins

### Installing plugin
  Note: Jenkins needs internet access to install plugins interactively.

Jenkins --> Manage Jenkins --> Type `oic-auth` in the filter text box. If it is not installed find it in Available.

Install [oic-auth](https://plugins.jenkins.io/oic-auth/) plugin. 



### Configuring IDP

Register Jenkins as OIDC client in your IDP.
You will need these details

- Login Redirec URI: ${JENKINS_ROOT_URL}/securityRealm/finishLogin
- Logout Redirect URI: ${JENKINS_ROOT_URL}/OicLogout
- scope: openid email
- Grant Type: authorization_code
- Response Types: code, token, id_token

Generate Client ID and Secret which we will use in next step at Jenkins configuration

### Configuring Jenkins

Jenkins --> Manage Jenkins --> Configure Global Security
Under `Security Realm` select `Login with Openid Connect `

Gather OIDC IDP endpoints. Normally IDP provides `.well-known/openid-configuration` which has all the details client need to know.
We can use this url as `Well-known configuration endpoint` under `Automatic configuration` options.

For example google's OIDC details can be found - https://accounts.google.com/.well-known/openid-configuration

Configure Client ID and Secret from IDP.

