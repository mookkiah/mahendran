---
layout: post
title:  "ActiveDirectory PowerShell commands"
date: 2023-01-07 10:22:00  -0400
modified_date: 
categories: powershell activedirectory
---

Search user with username (or other unique identity fields)
```
Get-Aduser -Identity mookkiahm -Properties uid
```

If you need to apply filter, it should be wrapped like below
```
Get-ADUser -filter {(uid -like "ABCD1234")}
```


To limit to particular search base for improving response time
```
(Get-ADUser -filter {(uid -like "ABCD*")} -SearchBase "ou=example,ou=com").Count
```


Treat the resutl as object and perform operation (ex:Count) 
```
(Get-ADUser -filter {(uid -like "*")} -SearchBase "ou=example,ou=com").Count
```


To extract some attributes as CSV file
```
 Get-ADUser -filter {(uid -like "*")} -SearchBase "ou=example,ou=com" -Properties * | Select-Object SamAccountName,@{name="uid";expression={$_.uid -join ";"}},mail | export-csv -path users.csv
 ```


## Reference
- https://learn.microsoft.com/en-us/powershell/module/activedirectory
- [LDAP Queries]({% link _posts/2022-02-12-ldap-queries-and-debugging.md %})