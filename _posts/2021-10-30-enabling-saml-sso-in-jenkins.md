---
layout: post
title:  "Configuring Jenkins with SAML based SSO"
date:   2021-10-30 5:42:00  -0400
categories: security saml
---

# Motivation
I needed a SAML SP which supports SingleLogOut(SLO) 

## Pre-requsite
- Jenkins
  - If you don't have one spin up one quickly - Use [this post]({% link _posts/2021-10-30-jenkins-in-kubernetes.md  %}) if you have Kubernetes
- SAML IDP (we will use samltest.id for keep the document light)


## Preparing Jenkins

### Installing plugin
  Note: Jenkins needs internet access to install plugins interactively.

Jenkins --> Manage Jenkins --> Type `saml` in the filter text box. If it is not installed find it in Available.

Install [SAML](https://plugins.jenkins.io/saml/) plugin. 


### Configuring SP


Jenkins --> Manage Jenkins --> Configure Global Security
Under `Security Realm` select `SAML 2.0`
Fill 
- `IdP Metadata URL`: https://samltest.id/saml/idp
- `Username Attribute`: uid
- `Email Attribute`: mail

  Note:
  When user login, SAMLResponse sent from IDP to SP(Jenkins) with user attributes.
  More samltest.id provided attribute can be found [here](https://samltest.id/download/)


Click `Service Provider Metadata` which will open Jenkins(SP) metadata in another browser tab with url like `https://jenkins.example.com/securityRealm/metadata`

Save the contents into `jenkins-sp.xml`.

### Configuring IDP

For samltest.id, first [upload](https://samltest.id/upload.php). your SP metadata. In our case jenkins-sp.xml.

Then click [Test your SP](https://samltest.id/start-sp-test/) which presented after successful metadata upload.

To test the IDP initiated flow with "Unsolicited Login Initiator", enter the `entityID` value from jenkins-sp.xml file

Save configuration.

  Note: Until you successfully tested the SAML based login works, DO NOT logout from jenkins. Use Incognito/Private browser window to test SAML login

Now when you access Jenkins url, you will be routed to IDP(samltest) login page. In samltest.id there are some test user credential will be present in the login page. With that you will be able to login and you will be redirected to Jenkins home page.



## Logout
Implementing logout is challenging part in SAML.


Jenkins --> Manage Jenkins --> Configure Global Security
Under `Security Realm` select `SAML 2.0`

- `Logout URL` : This should be your IDP global logout url. 

  Note: If you dont configure proper `Logout URL`, when you click logout in jenkins it only perform local logout (clearing session). As long as IDP session active, clicking login will take you back to Jenkin without asking credential.

When Jenkins not perfomring global logout, it will present a message like this to warn you 


<img src="/assets/images/dont-runaway.png">

When you click login it will warn us so we know next time

<img src="/assets/images/only-local-logout.png">

Ask your IDP provider for logout url. For example for [Gluu](https://gluu.org/docs/gluu-server/4.0/operation/logout/#saml-logout) it is something like `https://[idp-hostname]/idp/Authn/oxAuth/logout`


## Resources
You can find more configuration infromation [here](https://github.com/jenkinsci/saml-plugin/blob/master/doc/CONFIGURE.md)
