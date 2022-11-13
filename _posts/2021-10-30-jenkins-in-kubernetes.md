---
layout: post
title:  "Jenkins in Kubernetes"
date:   2021-10-30 5:02:00  -0400
modified_date: 2022-11-13 05:15:00  -0400
categories: devops jenkins
---

# Motivation
I needed a Jenkins instance for my experiement

## Pre-requsite
- Kubernetes cluster
- Helm

## Steps
```shell
$ helm repo list                                    
NAME    URL                          
stable  https://charts.helm.sh/stable
mahendran@mm-lab jenkins-ssp-idp % helm repo add jenkins https://charts.jenkins.io
"jenkins" has been added to your repositories
mahendran@mm-lab jenkins-ssp-idp % helm search repo jenkins
NAME            CHART VERSION   APP VERSION     DESCRIPTION                                       
jenkins/jenkins 4.0.0           2.332.3         Jenkins - Build great things at any scale! The ...
stable/jenkins  2.5.4           lts             DEPRECATED - Open source continuous integration...

```

Even though you find many charts, we are going to use `jenkins/jenkins`.
Its a good practice to use a fixed version and carefully review `values.yaml` change when upgrading

You would need customization sooner than later, it is good idea to maintain values.yaml in your SCM.
```
helm show values jenkins/jenkins > values.yaml 
```

I will be using  `--set` option to highlight the changes and easy to follow.
```
export JENKINS_PASSWORD=YourFavoritePassword
export RELEASE_NAME=jenkins

helm upgrade -i $RELEASE_NAME jenkins/jenkins --set jenkinsPassword=$JENKINS_PASSWORD --debug
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