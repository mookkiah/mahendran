---
layout: post
title:  "Jenkins in Kubernetes"
date:   2021-10-30 5:02:00  -0400
categories: devops jenkins
---

# Motivation
I needed a Jenkins instance for my experiement

## Pre-requsite
- Kubernetes cluster
- Helm

## Steps
```shell
$ helm search repo jenkins
NAME                                            CHART VERSION           APP VERSION     DESCRIPTION                                       
stable/bitnami/jenkins                          8.0.1                   2.289.1         The leading open source automation server         
stable/choerodon/jenkins                        0.1.0                   2.60.3-alpine   A Helm chart for Kubernetes                       
stable/cloudbees/cloudbees-jenkins-distribution 2.263.102               2.263.1.2       CloudBees Jenkins Distribution provides develop...
stable/cloudposse/jenkins                       0.1.2                                   A Jenkins Helm chart for Kubernetes               
stable/codecentric/jenkins                      1.7.1                   2.222.3         CHART DEPRECATED - The leading open source auto...
stable/incubator/jenkins-operator               0.3.1                   0.3.0           DEPRECATED: A Helm chart for Kubernetes Jenkins...
stable/jenkins                                  8.0.11                  2.303.1         The leading open source automation server         
stable/jenkins/jenkins-operator                 0.5.1                   0.6.0           Kubernetes native operator which fully manages ...
stable/jenkinsci/jenkins                        3.3.22                  2.289.1         Jenkins - Build great things at any scale! The ...
stable/odavid/my-bloody-jenkins                 0.1.161                 2.289.1-254     A Helm chart for my-bloody-jenkins - a self con...
stable/stable/jenkins                           2.5.4                   lts             DEPRECATED - Open source continuous integration...
stable/stakater/jenkins                         0.21.0                  2.121.3         Open source continuous integration server. It s...
stable/cloudbees/cloudbees-core                 3.32.1+7d1cefcdc2b8     2.289.1.2       Enterprise Continuous Integration with Jenkins    

```

Even though you find many charts, we are going to use `stable/jenkins` with version 8.0.11.
Its a good practice to use a fixed version and carefully review `values.yaml` change when upgrading

You would need customization sooner than later, it is good idea to maintain values.yaml in your SCM.
```
helm show values stable/jenkins > values.yaml 
```

I will be using  `--set` option to highlight the changes and easy to follow.
```
export JENKINS_PASSWORD=YourFavoritePassword
export RELEASE_NAME=jenkins

helm upgrade -i $RELEASE_NAME stable/jenkins --version=8.0.11 --set jenkinsPassword=$JENKINS_PASSWORD --debug
```

We will see instruction to access the jenkins as below
```
NOTES:
** Please be patient while the chart is being deployed **

1. Get the Jenkins URL and associate its hostname to your cluster external IP:

   export CLUSTER_IP=$(minikube ip) # On Minikube. Use: `kubectl cluster-info` on others K8s clusters
   echo "Jenkins URL: http://jenkins.example.com"
   echo "$CLUSTER_IP  jenkins.example.com" | sudo tee -a /etc/hosts

2. Login with the following credentials

  echo Username: user
  echo Password: $(kubectl get secret --namespace jenkins-dev jenkins -o jsonpath="{.data.jenkins-password}" | base64 --decode)
```



## Customization
Most probably you would require to set these helm values

- jenkinsHost - DNS hostname with your domain
- persistence.storageClass - To retain Jenkins configuration,plugins,job across restarts

## Initial Configuration
- Under Manage Jenkins --> Configure System --> 
  - Jenkins URL. Make sure protocol is correct.
  - System Admin e-mail address
  - EMail Notification