---
title: "3. Testing and evaluating"
weight: 30
---

# 3. Testing and evaluating

Use this chapter to prove the stack is healthy after the manual or CDK deployment.

## Content

1. Console checks
2. Browser tests
3. What to evaluate in class

## 3.1 Console checks

### 3.1.1 CloudFormation

1. Open CloudFormation.
2. Confirm the stack status is `CREATE_COMPLETE` or `UPDATE_COMPLETE`.
3. Open the Events tab if anything failed.

### 3.1.2 ECS

1. Open ECS.
2. Confirm the cluster `MyfitInfraStack-ClusterEB0386A7-6dZNgtqjJLJS` is visible.
3. Confirm the service `MyfitInfraStack-BackendService10C26BD4-niX7aNjE5IDi` is running the desired number of tasks.
4. Open the Tasks tab and confirm tasks are healthy.

### 3.1.3 Load balancer and target group

1. Open EC2 and go to Target Groups.
2. Confirm the health check path is `/test/health`.
3. Confirm targets are healthy.
4. Open the ALB details page and confirm the DNS name resolves in a browser.

### 3.1.4 RDS

1. Open RDS.
2. Confirm the database is Available.
3. Confirm the endpoint matches the value used by ECS.

### 3.1.5 CloudFront and S3

1. Open CloudFront.
2. Confirm the distribution status is Deployed.
3. Open the S3 bucket and confirm the frontend build artifacts are present.

## 3.2 Browser tests

1. Open `https://myfit.click`.
2. Confirm the SPA loads and routes correctly.
3. Open `https://api.myfit.click/test/health`.
4. Confirm the backend health endpoint returns a success response.
5. Verify login, API calls, and static asset loading from the deployed domain.
6. Confirm the frontend bundle calls the backend through the public domain, not localhost.

## 3.3 What to evaluate in class

- The student can identify each AWS service in the console.
- The student can explain why the database is private.
- The student can explain why CloudFront is the public entry point.
- The student can trace the request path from browser to CloudFront to ALB to ECS.
