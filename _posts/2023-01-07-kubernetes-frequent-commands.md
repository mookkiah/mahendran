---
layout: post
title:  "Kubernetes frequent comamands"
date: 2023-01-07 08:03:00  -0400
date: 2023-01-07 08:03:00  -0400
modified_date: 
categories: kubernetes
---

# Motivation
I use alias or `reverse-i-search` very frequently to be productive. The downside of it, those commands fade from my memory soon. When I switch new terminal or helping others, I can only think of what operation to perform but not (how ) knowing the exact command.
Here I note few frequent commands, alias and function which I use day to day.

To see all container and their image version.
```
kubectl get pod -o 'custom-columns=CONTAINER:.spec.containers[0].name,IMAGE:.spec.containers[0].image'
```

### To switch namespace
```
kn () 
{ 
    kubectl config set-context --current --namespace=$1;
    ki
}
kn <namespace name>
```


### To switch context
```
kc () 
{ 
    kubectl config use-context $1;
    ki
}
kc <context name>
```
Or simply change the KUBECONFIG using `reverse-i-search`
```
export KUBECONFIG=~/.kube/<name of the config which you remember and do reverse-i-search>
```

## Aliases
```
alias k=kubectl
alias kge='kubectl get events -o custom-columns=FirstSeen:.firstTimestamp,LastSeen:.lastTimestamp,Count:.count,From:.source.component,Type:.type,Reason:.reason,Message:.message'
alias kg='k get --sort-by=.metadata.creationTimestamp'
alias kl='k logs --since=5m -f'

```

## Other useful Kubernetes tips

- Setup bash completion
