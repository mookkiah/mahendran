---
layout: post
title: "AWS Load Balancer"
date: 2023-09-20 03:42:00 -0400
modified_date: 2023-10-23 07:42:00 -0400
categories: aws elb
---

# AWS ELB

## Notes

## Useful AWS commands

```sh
aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerName'
aws elbv2 describe-load-balancers --query 'LoadBalancers[].[LoadBalancerName,LoadBalancerArn]'


lb_arn=$(aws elbv2 describe-load-balancers --names "$1" --query 'LoadBalancers[].[LoadBalancerArn]' --output text)

listener_arn=$(aws elbv2 describe-listeners --load-balancer-arn "$lb_arn" --query 'Listeners[].{ListenerArn:ListenerArn,Protocol:Protocol,Port:Port}' | jq -r ".[] | select(.Port=="$2").ListenerArn")

aws elbv2 describe-rules --listener-arn "$listnerarn" --query 'Rules[].{Priority:Priority,Host:Conditions[0].Values[0]}' | jq

```

## Useful scripts

Python script which prints all the hostnames used in the load balancer rounting rule.

```python
import boto3
from pprint import pprint
import json
import logging
import sys


logger = logging.getLogger('print-aws')
logger.setLevel(logging.INFO)
sh = logging.StreamHandler(sys.stdout)
formatter = logging.Formatter('[%(asctime)s] %(levelname)s [%(filename)s.%(funcName)s:%(lineno)d] %(message)s', datefmt='%a, %d %b %Y %H:%M:%S')
sh.setFormatter(formatter)
logger.addHandler(sh)

elbv2 = boto3.client("elbv2")


def printEndPointUrls():
    response= elbv2.describe_load_balancers()
    loadbalancers = response["LoadBalancers"][2:]
    logger.debug(response)
    for lb in loadbalancers:
        lbArn=lb["LoadBalancerArn"]
        printLBListeners(lbArn)


def printLBListeners(lbArn):
    logger.debug(lbArn)
    response = elbv2.describe_listeners(LoadBalancerArn=lbArn)
    listeners = response["Listeners"]
    logger.debug(listeners)
    for listener in listeners:
        if listener["Protocol"] == "HTTPS" and listener["Port"] == 443:
            if not listener["DefaultActions"]:
                logger.debug(listener["DefaultActions"][0]["RedirectConfig"]["Host"])
            listenerArn = listener["ListenerArn"]
            printListenerRules(listenerArn)


def printListenerRules(listenerArn):
    logger.debug("printing Listener Rules...")
    try:
        response = elbv2.describe_rules(ListenerArn=listenerArn)
        logger.debug(response)
        if response["Rules"]:
            for rule in response["Rules"]:
                logger.debug(rule)
                printRule(rule)
    except Exception as e:
        logger.error(e)
        return



def printRule(rule):
    try:
        if rule["Conditions"]:
            for condition in rule["Conditions"]:
                if condition["Field"] == "host-header":
                    print(*condition["Values"], sep = "\n")
    except Exception as e:
        logger.error("Error at printing rule \n %s", json.dumps(rule, indent=2))
        logger.error(e)
        return


if __name__ == "__main__":
    print(printEndPointUrls())
    #print(printListenerRules("arn:aws:elasticloadbalancing:......"))


```

## Resources
