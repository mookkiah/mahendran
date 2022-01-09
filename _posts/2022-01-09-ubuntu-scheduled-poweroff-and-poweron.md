---
layout: post
title: "Ubuntu - Scheduled power on and off"
date: 2022-01-09 05:32:00 -0400
categories: ubuntu automation
---

# Motivation
I am working on a home automation project which uses a mini-pc to perform certain function on scheduled time. I don't want the PC to run all time to save electicity cost and be efficient in usage. So I started looking for option to power ON the PC just before doing the job and power OFF when completing the job.

## Environment
- Beelink GK Mini Mini PC which supports Auto Power On, Wake On LAN, PXE Boot, RTC Wake
- Ubuntu 20.04.3 LTS

## Automatic Power ON
The PC I have supports RTC wake on S5(powered off) state.
To configure, we have to enter into BIOS/boot setting by pressing F7 during PC startup.

Once entered in to blue screen go to Boot --> S5 RTC Wake Settings
Configure the time to wake up.

<img src="/assets/images/ubutu-wakeup.jpg">

## Automatic Power OFF
You may shedule your automation task as regular user using `crontab -e` command.
But schedule the shutdown as root user by configuring at `sudo crontab -e`.
Find the exact location of shutdown using `which shutdown` and use it as below.
```
43 5 * * * /usr/sbin/shutdown -h now
```


## Challenges and Learning
To power off, I tried to use `shutdown` and `poweroff` commands in crontab.
```
43 5 * * * shutdown -h now
```
It did not work as I hoped.

How I started troubleshooting?

I can confirm the cron ran as scheduled by greping syslog
```
$ grep CRON /var/log/syslog
Jan  9 05:43:01 automation-mini CRON[2482]: (root) CMD (/sbin/shutdown -h now)
Jan  9 05:43:41 automation-mini cron[597]: (CRON) INFO (pidfile fd = 3)
Jan  9 05:43:41 automation-mini cron[597]: (CRON) INFO (Running @reboot jobs)
```

Just writing the stdout and stderr logs to file.
```
43 5 * * * shutdown -h now > /home/automation/shutdown.log 2>&1
```

I saw logs like...
```
/bin/sh: 1: shutdown: not found
```
To  overcome this, I found the exact location of shutdown command `which shutdown` and used it.

```
43 5 * * * /usr/sbin/shutdown -h now > /home/automation/shutdown.log 2>&1
```
Which takes me to next challenge.

Also I created a sh file and place the shutdown as part of the job.
```automation.sh 
#!/bin/sh
echo "Automation begins" >> /home/automation/automation.log 2>&1
echo "Automation ends" >> /home/automation/automation.log 2>&1
/usr/sbin/shutdown -h now >> /home/automation/automation.log 2>&1
```

From the log file...
```
Failed to set wall message, ignoring: Interactive authentication required.
Failed to power off system via logind: Interactive authentication required.
Failed to open initctl fifo: Permission denied
Failed to talk to init daemon.
```

It did not work, because I used `crontab -e` to configure it. So the command end up asking for password interactively in the background. You know I will not know.




## Other options not tried or used or gained confidence to share
- rtcwake - Not sure it will wake up if PC power unplugged and plugged in.
- specifying username in crontab instead of using `sudo crontab -e` - https://serverfault.com/questions/352835/crontab-running-as-a-specific-user
    ```
    43 5 * * * root /usr/sbin/shutdown -h now > /home/automation/shutdown.log 2>&1
    ```
    Maybe this require giving more permission to the automation user (wheel/sudoers)

