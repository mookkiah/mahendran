---
layout: post
title:  "Installing JDK on Ubuntu"
date:   2021-11-25 12:55:00 -0400
categories: ubuntu java
---

## Environment
- Ubuntu 20-04 running in Mac M1 using parallel

When Java not installed...
```
parallels@ubuntu-linux-20-04-desktop:~$ java -version

Command 'java' not found, but can be installed with:

sudo apt install default-jre              # version 2:1.11-72, or
sudo apt install openjdk-11-jre-headless  # version 11.0.11+9-0ubuntu2~20.04
sudo apt install openjdk-16-jre-headless  # version 16.0.1+9-1~20.04
sudo apt install openjdk-8-jre-headless   # version 8u292-b10-0ubuntu1~20.04
sudo apt install openjdk-13-jre-headless  # version 13.0.7+5-0ubuntu1~20.04
sudo apt install openjdk-17-jre-headless  # version 17+35-1~20.04
```


Search all OpenJDK version
```sh
parallels@ubuntu-linux-20-04-desktop:~$ sudo apt-cache search openjdk | grep openjdk
```

Install OpenJDK 17
```
parallels@ubuntu-linux-20-04-desktop:~$ sudo apt install openjdk-17-jdk


```
After install...
```
parallels@ubuntu-linux-20-04-desktop:~$ java -version
openjdk version "17" 2021-09-14
OpenJDK Runtime Environment (build 17+35-Ubuntu-120.04)
OpenJDK 64-Bit Server VM (build 17+35-Ubuntu-120.04, mixed mode, sharing)
```