---
layout: post
title:  "Postgres installation and setup in Ubuntu and Mac"
date:   2022-03-20 09:38:00 -0400
categories: postgres
---

# Motivation
Postgres is my favorite opensource relational database which is used in large enterprises.
It evolved by offering more and more features for adminstration, replication and caching.
I wanted to keep experiment PGAdmin Web interface before recommending it. I had postgres server in my Mac. So I installed PGAdmin web in Ubuntu machine in the same network. This blog shows commands and tips worth sharing and remembering. 


```
mahendran@db-host:~$ sudo apt  install curl
Reading package lists... Done
Building dependency tree       
Reading state information... Done
...... SKIPPED
The following NEW packages will be installed:
  curl
0 upgraded, 1 newly installed, 0 to remove and 49 not upgraded.
Need to get 161 kB of archives.

mahendran@db-host:~$ curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3935  100  3935    0     0   6580      0 --:--:-- --:--:-- --:--:--  6591
OK
mahendran@db-host:~$ sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
...... SKIPPED
Fetched 4,402 kB in 3s (1,653 kB/s)                           
Reading package lists... Done
Building dependency tree       
Reading state information... Done
49 packages can be upgraded. Run 'apt list --upgradable' to see them.
mahendran@db-host:~$ 
```

Installing postgres in Ubuntu.
```shell
$ sudo apt update
$ sudo apt-get -y install postgresql
```



Connect
```
% psql -d postgres                          
psql (12.9)
Type "help" for help.
postgres=#
```
By default, postgres process will listen local connections only. To start listening on the IP, set `listen_addresses` at the `config_file`. You can set this to '*' to automatically picup the IP address from any interface.

To find where the config_file is...
```
% postgres=# show config_file;
                   config_file                   
-------------------------------------------------
 /opt/homebrew/var/postgresql@12/postgresql.conf
```


By default, postgres will accept connection from localhost/127.0.0.1. In realworld we needed to connect to database from remote machine. It is good practice to configure specific subnet to be allowed to connect. This setting goes to hpa_file.


```
# IPv4 local connections:
host    all     all     192.168.1.1/24      trust
host 	all		all		127.0.0.1/32		trust
```

  Tip: Use https://www.ipaddressguide.com/cidr to know the range you are allowing connections from.

On mac, to restart service (required when making configuration changes.)

To find where the hba_file is...
```
% postgres=# show hba_file;
                  hba_file                   
---------------------------------------------
 /opt/homebrew/var/postgresql@12/pg_hba.conf
```


```
% brew services list                  
Name          Status  User      File
postgresql@12 started mahendran ~/Library/LaunchAgents/homebrew.mxcl.postgresql@12.plist
```


```
% brew services restart postgresql@12               
Stopping `postgresql@12`... (might take a while)
==> Successfully stopped `postgresql@12` (label: homebrew.mxcl.postgresql@12)
==> Successfully started `postgresql@12` (label: homebrew.mxcl.postgresql@12)

```

Frequent issues and tips:
```
mahendran@mm-lab ~ % psql 
psql: error: FATAL:  database "mahendran" does not exist
mahendran@mm-lab ~ %
```
By default the client tries to connect to a database matching username/role.
It is good practice to supply database and username while connecting.
```
mahendran@mm-lab ~ % psql -d postgres -U mahendran
psql (12.9)
Type "help" for help.

postgres=#
```


## Installing PGAdmin Web
PGAdmin is the GUI interface to adminster the postgres server. It is available both in thick client and web application.
Both of them can be installed any machine and administer multiple postgres servers.

```shell
$ curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add -
$ sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/focal pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list' 
$ sudo apt update
$ sudo apt install pgadmin4 
```
After the instlal, we need to setup to configure the user
```shell
$ sudo /usr/pgadmin4/bin/setup-web.sh 
```
This configure the user and add the web application via apache http server which comes with Ubuntu by default.


Now you can access the application locally http://localhost/pgadmin4 or remotely with IP http://<hostname/IP>/pgadmin4


### Connect to remote database
```
./psql -h <host> -U <user> <database>
```

### To  list databases
```
psql --list
                              List of databases
   Name    |   Owner   | Encoding | Collate | Ctype |    Access privileges    
-----------+-----------+----------+---------+-------+-------------------------
 postgres  | mahendran | UTF8     | C       | C     | 
 template0 | mahendran | UTF8     | C       | C     | =c/mahendran           +
           |           |          |         |       | mahendran=CTc/mahendran
 template1 | mahendran | UTF8     | C       | C     | =c/mahendran           +
           |           |          |         |       | mahendran=CTc/mahendran
(3 rows)

```

```
/* --------- List all of the current sessions --------- */ 

SELECT * FROM pg_stat_activity;
select pid, query, state from pg_stat_activity;


/* --------- List current sessions from the "clients" database --------- */ 
SELECT * FROM pg_stat_activity WHERE datname='clients';

/* --------- Cancels the backend process where <procpid> is the process id returned from pg_stat_activity for the query you want to cancel --------- */ 
SELECT pg_cancel_backend( <procpid> );

/* --------- Cancels the backend process and terminates the user's session where <procpid> is the process id returned from pg_stat_activity 
for the query you want to cancel --------- */ 
SELECT pg_terminate_backend( <procpid> );
```


### List all databases from psql commandline
```
\list or \l
```

### Create database
```
create database <database_name>;
```

### Connect to a database
```
\c <database_name>
```

###  List all the schemas
```
\dn+
```

###  Drop schema
```
drop schema <schema_name> cascade;
```

###  Create Schema
```
create schema <schema_name> authorization <owner_user_name>;
```

### List tables all or filter
```
\dt+ *.*
\dt+ <schema_name>.*
```

### Describe table
```
\d+ <table_name>
```

To improve the productivity, Don't search for commands and copy paste before attempting to find using `\?`.



References:
- https://www.postgresql.org/download/linux/ubuntu/