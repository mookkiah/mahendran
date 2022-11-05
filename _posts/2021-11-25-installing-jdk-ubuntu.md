---
layout: post
title:  "Installing JDK on Ubuntu"
date:   2021-11-25 12:55:00 -0400
modified_date:   2022-11-04 021:36:00  -0400
categories: ubuntu java
---

## Environments 
- Ubuntu 20-04 running in Mac M1 using parallel
- AWS EC2 image ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220912


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

if you get "Unable to locate package" error like this try `sudo apt update` ...
```
$ sudo apt install openjdk-17-jdk
[sudo] password for subanitha: 
Reading package lists... Done
Building dependency tree       
Reading state information... Done
E: Unable to locate package openjdk-17-jdk
$ sudo apt update
Hit:1 http://us.archive.ubuntu.com/ubuntu xenial InRelease
Get:2 http://dl.google.com/linux/chrome/deb stable InRelease [1,811 B]                                              
Get:3 http://us.archive.ubuntu.com/ubuntu xenial-updates InRelease [109 kB]                                                                   
Get:4 http://security.ubuntu.com/ubuntu xenial-security InRelease [109 kB]                                                                    
Hit:5 http://download.virtualbox.org/virtualbox/debian xenial InRelease                                                   
Hit:6 https://download.docker.com/linux/ubuntu xenial InRelease                                                    
Get:7 http://us.archive.ubuntu.com/ubuntu xenial-backports InRelease [107 kB]                  
Err:2 http://dl.google.com/linux/chrome/deb stable InRelease                                  
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 78BD65473CB3BD13
Get:8 http://us.archive.ubuntu.com/ubuntu xenial-updates/main amd64 DEP-11 Metadata [327 kB]
Get:9 http://us.archive.ubuntu.com/ubuntu xenial-updates/universe amd64 DEP-11 Metadata [281 kB]
Get:10 http://us.archive.ubuntu.com/ubuntu xenial-updates/multiverse amd64 DEP-11 Metadata [5,956 B]
Get:11 http://us.archive.ubuntu.com/ubuntu xenial-backports/main amd64 DEP-11 Metadata [3,328 B]      
Get:12 http://us.archive.ubuntu.com/ubuntu xenial-backports/universe amd64 DEP-11 Metadata [6,608 B]
Get:13 http://security.ubuntu.com/ubuntu xenial-security/main amd64 DEP-11 Metadata [93.7 kB]      
Get:14 http://security.ubuntu.com/ubuntu xenial-security/universe amd64 DEP-11 Metadata [130 kB]
Get:15 http://security.ubuntu.com/ubuntu xenial-security/multiverse amd64 DEP-11 Metadata [2,464 B]
Reading package lists... Done                                                
W: GPG error: http://dl.google.com/linux/chrome/deb stable InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 78BD65473CB3BD13
E: The repository 'http://dl.google.com/linux/chrome/deb stable InRelease' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
$ uname -a
Linux subanitha 4.15.0-142-generic #146~16.04.1-Ubuntu SMP Tue Apr 13 09:27:15 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

```

Tried upgrading operating system... Failed & did not help
```
$ sudo apt upgrade # upgrading operating system - take backup if needed... - 
;;;;
W: Possible missing firmware /lib/firmware/i915/kbl_guc_ver9_14.bin for module i915
W: Possible missing firmware /lib/firmware/i915/bxt_guc_ver8_7.bin for module i915
Processing triggers for resolvconf (1.78ubuntu7) ...
Processing triggers for dbus (1.10.6-1ubuntu3.6) ...
;;;;

$ uname -a
Linux subanitha 4.15.0-142-generic #146~16.04.1-Ubuntu SMP Tue Apr 13 09:27:15 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux  

```


After install...

```
parallels@ubuntu-linux-20-04-desktop:~$ java -version
openjdk version "17" 2021-09-14
OpenJDK Runtime Environment (build 17+35-Ubuntu-120.04)
OpenJDK 64-Bit Server VM (build 17+35-Ubuntu-120.04, mixed mode, sharing)
```

In Ubuntu at AWS image ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220912
```
ubuntu@ip-172-31-36-234:~$ javac -version
javac 17.0.4
ubuntu@ip-172-31-36-234:~$ java -version
openjdk version "17.0.4" 2022-07-19
OpenJDK Runtime Environment (build 17.0.4+8-Ubuntu-122.04)
OpenJDK 64-Bit Server VM (build 17.0.4+8-Ubuntu-122.04, mixed mode, sharing)
ubuntu@ip-172-31-36-234:~$
```
