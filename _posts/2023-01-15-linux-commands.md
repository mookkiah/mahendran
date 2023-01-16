---
layout: post
title: "Linux Commands"
date: 2023-01-15 21:07:00 -0400
modified_date: 2023-01-15 21:07:00 -0400
categories: linux commands
---

## Motivation
This page has linux commands which I found useful and worth practicing frequently to help myself.

### Network related commands

```
mahendran@ubuntu-22.04:~$ iwgetid
wlp2s0    ESSID:"MYWIRELESS"
```

### Firewall commands
```
root@ubuntu-22.04:~# ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
root@ubuntu-22.04:~# ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere                  
3389/tcp                   ALLOW       Anywhere                  
22/tcp (v6)                ALLOW       Anywhere (v6)             
3389/tcp (v6)              ALLOW       Anywhere (v6)             

```

### Knowing Linux Distribution

```sh
root@ubuntu-22.04:~$ uname -a
Linux automation-mini-2 5.15.0-58-generic #64-Ubuntu SMP Thu Jan 5 11:43:13 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
root@ubuntu-22.04:~$ cat /etc/os-release 
PRETTY_NAME="Ubuntu 22.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.1 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
root@ubuntu-22.04:~$ 
```

```
root@ubuntu-22.04:~# lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 22.04.1 LTS
Release:	22.04
Codename:	jammy
```