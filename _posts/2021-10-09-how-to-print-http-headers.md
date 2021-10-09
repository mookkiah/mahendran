---
layout: post
title:  "Logging HTTP headers at web server"
date:   2021-10-09 06:40:00  -0400
categories: devops webserver
---

# Use cases
When working with web application which has functionalities based on http header, we may required to log the headers to investigate issues.

For example
 - We want to know what is the real IP of the client
 - We want to know the request came as http or https
 - What is the IP of previous network component (ex: LoadBalancer or proxy) which routes the request.
 - What is the client agent (browser type or application)
 - What is the content type and length
 - What is the response code returned by the web server
 - What are the cookies present in the request


 Ofcourse we can ask the application developer to print all the details in the application log.

 What if the application is not developed internally?

 In this blog let us see how to log these information with minimal effort and without touching application code/artifact/configuration.

 ## Tomcat
Tomcat and few application servers (JBoss, TomEE) which is based on tomcat has `server.xml` which configures the web server engine and many Valves/Filters which request can flow through before hitting the application.

These are easy to configure and has separate log file called `access.log` to investigate the incoming request

To print http headers define [Access Log Valve](https://tomcat.apache.org/tomcat-10.0-doc/config/valve.html#Access_Log_Valve)
```
<Valve className="org.apache.catalina.valves.AccessLogValve"
directory="logs" prefix="localhost_access_log" suffix=".txt"
pattern="%{host}i %{HOST}i %{X-Forwarded-Proto}i %{X-Forwarded-Host}i %{Content-Type}i %{Accept}i %{Accept-Encoding}i  %h %l %u %t &quot;%r&quot; %s %b "
resolveHosts="false"/>
```

We can also use the [Request Dumper Filter](https://tomcat.apache.org/tomcat-10.0-doc/config/filter.html#Request_Dumper_Filter) when we dont know what to log and/or a specific url-pattern


```
<filter>
    <filter-name>requestdumper</filter-name>
    <filter-class>
        org.apache.catalina.filters.RequestDumperFilter
    </filter-class>
</filter>
<filter-mapping>
    <filter-name>requestdumper</filter-name>
    <url-pattern>*</url-pattern>
</filter-mapping>
```
<!-- 

### Sample output

```

```
To print cookies
```

```

### Sample output

```

```
-->
## Nginx
Nginx is the most popular web server which used for serving static contents and act as reverse proxy to handle complex routing, url re-writing functionalities.

Nginx configuration starts with `nginx.conf` which configures web server, ports to listen, ssl certificates to use, url to serve/route etc.

We can add logformat by instructing to print http headers as below
```
log_format upstreaminfo '$remote_addr - $request_id - $http_x_forwarded_for - [$proxy_add_x_forwarded_for] -
    $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer"
    "$http_user_agent" $request_length $request_time [$proxy_upstream_name] $upstream_addr
    $upstream_response_length $upstream_response_time $upstream_status';
access_log /var/log/nginx/access.log upstreaminfo if=$loggable;
```


## Nginx Controller
Nginx controller configures Nginx server dynamically based on the cloud native services.

To configure logformat in nginx controller...
```
  log-format-upstream: $remote_addr - $request_id - $http_x_forwarded_for - [$proxy_add_x_forwarded_for] -
    $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer"
    "$http_user_agent" $request_length $request_time [$proxy_upstream_name] $upstream_addr
    $upstream_response_length $upstream_response_time $upstream_status
```

### Sample output

Without  log-format-upstream (default)
```
174.20.2.111 - - [06/Oct/2021:06:53:25 +0000] "GET / HTTP/1.1" 302 138 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36" 1033 0.000 [-] [] - - - - 142ef4b9cbb91ce9045f5b658feaeb71
```

With  log-format-upstream
```
174.20.2.111 - 4f64a008d5e06a120b1673a9018a2557 - 73.192.109.108 - [73.192.109.108, 174.20.2.111] - - [06/Oct/2021:06:56:06 +0000] "GET / HTTP/1.1" 302 138 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Safari/537.36" 1092 0.000 [-] - - - -
174.20.2.118 - 2cf9dc47a0bbbcf9c14dd18fd0261248 - - - [174.20.2.118] - - [06/Oct/2021:06:50:39 +0000] "GET / HTTP/1.1" 302 138 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36" 1033 0.000 [-] - - - -
```

<!---
## Trafik
Trafik is software load balancer and reverse proxy used in cloud native infrastructure (ex: Kubernetes)


To configure Trafik to print logs with http header...
```

```

### Sample output

```

```


## Jetty

TBD
-->