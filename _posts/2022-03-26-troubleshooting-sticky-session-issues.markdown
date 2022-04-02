---
layout: post
title:  "Troubleshooting Sticky Session failures"
date:   2022-03-26 05:25:00 -0400
categories: networking
---

# Motivation
As there are so many application still out there as stateful due to various meaningful reasons.
Which expects a client (browser mostly) served by same web/app server instance when there are many instances available.

In layman term, when your business grows its like assiging a dedidcated representative to handle each of your business client. So your employee have the context in mind and able to serve your clients at the best without asking for already asked questions.

Here are are few reasons why we needed stateful application.
- Need to maintain client state in memory which is large in size.
- Application is scaled horizontally while application is not using any distributed caching.
- Applicaton deployed in differnt regions which adds latency issues or complexity to have replicating fast enough.

To provide better service, software providers will request network team to route the trafic from web clients to same backend instance and/or at same region. This is configurable in loadbalancer or other routing services with some technique to recognize the client and its backend instance. This concept is called `sticky session`. 
- CLIENT_IP - by mainitainig a map with key as client IP and value as backend app or routing path. 
    This offer loadbalaning based on geo location wher distributed caching available within region.
    This is expensive as the routing component needs memory lookup and it needs to be scaled up in regions. Kind of never ending problem when latency.
- COOKIE - mostly used browser based clients only which is capable of supporting http cookie. This is most preferrable solution as every intermediate routing component can add a cookie in the http request/response to remember how to route when the same client comes back.

As COOKIE based approach mostly used, we still have problem of routing to wrong backend for any reason.
In realtime, what if the customer is not giving his customer ID or rep name?. What if the representative is on leave? What if we got a level 1 support who does not understand the importance of finding the same representative.


## Some knownn cookies
Cookies are almost free. it can be managed by client, server or intermdeidate routing services.
So some tries to use standard cookie and some create their own cookie and attach it.

Here are some cookie names which I have seen
- JSESSIONID - used by java application when it is clustered and scaled at the application layer
    - this value normally random. Sometime it has hint about the backend cluster code.
    - ex: 1232321332, 2343D23432-region-eu-node-3
- BIGipCookie - used by F5 loadbalancer
- NSC_XXXX - NetScaller 
- X-Oracle-BMC-LBS-XXXX - Oracle cloud 
- custom name - used by AWS route 53.


## Cookie knowledge
It is so simple to use cookie while it is so easy to overlook the concept around how cookie is managed at client and server level.
As we know it can be added, changed and deleted by anyone client, server and intermediatory. It brings opportunity for hackers to give us trouble. So there are few restriction put in place to ensure cookies are protected by some rules.

While adding cookie, security advices us to set expectation on 
- How long this cookie lives (refer expires value for each cookie)? If this is very short time (in seconds, then ensure your client/browser time in sync with the component which adds the Cookie)
- Is it available for javascript?
- Is it only used in secure https transport?
- Is it at the domain level or applicatin level? - SameSite
- Who is responsible to transfer the cookie when redirection happens between application?
- How the cookie handled while different samesite and sameorigin policy in place?

While security policy being setup at differnt level client (browser), loadbalancer, server(application), it is bringing challenges which are hard to troubleshoot.

## Troubleshooting the routing
It is required to look at the request headers and response header to determine how the trafic is going to be routed based on the routing policy defined.
There are tools and technique used to trace the request. The easiest(hard until you know) way to enable logging to print http headers at the request and response.
See how to setup logging for printing http headers from [this post]({% link _posts/2021-10-09-how-to-print-http-headers.md  %})

At times enabling log in all instances, regions are harder. Also it is harder to convince others until we give full routing trace which needs greater level of knowledge and access.

When multiple components in the architecture performs routing, it is harder to proove where the problem is. Everyone says, my component works well.

To limit the number of stakeholders to participate in troubleshooting, its good idea to isolate the problem by replacing application with services which logs/echo the request or skipping one or more routing components from the path. Beware of IP whitelisting while trying to jump :-) and accept all these security settings are for a reason (not for making it complex for you).

### Using http echo 
Lets see how to make use of [mendhak/http-https-echo](https://hub.docker.com/r/mendhak/http-https-echo) docker image which provides a endpoint which just echos useful information as it finds from the request

It is easy to setup for your infrastructure. Thanks to docker image concepts. No more `the code works on my machine dialog`

Here is the yaml configuration to quickly bring up this application in Kubernetes where nginx used for routing

```
---
# kubectl create deployment http-https-echo --image=mendhak/http-https-echo --dry-run -oyaml 

apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: http-https-echo
  name: http-https-echo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: http-https-echo
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: http-https-echo
    spec:
      containers:
      - image: mendhak/http-https-echo
        name: http-https-echo
        ports:
          - name: echo-http
            containerPort: 80

---

# kubectl expose deployment/http-https-echo --port=8080 --target-port=80 --dry-run -oyaml 

apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: http-https-echo
  name: http-https-echo
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 80
  selector:
    app: http-https-echo

---
# If you have NGINX as ingress controller
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: http-https-echo-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  # use your FQDN hostname instead of example.com
  - host: example.com
    http:
      paths:
      # use your application context to replace the application instance if you have challenge introducing new context. Caution: if you demo this to security team, they may ask you to whiltelist the base context.
      - path: /http-echo
        backend:
          serviceName: http-https-echo
          servicePort: 8080

---
# If you have traefik as ingress controller
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: http-https-echo-ingress-traefik
  annotations:
    kubernetes.io/ingress.class: traefik
spec:
  rules:
  - host: example-traefik.com
    http:
      paths:
      - path: /http-echo
        backend:
          serviceName: http-https-echo
          servicePort: 8080
```
    
    
Note: 
    Read the docker image documentation and/or check the port the container really running by getting into container and executing `netstat -an` and adjust the configuration accordingly. Sorry still we have `the configuration works in my infrastructure` dialog. 

With this setting, if you can access the echo application from browser (which aware of cookie), curl(which is does not aware of cookie) command.

Yow will be able to see all the http headers  (cookies is one of header )

### Skipping components
By using the echo container, we are skipping or eliminating the last component in the flow. If we need to skip other components, we can do this by
- by constructing requests with fake/manually constructed headers.
- by creating tunnel with software routers to jump a layer.
