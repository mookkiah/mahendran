---
layout: post
title: "ActiveDirectory PowerShell commands"
date: 2023-01-07 10:22:00 -0400
modified_date: 2023-11-02 04:47:00  -0400
categories: powershell activedirectory
---

Search user with username (or other unique identity fields)

```
Get-Aduser -Identity username -Properties uid
```

Properties to look when login authentication failed.

```
Get-Aduser -Identity username -Properties whenChanged,Modified,modifyTimeStamp,Enabled,lastLogoff,lastLogon,LastLogonDate,lastLogonTimestamp,LockedOut,lockoutTime,logonCount,PasswordExpired,PasswordLastSet,PasswordNeverExpires,PasswordNotRequired,Deleted
```

```
whenChanged                           : 7/27/2023 9:25:03 AM
Modified                              : 7/27/2023 9:25:03 AM
modifyTimeStamp                       : 7/27/2023 9:25:03 AM
Enabled                               : True
lastLogoff                            : 0
lastLogon                             : 133340826176129800
LastLogonDate                         : 7/27/2023 9:24:28 AM
lastLogonTimestamp                    : 133349378682017682
LockedOut                             : False
lockoutTime                           : 0
logonCount                            : 529
PasswordExpired                       : True
PasswordLastSet                       : 5/30/2023 4:04:24 PM
PasswordNeverExpires                  : False
PasswordNotRequired                   : False
Deleted                               :
isDeleted                             :
LastBadPasswordAttempt                : 6/20/2023 2:17:28 PM
BadLogonCount                         : 0
badPasswordTime                       : 133317586488746553
badPwdCount                           : 0
AccountExpirationDate                 :
accountExpires                        : 0
AccountLockoutTime                    :
pwdLastSet                            : 133299506643052373
SamAccountName                        : mahendran
```

If you need to apply filter, it should be wrapped like below

```
Get-ADUser -filter {(uid -like "ABCD1234")}
Get-ADUser -filter {(mail -like "mahendran*")}
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

To get the member of

```
(Get-ADUser -filter {(mail -like "mahendran.mookkiah@mm-notes.com")} -Properties MemberOf | Select-Object MemberOf).MemberOf
```

```
(Get-ADUser username -properties *).MemberOf
```

Alternatively we can get group membership object and filter name out of it.

```
Get-ADPrincipalGroupMembership username | select name
```

To get AD Group

```
Get-ADGroup -Identity Group name
```

To get users who are member of a Group (child groups - recursive)

```
Get-ADGroupMember -Identity GroupName
Get-ADGroupMember -Identity Administators
Get-ADGroupMember -Identity "Enterprise Admins" -Recursive
```

To compare two user's group membership

```
Compare-Object -ReferenceObject (Get-AdPrincipalGroupMembership smithj | select name | sort-object -Property name) -DifferenceObject (Get-AdPrincipalGroupMembership charlesk | select name | sort-object -Property name) -property name -passthru
```

### Useful scripts

#### Comparing AD users

```
Function Compare-ADUser {
    [cmdletbinding(SupportsShouldProcess)]

    Param(
        [parameter(Mandatory = $true)]
        [string]$ReferenceUser,

        [parameter(Mandatory = $true)]
        [string]$DifferenceUser,

        [parameter()]
        [string[]]$Property
    )

    begin {}

    process {
        if ($pscmdlet.ShouldProcess("$ReferenceUser & $DifferenceUser", "Comparing users")) {
            $ReferenceUserSplat = @{ Identity  = $ReferenceUser }
            $DifferenceUserSplat = @{ Identity = $DifferenceUser }

            if ($PSBoundParameters.ContainsKey("Property")) {
                $ReferenceUserSplat.Properties  = $Property
                $DifferenceUserSplat.Properties = $Property
            }

            $ReferenceObject  = Get-ADUser @ReferenceUserSplat
            $DifferenceObject = Get-ADUser @DifferenceUserSplat

            $properties  =  $ReferenceObject.GetEnumerator() | % { $_.Key }
            $properties += $DifferenceObject.GetEnumerator() | % { $_.Key }

            foreach ($prop in $properties | Sort | Select -Unique ) {
                $ReferenceProperty = $ReferenceObject.($prop)
                $DifferenceProperty = $DifferenceObject.($prop)

                try {
                    Remove-Variable comparison -ErrorAction SilentlyContinue
                    $comparison = Compare-Object -ReferenceObject $ReferenceProperty -DifferenceObject $DifferenceProperty -IncludeEqual -ErrorAction SilentlyContinue
                }
                catch {
                }
                finally {
                    if ( (($comparison.sideindicator -notcontains "<=") -and ($comparison.sideindicator -notcontains "=>")) -and -not
                            ($null -eq $ReferenceProperty -xor $null -eq $DifferenceProperty)) {
                        $comparison = "Equal"
                    }
                    else {
                        $comparison = "Different"
                    }
                }

                [pscustomobject]@{
                    Property = $prop
                    Comparison = $comparison
                    ReferenceUser = if ( $ReferenceProperty ) { $ReferenceProperty.ToString().Substring(0, [Math]::Min($ReferenceProperty.ToString().Length, 80)) } else { $null }
                    DifferenceUser = if ( $DifferenceProperty ) { $DifferenceProperty.ToString().Substring(0, [Math]::Min($DifferenceProperty.ToString().Length, 80)) } else { $null }
                }
            }
        }
    }

    end {}
}
```

Usage format and samples

```
Compare-ADUser -ReferenceUser <user1> -DifferenceUser <user2>
Compare-ADUser -ReferenceUser <user1> -DifferenceUser <user2> -Property *
Compare-ADUser -ReferenceUser <user1> -DifferenceUser <user2> -Property "City","state","c"

Compare-ADUser -ReferenceUser <user1> -DifferenceUser <user2> -Property * | findstr Different

```

## References

- https://learn.microsoft.com/en-us/powershell/module/activedirectory
- [LDAP Queries]({% link _posts/2022-02-12-ldap-queries-and-debugging.md %})
- https://learn.microsoft.com/en-us/powershell/azure/az-powershell-proxy
- Compare AD users - https://stackoverflow.com/a/67536658
