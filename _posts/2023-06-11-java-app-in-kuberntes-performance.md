---
layout: post
title: "Java Performance analysis in Kubernetes"
date: 2023-06-11 17:13:00 -0400
modified_date: 2023-06-11 17:13:00 -0400
categories: java performance
---

## Motivation

Once I felt like I missed all the fun in java performance tuning capabilities as the application runs in Kubernetes environment. More then that application architects trimmed down the container by only having the tools and libraries needed to run the application. We are lucky we had shell access. Security architects tightened by removing many commands as well. On top of that organizations had multiple docker layers managed my differnt team. While all these are for very good reasons, it is challenging to debug problem which only happens in prodcution environment. In this article, I am sharing few tips and tricks which is useful in such schenario.

## Commands

#### Show pods with the node on which it is running

```sh
kubectl get pods -owide
kubectl get pod --show-labels

```

#### Show services with the selector

```sh
kubectl get service -owide
NAME                  TYPE           CLUSTER-IP     EXTERNAL-IP                      PORT(S)              AGE    SELECTOR
your-app              ClusterIP      9.133.15.86    <none>                           8080/TCP             122d   label-key1=value1,label=key2=value2
```

#### Get pods with a selector (from service)

```sh
kubectl get pod --selector=label-key1=value1,label=key2=value2
NAME                      READY   STATUS    RESTARTS   AGE
yourapp-8bdbab67c-m5xfn   1/1     Running   0          29h
```

#### Show the CPU and Memory usage of each pod

```sh
kubectl top pod --sort-by=cpu
```

#### Connect to POD shell

```sh
kubectl exec -it $POD_NAME -- /bin/sh
```

If you dont have `ps` command in the POD.

```sh
awk '{ split(FILENAME,f,"/") ; printf "%s: %s\n", f[3],$0 }' /proc/[0-9]/cmdline
```

#### Isolating the pod

If we want to leave the pod disconnected from the service so we can inspect, we can simply change the label such a way that is not matching with `service` label selector. This can be done by removing label(by using minus sign).

```sh
kubectl label pod $POD_NAME label-name-to-be-removed-
kubectl label pod $POD_NAME app.kubernetes.io/name-
```

### Using Java tools to gather data

If our pod has full JDK, we are lucky to use the tools in `JDK_HOME/bin` folder. If not we have 2 options.

Access the process from the node on which the pod is running. (Needs higher privilage to install JDK tools on node).

#### Steps:

1. ssh into the node
2. Find the process which is equivalent to the JVM running inside pod.

```sh
ps -ef | grep java
ps -ef | grep java | grep 'any-specific-jvm-parameter'
export JAVA_PID=123456
ps -T -p $JAVA_PID
```

Note the process ID inside the container will be different from the process ID on the node. Eventhough the both same.

3. Install JDK if not found in node.

```sh
yum install java-11-openjdk-devel
```

4. Use JVM commands to interact with JVM process.

```sh
jcmd $JAVA_PID GC.heap_dump -all heapdump_`date '+%Y-%m-%d-%H-%M-%S'`.hprof
jcmd $JAVA_PID JFR.start duration=60s filename=jfr_`date '+%Y-%m-%d-%H-%M-%S'`.jfr
```

Use Eclipse MAT to analyze heap dump.

Alternatively you can use `jhat` command to serve a webserver to analyze heapdump.

```sh
jhat -port 7401 -J-Xmx4G your-heapdump.hprof
open http://localhost:7401
```

User Java Mission Control (comes with JDK or download from https://jdk.java.net/jmc/) to analyze JFR

```yaml
- name: JAVA_ADDITIONAL_OPTS
  value: -Dcom.sun.management.jmxremote.port=7080
    -Dcom.sun.management.jmxremote.ssl=false
    -Dcom.sun.management.jmxremote.authenticate=false
```

`JAVA_ADDITIONAL_OPTS` is not necessarily applied to your JVM. Assuming you know how to get those JVM parameter set in your java command

```
      ports:
        - containerPort: 8080
          name: web
          protocol: TCP
        - containerPort: 7080
```
