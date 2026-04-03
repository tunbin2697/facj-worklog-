---
title : "Configure Authentication and Routing"
date : 2024-01-01
weight : 5
chapter : false
pre : " <b> 5.3.5. </b> "
---

Configure ALB listener rules so each path enforces the expected access model.

This step configures the application-specific listener rules. The ALB wizard already created the default forward-to-target-group rule in step 5.3.4; here we add the routing behavior for the application paths.

## Rules

1. Public routes:
   - Path: `/`
   - Path: `/health`
   - Action: Forward to target group
2. Authenticated route:
   - Path: `/dashboard`
   - Action: Authenticate with Cognito, then forward
3. Admin route:
   - Path: `/admin`
   - Action: Authenticate with Cognito, then forward
   - Backend must validate admin claims/group before allowing access

## Cognito Inputs in ALB

Use values from step 5.3.2:
- User Pool
- App Client
- Hosted UI domain

## Validation

- Access `/` without login should work.
- Access `/dashboard` should redirect to Cognito login.
- Access `/admin` with non-admin user should be denied by backend policy.

## Listener rule screenshot

![ALB auth step 11](/images/5-Workshop/workshop-resource/alb/11.png)

The `/` and `/health` routes are simple forwards to the target group. The `/dashboard` and `/admin` routes use Cognito authentication before forwarding, so only signed-in users can reach them.