---
layout: post
title: "Using LDAP and AD"
date: 2022-02-13 08:50:00 -0400
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
```
ldapsearch -H ldaps://ad.example.com:636 -x -D mahendran -w XXXXX -b "cn=Super Heros,ou=example,ou=com" "objectClass=*"
```
This simple command could bring entire AD objects. That may not be your intention. Or result into error like certficate error or too much result. Here are other useful parameters 

    -Z or --trustAll ==> to avoid certificate errors
    -z 100 ==> to limit 100 records
    -j /path/to/password.txt or --passwordFile /path/to/password.txt ==> to avoid leaving password in the history

At times we may need few attributes instead of all. We can specify the list of attributes 

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


## Bad and Pain giving practices
- Avoid escape needed characters in naming as it is painful to construct the search filter by carefully escaping it.
    - Example: cn=Super Heros,ou=groups,dc=(Just for pain),dc=example,dc=com
    - To search...
```
ldapsearch -H ldaps://ad.example.com:636 -x -D mahendran -w XXXXX  -b "cn=Super Heros,ou=groups,dc=(Just for pain),dc=example,dc=com" -s sub -a always "(heroName=Captain America)" 
```