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

### Pod queries

To see all container and their image version.

```
kubectl get pod -o 'custom-columns=CONTAINER:.spec.containers[0].name,IMAGE:.spec.containers[0].image'
```

To see pod's cpu and memory usage

```
kubectl top pod
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

### Labels & Annotations

#### Show label resources

```
kubectl get pod --show-labels
```

#### Filter resource with specific label

```
kubectl get pod -l app=my-app
```

```
kubectl logs -l app=my-app -f
```

Get namespaces with given label and value

```
kubectl get namespaces -l app.kubernetes.io/instance=test
```

Get the namespaces which are having specific (`app.kubernetes.io/instance`) annotation and show the value.

```
kubectl get namespaces -o jsonpath='{range .items[?(@.metadata.annotations.app\.kubernetes\.io/instance)]}{.metadata.name}{"\t"}{.metadata.annotations.app\.kubernetes\.io/instance}{"\n"}{end}' | column -t -s,
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
