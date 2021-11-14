---
layout: post
title:  "Skipping the SSL validation only when it interferes your development"
date:   2021-09-25 17:41:00 -0400
categories: jekyll update
---

# Scenario
When you are working with an interface which uses SSL, you may get error related to SSL handshake/validation/certificate. But you have to focus on the problem not resolving SSL error. 

Normally you will encounter these problem when the target system uses self signed certificate or your organization use internal certificate authroity.

You really don't want to skip the SSL validation for production.
For every tools there is a right way to do trust a SSL certifcate which used by the target system. If really the certificate expired or not trustable then you should contact the target system owner.

## Tools
Differnt tools will get you the SSL error.

### Git
```
git config http.sslVerify false
```

### Python
```
export PYTHONHTTPSVERIFY=0
```

### Java
There is no easy way...

#### Maven
```
export MAVEN_OPTS="-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true"

```

### curl
```
curl -k https://self-signed.badssl.com/
```
### wget

```
wget --no-check-certificate  https://self-signed.badssl.com/
```

### npm
```
npm set strict-ssl false
```

### kubectl
```
kubectl --insecure-skip-tls-verify get namespaces
```