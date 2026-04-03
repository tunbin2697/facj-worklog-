---
title: "Phase 6 - Authentication and DNS"
date: 2026-04-03
weight: 6
chapter: false
pre: " <b> 5.3.6. </b> "
---

## 1. Configure Google identity provider

- Open Amazon Cognito Console in region `us-east-1`.
- Open your user pool and go to `Social and external providers`.
- Click `Add identity provider`.
![Cognito social providers entry](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/google%20provider1.png)

- Select provider type `Google`.
- Enter your Google OAuth `Client ID` and `Client secret` from Google Cloud Console.
- Set authorized scopes: `openid email profile`.
- Save changes.

- Verify provider `Google` is present.
- Verify mappings include these key fields:
  - `email -> email`
  - `email_verified -> email_verified`
  - `name -> name`
  - `picture -> picture`
  - `username -> sub`
![Cognito Google provider details](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/google%20provider2.png)
![Cognito Google provider mappings](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/google%20provider3.png)

## 2. Create Cognito user pool and app client

- Open Amazon Cognito Console in region `us-east-1`.
- Open `User pools`.
- Click `Create user pool`.
![Cognito user pools entry](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%201.png)

- Select application type `Single-page application (SPA)`.
- Enter application name: `myfit cognito app client`.
- In sign-in identifiers, select `Email`.
![Cognito app setup basic](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%202.png)

- Keep `Enable self-registration` selected.
- Set required attributes to include `email`.
- Enter return URL: `https://myfit.click`.
- Click `Create user directory`.
![Cognito app setup and return URL](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%203.png)

## 3. Configure managed login pages

- Open your user pool, then open `App clients`.
- Select app client `Fitme-cognito-web-auth-service`.
- Open `Edit managed login pages configuration`.
![Cognito managed login callback URLs](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%204.png)

- Set `Allowed callback URLs`:
  - `http://localhost:8081/callback`
  - `https://myfit.click/callback`
  - `myfit://callback`
- Set `Default redirect URL`: `https://myfit.click/callback`.
- Set `Allowed sign-out URLs`:
  - `http://localhost:8081/logout`
  - `https://myfit.click/logout`
  - `myfit://logout`
- In identity providers, select `Google`.
- In OAuth 2.0 grant types, select `Authorization code grant`.
![Cognito managed login sign-out and OAuth flow](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%205.png)

- In OpenID Connect scopes, select:
  - `email`
  - `openid`
  - `profile`
- Click `Save changes`.
![Cognito managed login OIDC scopes](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%206.png)

## 4. Verify Route 53 hosted zone and records

> Notice:
> The workshop sample domain `myfit.click` is already registered by our team through MatBao and is shown only as a reference.
> For your own setup, use your own domain and DNS zone.
> If you want easier end-to-end setup, you can purchase a domain directly in Route 53 (for example, `myapp.com`) and use that domain in all steps.

- Open Route 53 Console - `Hosted zones`.
- Confirm hosted zone `myfit.click` exists and type is `Public`.
![Route 53 hosted zones](/images/workshop/Phase%206%20Authentication%20and%20DNS/route53%20dns/create%20hosted%20zone%201.png)

- Open hosted zone `myfit.click` - `Records`.
- Verify core records:
  - Alias `A` record for `myfit.click` points to CloudFront domain.
  - Alias `A` record for `api.myfit.click` points to ALB domain.
  - ACM validation `CNAME` records for `myfit.click` and `api.myfit.click` exist.
  - Default `NS` and `SOA` records exist.
![Route 53 records list](/images/workshop/Phase%206%20Authentication%20and%20DNS/route53%20dns/create%20hosted%20zone%202.png)

## 5. Phase completion checklist

1. Confirm Cognito user pool ID is `us-east-1_9AoKPqZO1`.
2. Confirm app client ID is `661fm3mj7s5qcmoldri1mem9sr`.
3. Confirm callback URLs include `http://localhost:8081/callback`, `https://myfit.click/callback`, and `myfit://callback`.
4. Confirm sign-out URLs include `http://localhost:8081/logout`, `https://myfit.click/logout`, and `myfit://logout`.
5. Confirm supported identity provider includes `Google`.
6. Confirm OAuth flow is `code` and scopes include `email`, `openid`, `profile`.
