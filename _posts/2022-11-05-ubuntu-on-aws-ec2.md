---
layout: post
title: "Ubuntu on AWS EC2"
date: 2022-11-04 21:58:00 -0400
categories: aws unix remote
---

# Motivation
Setting up an EC2 instance with Ubuntu image and access via SSH, CloudShell and RDP.

# Prerequisites
- AWS account - Free Tier is enough
- 

# Steps
## Create instance using AWS console
- Go to https://console.aws.amazon.com/console/home
- Type `EC2` in search and select to get to EC2 dashboard.
- Navigate via menu Instances --> Instances
- Click `Launch Instances`
- Fill the form (These are example)
    - Name: MyRemoteUbuntu
    - Application or OS Images
    - Select Ubuntu - Ensure it is `Free tier eligible` - At the time of writing this - ami-0574da719dca65348
    - Instance type: t2.micro
    - Key pair - Generate or select if you have one - This will used for SSH.
    - Network settings
        - Create security group by allowing SSH traffic from your IP (shows in drop down as `My IP` )range
        - `curl ifconfig.me` to find your IP and use `yourip/32` ex `74.192.37.123/32`
        - Later we can add port 3389 to allow RDP in this security group.
    - Review the summary on the right pane and clieck `Launch instance` button.
    - Click `Next Steps` --> `Connect to instance`
    - Follow `SSH client` method to connect to instance.
    - No need of password as your SSH keys already configured into the instance.

```
ubuntu@ip-172-31-34-250:~$ uname
Linux
ubuntu@ip-172-31-34-250:~$ uname -a
Linux ip-172-31-34-250 5.15.0-1026-aws #30-Ubuntu SMP Wed Nov 23 14:15:21 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
ubuntu@ip-172-31-34-250:~$ cat /etc/os-release 
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
ubuntu@ip-172-31-34-250:~$ 
```

## Take time to see all the summary for the instance
Key information to watch
- Instance state
- Public IP
- Public IPV4 DNS
- Elastic IP address
- Networking --> Availability zone
- Private IPV4 addresses
- Monitoring

## Accessing via RDP
- First edit the security group to allow RDP - `Security` Tab --> `Security groups` --> Click link --> Edit `Inbound rules` --> `Add rule` --> Choose `RDP` type --> Give custom source IP range like SSH --> `Save rules`
- Try accessing via Remote Desktop (RDP) client using public IP/DNS
- We can't as RDP port is not listening in the instance. Most likely the instance doesnt have GUI.

Following command shows port 3386 is not listening inside ubuntu machine we created.
```
ubuntu@ip-172-31-34-250:~$ nc -z -v localhost 3389
nc: connect to localhost (127.0.0.1) port 3389 (tcp) failed: Connection refused
```

Followig commands proves there is no GUI installed in this machine
```
ubuntu@ip-172-31-34-250:~$ ls /usr/bin/*session
/usr/bin/byobu-select-session  /usr/bin/dbus-run-session
ubuntu@ip-172-31-34-250:~$ type Xorg
-bash: type: Xorg: not found
```
### How to get GUI:
- Installing
- Finding another image with GUI

#### Finding an AMI with GUI.
- As there is no free Ubuntu desktop image (At least I counldnt find one). Choosing Amazon Linux
- Amazon Linux - NET Core 6, Mono 6.12, PowerShell 7, and MATE DE pre-installed to run your .NET applications on Amazon Linux 2 with Long Term Support (LTS).
- There is no free trial image. But many found in `AWS Marketplace`. We may pick low cost 

Amazon Linux via SSH
```
[ec2-user@ip-172-31-49-247 ~]$ cat /etc/os-release 
NAME="Amazon Linux"
VERSION="2"
ID="amzn"
ID_LIKE="centos rhel fedora"
VERSION_ID="2"
PRETTY_NAME="Amazon Linux 2"
ANSI_COLOR="0;33"
CPE_NAME="cpe:2.3:o:amazon:amazon_linux:2"
HOME_URL="https://amazonlinux.com/"
[ec2-user@ip-172-31-49-247 ~]$ 
```

Following command shows RDP port reachable from our home.
```
mahendran@mm-lab ~ % nc -z -v  ec2-44-202-22-106.compute-1.amazonaws.com 3389
Connection to ec2-44-202-22-106.compute-1.amazonaws.com port 3389 [tcp/ms-wbt-server] succeeded!
```

Following command shows `mate` desktop available and RDP port is LISTENING
```
[ec2-user@ip-172-31-49-247 ~]$ ls /usr/bin/*session
/usr/bin/dbus-run-session  /usr/bin/mate-session
[ec2-user@ip-172-31-49-247 ~]$ netstat -an | grep 3389
tcp6       0      0 :::3389                 :::*                    LISTEN 
```

#### Installing GUI

Following command sequence will install desktop and enable RDP.
```shell
ubuntu@ip-172-31-34-250:~$ sudo apt update && sudo apt upgrade
ubuntu@ip-172-31-34-250:~$ sudo apt install ubuntu-desktop
ubuntu@ip-172-31-34-250:~$ ls /usr/bin/*session
/usr/bin/byobu-select-session  /usr/bin/dbus-run-session  /usr/bin/gnome-session  /usr/bin/gnome-session-custom-session  /usr/bin/pipewire-media-session
ubuntu@ip-172-31-34-250:~$ nc -z -v localhost 3389
nc: connect to localhost (127.0.0.1) port 3389 (tcp) failed: Connection refused
ubuntu@ip-172-31-34-250:~$ sudo apt install xrdp
ubuntu@ip-172-31-34-250:~$ sudo systemctl enable xrdp
ubuntu@ip-172-31-34-250:~$ nc -z -v localhost 3389
Connection to localhost (127.0.0.1) 3389 port [tcp/ms-wbt-server] succeeded!
```


## Remember to stop the instance
Eventhough the image in free tier, you dont want to waste your free tier eligible hours. Remember to stop and possibly delete the instance



## References:
- See how to setup all of these using CloudFormation stack
- How to stop and start EC2 instance using lambda exposed via url
- To check GUI installed in linux - https://ostechnix.com/how-to-check-if-gui-is-installed-in-linux-from-commandline/
