---
layout: post
title: "Useful command aliases and functions"
date: 2023-01-16 23:01:00 -0400
modified_date: 2023-01-16 23:01:00 -0400
categories: shell command alias
---

## Motivation
To share useful aliases which saves time to go to browser. Also helps to write scripts.

### URL Encode and Decode
```
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'

```

Example:
```
mahendran@mm-lab mahendran % alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
mahendran@mm-lab mahendran % urlencode https://test@somethi%now                                                        
https%3A%2F%2Ftest%40somethi%25now
mahendran@mm-lab mahendran % urldecode https%3A%2F%2Ftest%40somethi%25now
https://test@somethi%now
mahendran@mm-lab mahendran % 
```

## Switching JDK

Refer [switching JDK]({% link _posts/2021-11-14-switching-jdk-version-quickly.md  %}) in detail.

```
jdk() {
        if [ -z $1 ]
        then
              /usr/libexec/java_home -V  
              echo "******************"
              echo "Command Usage: 'jdk <version>'"
        else
                unset JAVA_HOME
                version=$1
                export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
                java -version
        fi

 }
```