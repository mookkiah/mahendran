---
layout: post
title: "Networking Commands"
date: 2023-11-29 03:30:00 -0500
modified_date: 2024-05-28 03:27:00 -0500
categories: network
---

# Networking commands

## DNS resolv.conf

DNS nameservers and the possible (search) domains are listed in /etc/resolv.conf

```
$ cat /etc/resolv.conf
```

If we dont have any nameserver in the `/etc/resolv.conf`, system will not be able to resolve any host which thinks network is down.

```
$ dig cluster0.d8v1man.mongodb.net
/AppleInternal/Library/BuildRoots/aaefcfd1-5c95-11ed-8734-2e32217d8374/Library/Caches/com.apple.xbs/Sources/bind9/bind9/lib/isc/unix/socket.c:2132: internal_send: ::1#53: Network is down

; <<>> DiG 9.10.6 <<>> cluster0.d8v1man.mongodb.net
;; global options: +cmd
;; connection timed out; no servers could be reached
```

### DNS cache

DNS lookups cached for perfomance reasons. If you are debugging network, it is good idea to flush the DNS as needed.

Here is the command for MAC to flush the DNS.

```
$ sudo killall -HUP mDNSResponder;sudo dscacheutil -flushcache
```

## nslookup

```
$ nslookup cluster0.random.mongodb.net
Server:		12.32.0.1
Address:	12.32.0.1#53

Non-authoritative answer:
*** Can't find cluster0.random.mongodb.net: No answer
```

To debug add `-debug`

```
$ nslookup -debug google.com
Server:         100.64.0.1
Address:        100.64.0.1#53

------------
    QUESTIONS:
        google.com, type = A, class = IN
    ANSWERS:
    ->  google.com
        internet address = 142.250.217.238
        ttl = 54
    AUTHORITY RECORDS:
    ADDITIONAL RECORDS:
------------
Non-authoritative answer:
Name:   google.com
Address: 142.250.217.238
```

### dig

`dig` command helps to identify how a host name resolve into IP address which DNS server help to translate it.

```
$ dig cluster0.random.mongodb.net

; <<>> DiG 9.10.6 <<>> cluster0.random.mongodb.net
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 14115
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;cluster0.random.mongodb.net.	IN	A

;; AUTHORITY SECTION:
mongodb.net.		60	IN	SOA	ns-761.awsdns-31.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 60

;; Query time: 57 msec
;; SERVER: 12.32.0.1#53(12.32.0.1)
;; WHEN: Tue Nov 28 14:07:32 EST 2023
;; MSG SIZE  rcvd: 136

```

Here is an example of we dont get any authritative answers (Just differnt time and differnt network)

```
$ dig cluster0.random.mongodb.net

; <<>> DiG 9.10.6 <<>> cluster0.random.mongodb.net
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 8323
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;cluster0.random.mongodb.net.	IN	A

;; Query time: 25 msec
;; SERVER: 12.32.0.1#53(12.32.0.1)
;; WHEN: Wed Nov 29 02:57:23 EST 2023
;; MSG SIZE  rcvd: 55



```

Asking specific DNS server

If you want your host names resolved by checking specific DNS server

```
dig @50.63.202.40 somehost.company.com

```

## netstat

`netstat` helps to list all the network connections.

```
$ netstat -an
Active Internet connections (including servers)
Proto Recv-Q Send-Q  Local Address          Foreign Address        (state)
....
```

### ping

`ping` command is more frequently used but mostly blocked to keep the bad actors away.

```
$ ping google.com
```

## traceroute

```
$ traceroute google.com
```

## References

- https://www.godaddy.com/help/what-is-dns-665

### Debugging tools

In linux (Ubuntu), to get some basic commands (ex: dig, nslookup), install them using following commands.

```
$ sudo apt install net-tools
```

or in AWS cloudshell...

```
$ sudo yum install -y bind-utils
```
