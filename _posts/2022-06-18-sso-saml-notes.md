---
layout: post
title:  "Lessons Learned from SAML based SSO implementations"
date:   2022-06-18 08:41:00 -0400
categories: sso saml
---

# Motivation
I am spending major part of these days on enabling SSO for applications through SAML protocol.
While many integrations are simple and can be completed very fast, there are challenges which gives new learning on SAML specification and differnt implementations. This blog shares those learnings.


## Force Authentication
While SSO meant to login once, an SP can make a SAML AuthnRequest with attribute `ForceAuthn="true"`. This will make the user to login again.


## AssertionConsumerServiceIndex vs AssertionConsumerServiceURL
SAML works based on a predefined contract. Both SP and IDP share their metadata during the integration phase. SP metadata normally includes one or more `AssertionConsumerService`. Those are indexed. While making SAMLRequest, SP can specify one of the URL or use the index.

Reference:
Sample AuthnRequest with `AssertionConsumerServiceIndex` 
```xml
<?xml version="1.0" encoding="UTF-8"?>
<samlp:AuthnRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" AssertionConsumerServiceIndex="2"
                    AttributeConsumingServiceIndex="1"
                    Destination="https://example.com/idp/profile/SAML2/Redirect/SSO" ForceAuthn="false"
                    ID="_da2b4fca-e840-46c4-823e-d1da37fc261f" IsPassive="false" IssueInstant="2022-04-20T15:04:20.161Z"
                    Version="2.0">
    <saml:Issuer xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion">QlikSense_TST</saml:Issuer>
</samlp:AuthnRequest>
```


Sample AuthnRequest with `AssertionConsumerServiceURL`
```xml
<samlp:AuthnRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
                    xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
                    ID="_4f0ed4dc7ed2aac59515b83109327223c76bb5e5ee"
                    Version="2.0"
                    IssueInstant="2022-05-22T11:52:03Z"
                    Destination="https://example.com/idp/profile/SAML2/Redirect/SSO"
                    AssertionConsumerServiceURL="https://ssp-sp-gluu-idp.mm-local.com/simplesaml/module.php/saml/sp/saml2-acs.php/default-sp"
                    ProtocolBinding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
                    >
    <saml:Issuer>https://ssp-sp-gluu-idp.mm-local.com/simplesaml/module.php/saml/sp/metadata.php/default-sp</saml:Issuer>
    <samlp:NameIDPolicy Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
                        AllowCreate="true"
                        />
</samlp:AuthnRequest>
```


