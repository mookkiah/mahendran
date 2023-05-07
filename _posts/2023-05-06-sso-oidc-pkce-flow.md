---
layout: post
title: "OIDC - PKCE"
date: 2023-01-15 21:07:00 -0400
modified_date: 2023-01-28 07:26:00 -0400
categories: sso oidc pkce
---

# OIDC - PKCE

This notes is not covering all possible options or flow using PKCE flow. Just the ones which I got familierized.

## Notes

- PKCE - Proof Key for Code Exchange
- PKCE is an extension to Auth Code Flow to prevent CSRF and authorization code injection attacks.
- PKCE is not replacement for a auth code flow or not just hide client secret for single page application (SPA).
- PKCE playground - https://www.oauth.com/playground/authorization-code-with-pkce.html

## Roles

- Client - Thick client, Mobile app or Single Page application.
- Authorization server - server which hosts `authorize` and `token` endpoint.
- Subject (Types: public/pairwise)

### Client Registration

client_id = 6fc-UrmwUh1xvMaxVCrYyiN1
client_secret = 7N5bsIR1eLyIQ7i7GzZIPa1omTi6fnoroeoy3TZYepldwYs1
login = magnificent-ladybird@example.com
password = Rich-Peacock-25

Application Type: Web
Browser - Agent

## Diagram

## Protocol flow with example request and response

1. Client - Create a Code Verifier and Challenge

```
code_verifier=d5CRoli7yiNb50-yxRfbE4TxlIoXTtT3PWvLx-H5iYv25j-3
code_challenge=base64url(sha256(code_verifier))=H0sIjnf2WUmu43fGevxymE1uPz-VhPYJcRPZ4mdJyGY

```

2. Client - Build the Authorization URL

The client then needs to generate a random string to use for the state parameter, and needs to store it to be used in the next step.

```
https://authorization-server.com/authorize?
  response_type=code
  &client_id=6fc-UrmwUh1xvMaxVCrYyiN1
  &redirect_uri=https://www.oauth.com/playground/authorization-code-with-pkce.html
  &scope=photo+offline_access
  &state=jiMy4J1ILvq9kfpi
  &code_challenge=H0sIjnf2WUmu43fGevxymE1uPz-VhPYJcRPZ4mdJyGY
  &code_challenge_method=S256
```

From network tab of inspect window

```
GET /playground/auth-dialog.html?response_type=code&client_id=6fc-UrmwUh1xvMaxVCrYyiN1&redirect_uri=https://www.oauth.com/playground/authorization-code-with-pkce.html&scope=photo+offline_access&state=jiMy4J1ILvq9kfpi&code_challenge=H0sIjnf2WUmu43fGevxymE1uPz-VhPYJcRPZ4mdJyGY&code_challenge_method=S256 HTTP/1.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.9,ta;q=0.8
Connection: keep-alive
Cookie: ssm_au_c=kiBpUAOWocs/wPx/jneUDFYSMM22iF+pHU2e7lC2ZER8gAAAAOx6KUSDTneOLobq4jILvj11C1ByQD8L1jPZ9hBUihp8=; gtmNamespaceDeclared=true; sessionCount=1; _ga=GA1.2.112391173.1682965585; _gid=GA1.2.197728825.1682965585; OptanonConsent=isIABGlobal=false&datestamp=Mon+May+01+2023+14%3A28%3A18+GMT-0400+(Eastern+Daylight+Time)&version=6.5.0&hosts=&consentId=b005e256-f424-41c6-99f3-b4748028a320&interactionCount=0&landingPath=NotLandingPage&groups=1%3A1%2C2%3A1%2C3%3A1%2C4%3A0&AwaitingReconsent=false; client_id=6fc-UrmwUh1xvMaxVCrYyiN1; client_secret=7N5bsIR1eLyIQ7i7GzZIPa1omTi6fnoroeoy3TZYepldwYs1; okta_url=https://authorization-server.com; base_url=https://www.oauth.com/playground; user_login=magnificent-ladybird@example.com; user_password=Rich-Peacock-25; oauth2-code-verifier=d5CRoli7yiNb50-yxRfbE4TxlIoXTtT3PWvLx-H5iYv25j-3; oauth2-state=jiMy4J1ILvq9kfpi
DNT: 1
Host: www.oauth.com
Referer: https://www.oauth.com/playground/authorization-code-with-pkce.html
Sec-Fetch-Dest: document
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: same-origin
Sec-Fetch-User: ?1
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36
sec-ch-ua: "Chromium";v="112", "Google Chrome";v="112", "Not:A-Brand";v="99"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "macOS"

```

3. Authorization server redirects user to login screen
4. User enters valid credential
5. Authorization server redirects to client with code and state

```
?state=jiMy4J1ILvq9kfpi&code=z0RIFlflq5JF1Nf0e-5psMGQ7sIjzH1nSSpEhvfaROqxVTBX
```

6. client verifies state
   Optionally client can verify the state. Before PKCE flow state used to provide CSRF protection.
   Does the state stored by the client (jiMy4J1ILvq9kfpi) match the state in the redirect (jiMy4J1ILvq9kfpi)?

7. Exchange the Authorization Code
   Token endpoint takes `code` and `code_verifier`.

```
POST https://authorization-server.com/token

grant_type=authorization_code
&client_id=6fc-UrmwUh1xvMaxVCrYyiN1
&client_secret=7N5bsIR1eLyIQ7i7GzZIPa1omTi6fnoroeoy3TZYepldwYs1
&redirect_uri=https://www.oauth.com/playground/authorization-code-with-pkce.html
&code=z0RIFlflq5JF1Nf0e-5psMGQ7sIjzH1nSSpEhvfaROqxVTBX
&code_verifier=d5CRoli7yiNb50-yxRfbE4TxlIoXTtT3PWvLx-H5iYv25j-3
```

8. Authorization server verifies code_verifier to offere CSRF protection and verifies code to generate token

```
{
  "token_type": "Bearer",
  "expires_in": 86400,
  "access_token": "bB-FwJzKY3rLwTxddz-ge-cscmR_dJk9hFFCJKjY8D0ftQhIt1fgVkTYxpgchTE6ljciXO_G",
  "scope": "photo offline_access",
  "refresh_token": "i9ouA3C4WrEitsms15igz6y1"
}
```

## Reference:

1. https://openid.net/specs/openid-connect-core-1_0.html
1. https://datatracker.ietf.org/doc/html/rfc7636
1. https://oauth.net/2/pkce/
1. https://gluu.org/docs/gluu-server/4.1/api-guide/openid-connect-api/
1. https://medium.com/swlh/pkce-flow-of-openid-connect-9b10ddbabd66
