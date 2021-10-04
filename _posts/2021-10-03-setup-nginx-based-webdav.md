---
layout: post
title:  "Setup NGINX based webdav"
date:   2021-10-03 16:23:00  -0400
categories: devops kubernetes
---

# Motivation
When you are having a on-premise infrastructure, there are times you need shared file server which can be interacted by system as well as human. Kubernetes based application contaniner should be able store or retrieve files occasionally or very rare/emergency situations.

## Example use cases
- Java container can generates heap dump on out of memory errors. This dump file needs to be saved outside of ephimeral storage.
- Application container might create files when crashed, these files needs to be shipped outside before pod restarts.
- Application may generate files which needs to be shared to human via http interface without having specific server for this applicaiton.

## Option 1: Windows file server
It is easy to find organization provided by shared file server which employees can mount to their computer to share with their team members

### Pros:
- Already exising
- Easy to secure by AD
### Cons:
- Not easy for system access
- Need to mount
- special (CIFS) protocol
- may need firewall policy to allow traffic

## Option 2: Persistent Volume Claim (PVC)
This is Kubernetes recommended way to persiste files which you dont want to loose on container restart.
### Pros:
- Easy to setup
- Can share the storage with multiple application (pods)
### Cons:
- Not easy to get human access unless having another server to publish the content of PVC
- Can't share the storage outside namespace unless underlying PersistentVolume shared outside of Kubernetes context.

## Option 3: Using cloud based file system
We can have AWS storage bucket or Google cloud storage which are available as part of [Kubernetes PVC option](https://kubernetes.io/fr/docs/concepts/storage/persistent-volumes/#types-de-volumes-persistants) 

### Pros:
- Easy to setup as PVC
- Secure
- Can be shared across multiple namespaces
- Easy to access by human by cloud web interfaces
### Cons:
- Not free
- Mixing on-prem and cloud solutions

## Option 4: Setup a webdav using NGINX
Webdav is a http based solution which allows clients to store and retrieve files. Webdav supported by many webservers (ex: Apache HTTPD, NGINX). 
### Pros:
- http based
- can be secure by transport(https) and authentication(basic)
- both accessible by system and human
### Cons:
- Maybe slow
## Option 5: FTP or SCP
These are alternative to windows file share and webdav
### Pros:
- Easy to get from infrastructure team
- Secure
### Cons:
- May need firewall setup
- Needs client installed in container.


## Configuring and running NGINX based WebDav in Kubernetes
There are instruction available how to configure NGINX to serve WebDav. That means we can [install few tools](https://github.com/ionelmc/docker-webdav/blob/2272f12310c23d4215264a4519cfb5977356e37d/Dockerfile#L6) and add [nginx.conf](https://github.com/ionelmc/docker-webdav/blob/2272f12310c23d4215264a4519cfb5977356e37d/nginx.conf#L39) as config map to bring up a webdav server. To make the setup simple, we can use a docker image which takes care of all and allow us to simply configure environment variables.

Deploy this Kubernetes resource 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-webdav
  name: nginx-webdav
spec:
  selector:
    matchLabels:
      app: nginx-webdav
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx-webdav
    spec:
      containers:
      # Forcing specific version of image as it is from public and untrusted. 
      - image: mookkiah/docker-webdav@sha256:09ed43d30aa2e31590998c76a734efc7470a1086b874acbe4bb7a4839b9fb65e
        name: webdav
        env:
        - name: WEBDAV_USERNAME
          value: "webdav"
        - name: WEBDAV_PASSWORD
          value: "S0m37h1n6C0mp13x" #SomethingComplex
        - name: UID
          value: "0" #String formatted UID of the file system directory /media (expect internal server error due to permission issue if not set right value)

```

# To find the external IP for accessing webdav url - http://<EXTERNAL-IP>:8080/
```
kubectl get service webdav-service
```
# Incase of external ip not set of not reachable, use port-forward to continue the development and ask for kubernetes adminster help.
```
kubectl port-forward svc/webdav-service 8080:8080 
```
when port-forward used use localhost inplace of IP
```
kubectl get service webdav-service
```
To check access - view on browser
```
curl -u webdav:S0m37h1n6C0mp13x http://172.17.0.54:8080
```

To create a folder
```
curl -X MKCOL -u webdav:S0m37h1n6C0mp13x http://172.17.0.54:8080/home/
```
To upload a file
```
curl -u webdav:S0m37h1n6C0mp13x -T webdav.yaml http://172.17.0.54:8080/home/webdav.yaml
```
To delete a folder
```
curl -X DELETE -u webdav:S0m37h1n6C0mp13x http://172.17.0.54:8080/home/webdav.yaml
```
To delete a file 
```
curl -X DELETE -u webdav:S0m37h1n6C0mp13x http://172.17.0.54:8080/home
```

