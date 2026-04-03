---
title : "Test and Evaluate Results"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

# 5.4 Test and Evaluate Results

This page contains step-by-step verification, test cases, and troubleshooting notes to validate the workshop deployment (ALB + Cognito + EC2) implemented in section 5.3.

Save these artifacts for troubleshooting and downstream steps:
- ALB DNS name (ALB DNS)
- Target Group name
- EC2 instance id
- Cognito User Pool id
- Cognito App Client id
- Cognito domain

## Test cases & expected results

- Public path `/`
  - Open `http://<alb-dns>/`
  - Expected: HTTP 200, response body `Public`

- Protected path `/dashboard`
  - Open `http://<alb-dns>/dashboard`
  - Expected: redirect to Cognito Hosted UI; after successful login, HTTP 200 and backend returns user identity

- Admin path `/admin`
  - Open `http://<alb-dns>/admin`
  - Expected: redirect when unauthenticated; standard user denied access; admin user allowed (backend enforces group check)

## Verification checklist

1. ALB listener rules
   - Default action for `/` forwards to Target Group (no auth).
   - Rule for `/dashboard` uses `authenticate-cognito` then forwards.
   - Rule for `/admin` uses `authenticate-cognito` then forwards.

2. Cognito configuration
   - User Pool exists and App Client created (no client secret for browser flow).
   - App Client callback/redirect URLs configured correctly.
   - Cognito domain (hosted or custom) configured.

3. Backend & Target Group
   - EC2 instance running and registered in Target Group.
   - Health checks are passing.
   - Backend reads identity headers `x-amzn-oidc-identity` (or other OIDC headers) injected by ALB.

4. Security groups
   - ALB SG allowed to reach EC2 SG on application port (eg. 80).

## Quick smoke tests (replace `<alb-dns>`)

```bash
curl -i http://<alb-dns>/
curl -i http://<alb-dns>/dashboard
curl -i http://<alb-dns>/admin
```

Use a browser to validate the full Cognito Hosted UI redirect flow and token exchange.

## Troubleshooting

- Not redirected to Cognito: verify listener rule action uses `authenticate-cognito` and Cognito app client/domain are correct.
- Backend shows `Guest` or no identity: ensure ALB listener forwards OIDC headers and the backend reads `x-amzn-oidc-identity`.
- Health checks failing: confirm application is listening on expected port and security groups allow ALB -> EC2 traffic.

## Result screenshots

![Guest route](/images/5-Workshop/workshop-resource/result/guest.png)

![Unauthenticated redirect](/images/5-Workshop/workshop-resource/result/unauth-to-login.gif)

![Health check](/images/5-Workshop/workshop-resource/result/health.png)

![Admin route](/images/5-Workshop/workshop-resource/result/admin.png)

## Monitoring & logs

- EC2 application logs (CloudWatch) — configure CloudWatch Agent or stream application logs.
- ALB access logs (enable to S3) for request-level auditing.
- Cognito logs (CloudWatch) for authentication troubleshooting.

## Cleanup

After validation, remove resources using [5.5 Clean-up](../5.5-cleanup/).
