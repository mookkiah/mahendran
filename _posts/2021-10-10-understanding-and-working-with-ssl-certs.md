---
layout: post
title:  "Understanding & Working with SSL certificates"
date:   2021-10-09 07:34:00  -0400
modified_date:   2022-04-02 09:40:00  -0400
categories: security ssl
---


In happy days, everything works just fine. At times, when working with SSL related topics it will be challenging get things right. The main reasons could be one of these
- Certificate expired
- Self-Signed Certificate used
- Internal Certificate Authrority used

We can find many simulated ssl found in https://badssl.com/

These reasons could result in error in estabilishing connection.

## Understanding the certificate

We can verify the validity of SSL certificate of a url by checking the lock icon on your browswer when accessing it.

When the url publically available, we can check the certificate using https://www.sslshopper.com/ssl-checker.html

For example try checking https://expired.badssl.com/ with [ssl-checker](https://www.sslshopper.com/ssl-checker.html#hostname=https://expired.badssl.com/)

Note: if your organization uses ssl rewriting and internal Certificate Authrity, it gets tricky and the best resource you have is commandline tools like curl, openssl, keytool.


```
mahendran@mm-lab ~ % curl https://expired.badssl.com/
curl: (60) SSL certificate problem: certificate has expired
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
```
Note: curl will give the reason at `SSL certificate problem`. Try accessing every problematic url available in https://badssl.com/.


In openssl we can see the `verify` and `Certificate chain` sections which gives similar information as ssl-checker web tool.

```
mahendran@mm-lab ~ % openssl s_client -showcerts -connect expired.badssl.com:443 </dev/null 2>&1
CONNECTED(00000005)
depth=0 C = US, ST = California, L = San Francisco, O = BadSSL Fallback. Unknown subdomain or no SNI., CN = badssl-fallback-unknown-subdomain-or-no-sni
verify error:num=20:unable to get local issuer certificate
verify return:1
depth=0 C = US, ST = California, L = San Francisco, O = BadSSL Fallback. Unknown subdomain or no SNI., CN = badssl-fallback-unknown-subdomain-or-no-sni
verify error:num=21:unable to verify the first certificate
verify return:1
---
Certificate chain
 0 s:/C=US/ST=California/L=San Francisco/O=BadSSL Fallback. Unknown subdomain or no SNI./CN=badssl-fallback-unknown-subdomain-or-no-sni
   i:/C=US/ST=California/L=San Francisco/O=BadSSL/CN=BadSSL Intermediate Certificate Authority
-----BEGIN CERTIFICATE-----
MIIE8DCCAtigAwIBAgIJAM28Wkrsl2exMA0GCSqGSIb3DQEBCwUAMH8xCzAJBgNV
BAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRYwFAYDVQQHDA1TYW4gRnJhbmNp
c2NvMQ8wDQYDVQQKDAZCYWRTU0wxMjAwBgNVBAMMKUJhZFNTTCBJbnRlcm1lZGlh
dGUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MB4XDTE2MDgwODIxMTcwNVoXDTE4MDgw
ODIxMTcwNVowgagxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRYw
FAYDVQQHDA1TYW4gRnJhbmNpc2NvMTYwNAYDVQQKDC1CYWRTU0wgRmFsbGJhY2su
IFVua25vd24gc3ViZG9tYWluIG9yIG5vIFNOSS4xNDAyBgNVBAMMK2JhZHNzbC1m
YWxsYmFjay11bmtub3duLXN1YmRvbWFpbi1vci1uby1zbmkwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQDCBOz4jO4EwrPYUNVwWMyTGOtcqGhJsCK1+ZWe
sSssdj5swEtgTEzqsrTAD4C2sPlyyYYC+VxBXRMrf3HES7zplC5QN6ZnHGGM9kFC
xUbTFocnn3TrCp0RUiYhc2yETHlV5NFr6AY9SBVSrbMo26r/bv9glUp3aznxJNEx
tt1NwMT8U7ltQq21fP6u9RXSM0jnInHHwhR6bCjqN0rf6my1crR+WqIW3GmxV0Tb
ChKr3sMPR3RcQSLhmvkbk+atIgYpLrG6SRwMJ56j+4v3QHIArJII2YxXhFOBBcvm
/mtUmEAnhccQu3Nw72kYQQdFVXz5ZD89LMOpfOuTGkyG0cqFAgMBAAGjRTBDMAkG
A1UdEwQCMAAwNgYDVR0RBC8wLYIrYmFkc3NsLWZhbGxiYWNrLXVua25vd24tc3Vi
ZG9tYWluLW9yLW5vLXNuaTANBgkqhkiG9w0BAQsFAAOCAgEAsuFs0K86D2IB20nB
QNb+4vs2Z6kECmVUuD0vEUBR/dovFE4PfzTr6uUwRoRdjToewx9VCwvTL7toq3dd
oOwHakRjoxvq+lKvPq+0FMTlKYRjOL6Cq3wZNcsyiTYr7odyKbZs383rEBbcNu0N
c666/ozs4y4W7ufeMFrKak9UenrrPlUe0nrEHV3IMSF32iV85nXm95f7aLFvM6Lm
EzAGgWopuRqD+J0QEt3WNODWqBSZ9EYyx9l2l+KI1QcMalG20QXuxDNHmTEzMaCj
4Zl8k0szexR8rbcQEgJ9J+izxsecLRVp70siGEYDkhq0DgIDOjmmu8ath4yznX6A
pYEGtYTDUxIvsWxwkraBBJAfVxkp2OSg7DiZEVlMM8QxbSeLCz+63kE/d5iJfqde
cGqX7rKEsVW4VLfHPF8sfCyXVi5sWrXrDvJm3zx2b3XToU7EbNONO1C85NsUOWy4
JccoiguV8V6C723IgzkSgJMlpblJ6FVxC6ZX5XJ0ZsMI9TIjibM2L1Z9DkWRCT6D
QjuKbYUeURhScofQBiIx73V7VXnFoc1qHAUd/pGhfkCUnUcuBV1SzCEhjiwjnVKx
HJKvc9OYjJD0ZuvZw9gBrY7qKyBX8g+sglEGFNhruH8/OhqrV8pBXX/EWY0fUZTh
iywmc6GTT7X94Ze2F7iB45jh7WQ=
-----END CERTIFICATE-----
---
Server certificate
subject=/C=US/ST=California/L=San Francisco/O=BadSSL Fallback. Unknown subdomain or no SNI./CN=badssl-fallback-unknown-subdomain-or-no-sni
issuer=/C=US/ST=California/L=San Francisco/O=BadSSL/CN=BadSSL Intermediate Certificate Authority
---
No client certificate CA names sent
Server Temp Key: ECDH, P-256, 256 bits
---
SSL handshake has read 1938 bytes and written 322 bytes
---
New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES128-GCM-SHA256
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES128-GCM-SHA256
    Session-ID: 2C93EBF68CE24C130CC33C3790D9DF258DFC3639F4308F5E827F448D7FE71235
    Session-ID-ctx: 
    Master-Key: 7022726C17ECF53A7578455B007A930DE4D084F535CDA411975A8C596547F359C9B264C1D6663BBE91ADF2AA203AF7DB
    TLS session ticket lifetime hint: 300 (seconds)
    TLS session ticket:
    0000 - 5b d5 ed df 6b dc 79 68-af a2 3e 33 a2 72 4a fe   [...k.yh..>3.rJ.
    0010 - 9a 52 1c 41 c5 88 ba 1f-07 f3 6c 0d 01 02 38 e8   .R.A......l...8.
    0020 - e1 ef 0b d3 54 ab 06 e5-a1 bd 04 59 46 8b 1d 59   ....T......YF..Y
    0030 - ec 75 25 68 14 bb 8d 0b-87 32 4d 69 64 d7 30 bf   .u%h.....2Mid.0.
    0040 - ae b7 68 fe b0 c0 49 48-ec 48 68 f7 72 07 fb d3   ..h...IH.Hh.r...
    0050 - 4b dc 69 ca 55 5e 25 c7-c0 c1 31 1d 8c 32 d8 48   K.i.U^%...1..2.H
    0060 - 41 fa a2 e5 9e cb a1 b8-8a 79 51 99 72 4d 29 0a   A........yQ.rM).
    0070 - 84 da 26 1a cc f5 2d 7e-e7 1b 7d 54 f6 8d 8f b0   ..&...-~..}T....
    0080 - b7 bc 30 e7 c7 6f 48 93-08 e7 e0 4b c9 95 b6 a6   ..0..oH....K....
    0090 - 66 92 a5 c9 ff 17 8c 31-35 2f e9 4e 97 59 90 10   f......15/.N.Y..
    00a0 - 84 3a b9 01 d0 53 bc 02-34 bf b6 03 4a 51 84 9e   .:...S..4...JQ..

    Start Time: 1633780796
    Timeout   : 7200 (sec)
    Verify return code: 21 (unable to verify the first certificate)
---
poll error%

```

To extract just the certificate from url...

```
mahendran@mm-lab ~ % openssl s_client -showcerts -connect expired.badssl.com:443 </dev/null 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > expired-badssl.crt
```
To view the details of a certificate like [ssl-decoder](https://www.sslshopper.com/certificate-decoder.html)

Note the `Validity`
```
mahendran@mm-lab ~ % openssl x509 -in expired-badssl.crt -text -noout
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 14824823351240255409 (0xcdbc5a4aec9767b1)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=US, ST=California, L=San Francisco, O=BadSSL, CN=BadSSL Intermediate Certificate Authority
        Validity
            Not Before: Aug  8 21:17:05 2016 GMT
            Not After : Aug  8 21:17:05 2018 GMT
        Subject: C=US, ST=California, L=San Francisco, O=BadSSL Fallback. Unknown subdomain or no SNI., CN=badssl-fallback-unknown-subdomain-or-no-sni
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:c2:04:ec:f8:8c:ee:04:c2:b3:d8:50:d5:70:58:
                    cc:93:18:eb:5c:a8:68:49:b0:22:b5:f9:95:9e:b1:
                    2b:2c:76:3e:6c:c0:4b:60:4c:4c:ea:b2:b4:c0:0f:
                    80:b6:b0:f9:72:c9:86:02:f9:5c:41:5d:13:2b:7f:
                    71:c4:4b:bc:e9:94:2e:50:37:a6:67:1c:61:8c:f6:
                    41:42:c5:46:d3:16:87:27:9f:74:eb:0a:9d:11:52:
                    26:21:73:6c:84:4c:79:55:e4:d1:6b:e8:06:3d:48:
                    15:52:ad:b3:28:db:aa:ff:6e:ff:60:95:4a:77:6b:
                    39:f1:24:d1:31:b6:dd:4d:c0:c4:fc:53:b9:6d:42:
                    ad:b5:7c:fe:ae:f5:15:d2:33:48:e7:22:71:c7:c2:
                    14:7a:6c:28:ea:37:4a:df:ea:6c:b5:72:b4:7e:5a:
                    a2:16:dc:69:b1:57:44:db:0a:12:ab:de:c3:0f:47:
                    74:5c:41:22:e1:9a:f9:1b:93:e6:ad:22:06:29:2e:
                    b1:ba:49:1c:0c:27:9e:a3:fb:8b:f7:40:72:00:ac:
                    92:08:d9:8c:57:84:53:81:05:cb:e6:fe:6b:54:98:
                    40:27:85:c7:10:bb:73:70:ef:69:18:41:07:45:55:
                    7c:f9:64:3f:3d:2c:c3:a9:7c:eb:93:1a:4c:86:d1:
                    ca:85
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            X509v3 Subject Alternative Name: 
                DNS:badssl-fallback-unknown-subdomain-or-no-sni
    Signature Algorithm: sha256WithRSAEncryption
         b2:e1:6c:d0:af:3a:0f:62:01:db:49:c1:40:d6:fe:e2:fb:36:
         67:a9:04:0a:65:54:b8:3d:2f:11:40:51:fd:da:2f:14:4e:0f:
         7f:34:eb:ea:e5:30:46:84:5d:8d:3a:1e:c3:1f:55:0b:0b:d3:
         2f:bb:68:ab:77:5d:a0:ec:07:6a:44:63:a3:1b:ea:fa:52:af:
         3e:af:b4:14:c4:e5:29:84:63:38:be:82:ab:7c:19:35:cb:32:
         89:36:2b:ee:87:72:29:b6:6c:df:cd:eb:10:16:dc:36:ed:0d:
         73:ae:ba:fe:8c:ec:e3:2e:16:ee:e7:de:30:5a:ca:6a:4f:54:
         7a:7a:eb:3e:55:1e:d2:7a:c4:1d:5d:c8:31:21:77:da:25:7c:
         e6:75:e6:f7:97:fb:68:b1:6f:33:a2:e6:13:30:06:81:6a:29:
         b9:1a:83:f8:9d:10:12:dd:d6:34:e0:d6:a8:14:99:f4:46:32:
         c7:d9:76:97:e2:88:d5:07:0c:6a:51:b6:d1:05:ee:c4:33:47:
         99:31:33:31:a0:a3:e1:99:7c:93:4b:33:7b:14:7c:ad:b7:10:
         12:02:7d:27:e8:b3:c6:c7:9c:2d:15:69:ef:4b:22:18:46:03:
         92:1a:b4:0e:02:03:3a:39:a6:bb:c6:ad:87:8c:b3:9d:7e:80:
         a5:81:06:b5:84:c3:53:12:2f:b1:6c:70:92:b6:81:04:90:1f:
         57:19:29:d8:e4:a0:ec:38:99:11:59:4c:33:c4:31:6d:27:8b:
         0b:3f:ba:de:41:3f:77:98:89:7e:a7:5e:70:6a:97:ee:b2:84:
         b1:55:b8:54:b7:c7:3c:5f:2c:7c:2c:97:56:2e:6c:5a:b5:eb:
         0e:f2:66:df:3c:76:6f:75:d3:a1:4e:c4:6c:d3:8d:3b:50:bc:
         e4:db:14:39:6c:b8:25:c7:28:8a:0b:95:f1:5e:82:ef:6d:c8:
         83:39:12:80:93:25:a5:b9:49:e8:55:71:0b:a6:57:e5:72:74:
         66:c3:08:f5:32:23:89:b3:36:2f:56:7d:0e:45:91:09:3e:83:
         42:3b:8a:6d:85:1e:51:18:52:72:87:d0:06:22:31:ef:75:7b:
         55:79:c5:a1:cd:6a:1c:05:1d:fe:91:a1:7e:40:94:9d:47:2e:
         05:5d:52:cc:21:21:8e:2c:23:9d:52:b1:1c:92:af:73:d3:98:
         8c:90:f4:66:eb:d9:c3:d8:01:ad:8e:ea:2b:20:57:f2:0f:ac:
         82:51:06:14:d8:6b:b8:7f:3f:3a:1a:ab:57:ca:41:5d:7f:c4:
         59:8d:1f:51:94:e1:8b:2c:26:73:a1:93:4f:b5:fd:e1:97:b6:
         17:b8:81:e3:98:e1:ed:64
mahendran@mm-lab ~ % 
```

Sometimes when a LoadBalancer which manages the certificate involved between client and server, we may need to pass the `servername` so that LoadBalancer returns the right certificate associated with it.

```
mahendran@mm-lab ~ % nslookup expired.badssl.com
Server:		192.168.1.1
Address:	192.168.1.1#53

Non-authoritative answer:
Name:	expired.badssl.com
Address: 104.154.89.105

mahendran@mm-lab ~ % openssl s_client -showcerts -connect 104.154.89.105:443 -servername expired.badssl.com </dev/null 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > expired-badssl.crt
```

## Certificate Verification process
To have a SSO communication, server needs to equiped with a asymmetric based encryption keys. Also server works with Certificate Authroity to get a certificate which contains the public key, validity certificate authority chain and signature.


    These days getting ssl certificate is much easier and even free of cost. So use of self-signed certificate discouraged. When using self-signed, try explaining to a peer / infrastructure engineer who may be able to agree or provide solution.


During the connection process, server sends the certificate to client and its clients resoponsibility to validate the certifcate and decide whether to trust this channel or not.

Client is equiped with a list of Certificate Authority (CA) which we call trust store.

Client does...
- check validity of the certs
- finds the certificate chain 
- it  follows the certificate chain and checks if that issuer already in the trusted list. When it is not, it goes up in the chain until it finds a trusted CA. During this process, it also checks the validity of CA.


    Note

    Certificate chain contains multiple certs indexed to represent the order of chain. In that one end is the server certificate and another end is called "Root CA". All inbetween called "Intermediary CA".

Now we can detect expired certificates, self-signed certificates or having a certificate chain where client trust anyone of them

## How to trust a new certificate or Certificate Authority (DO NOT TRUST WHEN YOU DON'T KNOW THE CA)
Mostly trusting ceritifcate is required during development process when self signed certificate used. As said earlier try avoiding it.

Requirement to add new CA comes only when the clients trust store really old and not managed/monitored by infrastructure/cyber security team. Adding a CA to trust means lot for cyber security perspective. Please consult and verify the CA.

It is normal organizaton to have intermediatory CA which needs to be added to all kinds of clients trust store. It will be done by the infrastructure level using tools like `update-ca-certificates` in linux. This tool will apply the CA in the system in differnt format which is used by differnt programming methods (java/curl/python/browser). Those files called like cacerts, pem, nssdb etc.,


Let's assume your organization has its own internal Root CA and your client program not aware of this CA. It will result problem like what you see while using https://untrusted-root.badssl.com/

Let's leave the `update-ca-certificates` command execution to the infrastructure engineer.

Let's see how to add a certificate to specific trust store. Also to remove it as well. 

### Managing Java cacerts
Java keeps the trusted CA list in a file called `cacerts`. This file comes with the install under $JAVA_HOME/jre/lib/security directory. It contains almost all legitimate root CAs at the time of release. 

Sometimes, when installed by installer or managed by infrastructure cacerts will be linked to the location where it is maintained (by infrastructure team and maybe by update-ca-certificate tool)

When managed by infrastructure team, most likely you will not have permission to edit this file. Situation gets tricky.

This is when application developer takes shortcut and copy the file and place it somewhere he/she can edit and configure java program to use it by spefifying system property `javax.net.ssl.trustStore`. This works but missing the infrastructure updates like change in interal CA changes.

you can run this script in  `jshell` and see `PKIX` error appearing. This tells that java client does not trust the server to open connection
```
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
System.setProperty("javax.net.debug", "all");
var request = HttpRequest.newBuilder(URI.create("https://untrusted-root.badssl.com/")).GET().build();
var client = HttpClient.newHttpClient();
var body = client.send(request, HttpResponse.BodyHandlers.ofString());
```

Note: Look for a log message which shows where the `trustStore is` 
```
javax.net.ssl|DEBUG|01|main|2021-10-10 08:48:53.941 EDT|TrustStoreManager.java:113|trustStore is: /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home/lib/security/cacerts
trustStore type is: pkcs12
trustStore provider is: 
the last modified time is: Tue Sep 15 12:15:49 EDT 2020
```

As mentioned earlier, it maynot be editable for all users
```
mahendran@mm-lab ~ % ls -l /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home/lib/security/       
total 688
-rw-r--r--  1 root  wheel    1253 Sep 15  2020 blacklisted.certs
-rw-r--r--  1 root  wheel  101001 Sep 15  2020 cacerts
-rw-r--r--  1 root  wheel    9525 Sep 15  2020 default.policy
-rw-r--r--  1 root  wheel  232578 Sep 15  2020 public_suffix_list.dat
```

Let's extract certificate from the server
```
openssl s_client -showcerts -connect untrusted-root.badssl.com:443  </dev/null 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > untrusted-root.badssl.com.crt
```



Import this certificate(s) to cacerts as trusted server. (Take a backup of cacerts before) or make a copy of cacerts file to experiment.


When  you have intermidiate certs... you will see multie certificates from above command. Java keytool imports only one certificate at a time.
Either you can split and use keytool import individually. Or use below script `keytool_import_all.sh` to import them all.

```keytool_import_all.sh
#!/bin/bash
PEM_FILE=$1
PASSWORD=$2
KEYSTORE=$3
# number of certs in the PEM file
CERTS=$(grep 'END CERTIFICATE' $PEM_FILE| wc -l)

# For every cert in the PEM file, extract it and import into the JKS keystore
# awk command: step 1, if line is in the desired cert, print the line
#              step 2, increment counter when last line of cert is found
for N in $(seq 0 $(($CERTS - 1))); do
  ALIAS="${PEM_FILE%.*}-$N"
  cat $PEM_FILE |
    awk "n==$N { print }; /END CERTIFICATE/ { n++ }" |
    keytool -noprompt -import -trustcacerts \
            -alias $ALIAS -keystore $KEYSTORE -storepass $PASSWORD
done
```

```
mahendran@mm-lab ~ % openssl s_client -showcerts -connect google.com:443  </dev/null 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > google-chain.crt
mahendran@mm-lab ~ % ./keytool_import_all.sh google-chain.crt changeit ~/cacerts-with-badssl
mahendran@mm-lab ~ % ./keytool_import_all.sh google-chain.crt changeit ~/cacerts-with-badssl
Certificate was added to keystore
Certificate was added to keystore
Certificate was added to keystore
mahendran@mm-lab ~ %
```

```
mahendran@mm-lab ~ % cp /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home/lib/security/cacerts ~/adoptopenjdk-15.jdk-cacerts.original

mahendran@mm-lab ~ % keytool -importcert -alias untrusted-root.badssl -file untrusted-root.badssl.com.crt -keystore /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home/lib/security/cacerts -storepass changeit -noprompt
Warning: use -cacerts option to access cacerts keystore
Certificate was added to keystore
keytool error: java.io.FileNotFoundException: /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home/lib/security/cacerts (Permission denied)

mahendran@mm-lab ~ % cp /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home/lib/security/cacerts ~/cacerts-with-badssl 

mahendran@mm-lab ~ % keytool -importcert -alias untrusted-root.badssl -file untrusted-root.badssl.com.crt -keystore ~/cacerts-with-badssl  -storepass changeit -noprompt
Certificate was added to keystore

mahendran@mm-lab ~ % #Aleternative to above 
mahendran@mm-lab ~ % ./keytool_import_all.sh untrusted-root.badssl.com.crt changeit ~/cacerts-with-badssl
```



```
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
System.setProperty("javax.net.ssl.trustStore", System.getProperty("user.home")+"/cacerts-with-badssl");
System.setProperty("javax.net.ssl.trustStorePassword","changeit");
System.setProperty("javax.net.debug", "all");
var request = HttpRequest.newBuilder(URI.create("https://untrusted-root.badssl.com/")).GET().build();
var client = HttpClient.newHttpClient();
var body = client.send(request, HttpResponse.BodyHandlers.ofString());
```

    Note: untrusted-root.badssl.com not just holding untrusted cert, it is also missing to provide information about the CA which is blocking us to trust this site. This process should work when you have all intermediate CA certificate available in the certificate chain to add it to cacerts

## Explicitly mentioning cacerts path
At times we may not have the permission to move or import certificate into cacerts file. In that case we could copy existing cacerts to a place where we can have edit permission. Then import the certificate as mentioned above. 

To test the application using the new cacerts file in differnt location, add following JVM parameters to the java command. `changeit` is the default password. In your case use your cacerts password. If it is `changeit`, just a friendly advice... there is a reason why that password choosen like that :-).
```
java -Djavax.net.ssl.trustStore=custompath/cacerts -Djavax.net.ssl.trustStorePassword=changeit
```

## List certs from Java cacerts
```
$ keytool -list -keystore cacerts -storepass changeit
```