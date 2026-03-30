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

## Screenshot guide

![Cognito step 1](/images/5-Workshop/workshop-resource/cognito/1.png)

![Cognito step 2](/images/5-Workshop/workshop-resource/cognito/2.png)

![Cognito step 3](/images/5-Workshop/workshop-resource/cognito/3.png)

![Cognito step 4](/images/5-Workshop/workshop-resource/cognito/4.png)

![Cognito step 5](/images/5-Workshop/workshop-resource/cognito/5.png)

![Cognito step 6](/images/5-Workshop/workshop-resource/cognito/6.png)

![Cognito step 7](/images/5-Workshop/workshop-resource/cognito/7.png)

![Cognito step 8](/images/5-Workshop/workshop-resource/cognito/8.png)

![Cognito step 9](/images/5-Workshop/workshop-resource/cognito/9.png)

### Add admin user to the group

![Add admin user 1](/images/5-Workshop/workshop-resource/result/add%20admin%20user%201.png)

![Add admin user 2](/images/5-Workshop/workshop-resource/result/add%20admin%20user%202.png)

![Add admin user 3](/images/5-Workshop/workshop-resource/result/add%20admin%20user%203.png)













