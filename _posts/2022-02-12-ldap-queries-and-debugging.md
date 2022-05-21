---
layout: post
title: "Using LDAP and AD"
date: 2022-02-13 08:50:00 -0400
modified_date: 2022-05-21 12:05:00 -0400
categories: ldap
---

LDAP (Lightweight Directory Access Protocol) is is an open, vendor-neutral, industry standard protocol. to talk to directory service database.
There are many Java implementation of LDAP, Here are few I know of
- OpenLDAP
- Unbound SDK
- Apache LDAP SDK


Also there are many implementation of directory service databases. Here are few I know of
- Microsoft Active Directory
- OpenDJ
- ApacheDS
- AWS Directory Service
- OpenLDAP

## LDAP client tools to browse
These are my favoirte tools I recommend to browse
- ldapadmin - http://www.ldapadmin.org/
- Apache Directory Studio - https://directory.apache.org/studio/
- JXplorer - http://jxplorer.org/
- commands like ldapsearch (Beware: parameters are not consistent across various implementation)

## Important Authentication errors
Here are few errors which should be considered while writing authentication or connection using API as these will surprise later if skipped

### Password Expired - 532
- When service accounts mistakenly set to expire we will see this when you are in vacation
- When users doesn't get any means of notification from directory service about their password expiry, they will call you with confident that their password is correct as it is stored in their password vault and worked yesterday.

com.unboundid.ldap.sdk.LDAPBindException: 80090308: LdapErr: DSID-0C090439, comment: AcceptSecurityContext error, data 532, v4563



## LDAP Search

Note: The parameters described here tested based on Gluu opendj (which is a fork of forgerock)
Minimum parameters to supply for search...
```sh
ldapsearch -H ldaps://ad.example.com:636 -x -D mahendran -w XXXXX -b "cn=Super Heros,ou=example,ou=com" "objectClass=*"
```
This simple command could bring entire AD objects. That may not be your intention. Or result into error like certficate error or too much result. Here are other useful parameters 

    -Z or --trustAll ==> to avoid certificate errors
    -z 100 or -E pr=100 ==> to limit 100 records
    -j /path/to/password.txt or --passwordFile /path/to/password.txt or -w `cat /path/to/password.txt` ==> to avoid leaving password in the history

At times we may need few attributes instead of all. We can specify the list of attributes with space

```sh
ldapsearch -H ldaps://ad.example.com:636 -x -D mahendran -w XXXXX -b "cn=Super Heros,ou=example,ou=com" "objectClass=*" dn mail
```

To search entries which does not have a specific attribute

```
ldapsearch -H ldaps://ad.example.com:636 -x -D mahendran -w XXXXX -b "cn=Super Heros,ou=example,ou=com" "(!(mail=*))" # without email address
ldapsearch -H ldaps://ad.example.com:636 -x -D mahendran -w XXXXX -b "cn=Super Heros,ou=example,ou=com" "(!(uid=*))" # without uid attribute
```
## Search filter
If your AD has large number of records, it is recommended to apply filter so you get the result you wanted and faster.
To get it efficiently, use filters (https://ldap.com/ldap-filters/)

Using wild card sometime required but it also affects both client and server. For exampple using (uid=*).

It is good to keep some of your base DNs and attribute names which can help narrow down the search.
For example, 
- your AD may have separate DNs for employee, contractors, machines, shared accounts.
- Specific AD group (DL or Security Group) for separating it.
- Maybe there is separate objectClass defined.

Using AND (&) and OR(|) makes search powerful and avoid transferring unwanted data over the wire.
When using logical operations and more filter, it is easy to loose track of paranthesis.
Its is good idea to prepare the structure (&()()(|()())) before filling conditions.

```
(&
    (objectclass=user)
    (objectcategory=person)
    (memberOf=cn=Super Heros,ou=groups,dc=avengers,dc=example,dc=com)
)
```

## Limit/Page the number of records
Use `-E pr=10` to get limitted number of records like pagination.

For scripting, we can avoid prompt for manual intervention `-E pr=1000/noprompt`.

## Counting
There is no straight query to get the count from ldap server based on a search criteria.
We have to search get records and count them by scripting.


```sh
ldapsearch -H ldaps://ad.example.com:636 -E pr=1000/noprompt -x -D mahendran -w XXXXX  -b "dc=example,dc=com" -s sub -a always "(memberOf=cn=Super Heros,ou=groups,dc=avengers,dc=example,dc=com)" dn | grep 'dn:' | wc -l
```


OpenDJ has option to count the records `--countEntries`. This will still print the `dn` values of all counted.
```sh
$ /opt/opendj/bin/ldapsearch -h localhost -p 1636 -Z -X -D "cn=directory manager" --bindPasswordFile /tmp/.pw -b 'dc=example,dc=com' --countEntries 'creationTimestamp=20210607171657.798Z' dn
.
.
.
# Total number of matching entries: 70
$ /opt/opendj/bin/ldapsearch -h localhost -p 1636 -Z -X -D "cn=directory manager" --bindPasswordFile /tmp/.pw -b 'dc=example,dc=com' --countEntries 'creationTimestamp>=20210607171657.798Z' dn
$ /opt/opendj/bin/ldapsearch -h localhost -p 1636 -Z -X -D "cn=directory manager" --bindPasswordFile /tmp/.pw -b 'dc=example,dc=com' --countEntries '(&(creationTimestamp>=20220207000000.000Z)(creationTimestamp<=20220208000000.000Z))' dn
```


## Bad and Pain giving practices
- Avoid escape needed characters in naming as it is painful to construct the search filter by carefully escaping it.
    - Example: cn=Super Heros,ou=groups,dc=(Just for pain),dc=example,dc=com
    - To search...
```sh
ldapsearch -H ldaps://ad.example.com:636 -x -D mahendran -w XXXXX  -b "dc=example,dc=com" -s sub -a always "(memberOf=cn=Super Heros,ou=groups,dc=\28Just for pain\29,dc=example,dc=com)" 
```

## Tips
