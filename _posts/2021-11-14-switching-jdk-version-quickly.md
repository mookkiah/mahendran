---
layout: post
title:  "Switching Java version - Quickly"
date:   2021-11-14 07:39:00 -0400
categories: mac java
---

To switch between JDK version, you can define below function in your ~/.bashrc and/or ~/.zshrc file
```shell
jdk() {
        if [ -z $1 ]
        then
              /usr/libexec/java_home -V  
              echo "******************"
              echo "Command Usage: 'jdk <version>'"
        else
                unset JAVA_HOME
                version=$1
                export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
                java -version
        fi

 }
```
Once done switching version is just one line (easy to remember) command
```shell
mahendran@mm-lab mahendran % jdk
Matching Java Virtual Machines (4):
    17 (arm64) "Eclipse Temurin" - "Eclipse Temurin 17" /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
    15 (x86_64) "AdoptOpenJDK" - "AdoptOpenJDK 15" /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home
    11.0.12 (arm64) "Homebrew" - "OpenJDK 11.0.12" /opt/homebrew/Cellar/openjdk@11/11.0.12/libexec/openjdk.jdk/Contents/Home
    1.8.0_275 (x86_64) "AdoptOpenJDK" - "AdoptOpenJDK 8" /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
******************
Command Usage: 'jdk <version>'
mahendran@mm-lab mahendran % jdk 17
openjdk version "17" 2021-09-14
OpenJDK Runtime Environment Temurin-17+35 (build 17+35)
OpenJDK 64-Bit Server VM Temurin-17+35 (build 17+35, mixed mode)
mahendran@mm-lab mahendran % jdk 15
openjdk version "15" 2020-09-15
OpenJDK Runtime Environment AdoptOpenJDK (build 15+36)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 15+36, mixed mode, sharing)
mahendran@mm-lab mahendran % jdk 1.8
openjdk version "1.8.0_275"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_275-b01)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.275-b01, mixed mode)
mahendran@mm-lab mahendran % jdk 11
openjdk version "11.0.12" 2021-07-20
OpenJDK Runtime Environment Homebrew (build 11.0.12+0)
OpenJDK 64-Bit Server VM Homebrew (build 11.0.12+0, mixed mode)
mahendran@mm-lab mahendran % 
```