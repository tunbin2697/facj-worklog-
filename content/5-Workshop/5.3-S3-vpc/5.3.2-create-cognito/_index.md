---
title : "Create Cognito User Pool"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.3.2. </b> "
---

Create Cognito resources for login and group-based authorization.

## Steps

1. Open Amazon Cognito -> User pools -> Create user pool.
2. Choose sign-in option (email or username).
3. Create an App client:
	- Do not generate client secret.
	- Configure callback URL: `https://<alb-dns>/oauth2/idpresponse`.
	- Configure sign-out URL: `https://<alb-dns>`.
4. Configure Hosted UI domain.
5. Create test users:
	- `user1` (standard user)
	- `admin1` (admin user)
6. Create group `admin` and add `admin1`.

## Output to Save

- User Pool ID
- App Client ID
- Hosted UI Domain

These values will be used in the ALB authentication rule.













