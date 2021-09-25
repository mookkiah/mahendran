---
layout: post
title:  "Intercepting Kubernetes container to make changes temporarily"
date:   2021-09-25 03:51:00 -0400
categories: jekyll update
---

# Scenario

When working with Kubernetes, at times we may need make few changes to the environment or the files inside. Normally it is done by configuring `env` variables or adding `volumeMounts`. But what if we don't know what will be the exact working change we need to figure out with few attempts. When you wish you want to just intercept the startup and make some change and let it continue.

## Assumption
Lets assume you are using a docker image which has `CMD` as  `/app/entrypoint.sh` 





