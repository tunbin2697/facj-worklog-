---
title : "Configure Authentication and Routing"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.3.4. </b> "
---

Configure ALB listener rules so each path enforces the expected access model.

## Rules

1. Public route:
   - Path: `/`
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