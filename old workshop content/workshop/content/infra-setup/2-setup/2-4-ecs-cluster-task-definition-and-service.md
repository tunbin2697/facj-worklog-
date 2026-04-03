---
title: "2.4 ECS cluster, task definition, and service"
weight: 24
---

# 2.4 ECS cluster, task definition, and service

This is the core runtime layer. The stack uses a Fargate service behind an application load balancer.

## Content

1. Create the ECS cluster
2. Create the task definition
3. Create the service
4. Configure the load balancer
5. Scaling and health checks
6. What the stack does differently from the console default

## 2.4.1 Create the ECS cluster

1. Open the ECS console.
2. Choose Clusters and then Create cluster.
3. Select AWS Fargate as the infrastructure option.
4. Set the cluster name to a descriptive value such as `MyfitInfraStack-Cluster`.
5. Add a description such as `MyFit backend cluster`.
6. Enable Container Insights.
7. Attach the cluster to the VPC you created earlier.
8. Create the cluster.

## 2.4.2 Create the task definition

1. Go to Task definitions and choose Create new task definition.
2. Select Fargate.
3. Set CPU to 256.
4. Set Memory to 512 MiB.
5. Set the task role to the application task role.
6. Set the task execution role to the execution role.
7. Give the task definition family a service-specific name such as `myfit-backend`.

### 2.4.2.1 Add the container

1. Name the container `backend` or match your application convention.
2. Use the image URI from ECR with the `latest` tag.
3. Set the container port to 8080.
4. Add the log driver for CloudWatch Logs.
5. Use a stream prefix like `backend`.
6. Add a description in the task definition note field if the console provides one.

### 2.4.2.2 Add environment variables

Set these values to match the stack:

- `DB_URL=jdbc:postgresql://<db-endpoint>:5432/myfit?ssl=true&sslmode=require`
- `SPRING_PROFILES_ACTIVE=prod`
- `CORS_ALLOWED_ORIGINS=https://myfit.click,https://*.cloudfront.net,http://localhost:8081,http://localhost:19006`
- `AWS_REGION=us-east-1`
- `S3_BUCKET_NAME=crawl.fitness`
- `COGNITO_USER_POOL_ID=<existing-user-pool-id>`
- `COGNITO_ISSUER_URI=https://cognito-idp.us-east-1.amazonaws.com/<existing-user-pool-id>`

### 2.4.2.3 Add secrets

Add these secrets when available:

- `DB_USERNAME` from the RDS secret username
- `DB_PASSWORD` from the RDS secret password
- `BEDROCK_API_KEY` from the optional Bedrock API key secret

## 2.4.3 Create the service

1. Create a new service from the task definition.
2. Use Fargate launch type.
3. Set desired tasks to 2.
4. Place the service in the public subnets.
5. Enable public IP assignment.
6. Attach the backend service security group.
7. Connect it to an application load balancer.
8. Name the service using a clear service name such as the live stack service `MyfitInfraStack-BackendService10C26BD4-niX7aNjE5IDi` if you are recreating the deployed resource naming pattern.

## 2.4.4 Configure the load balancer

1. Create an application load balancer in the same VPC.
2. Use port 80 for the listener.
3. Attach the ALB security group that only allows CloudFront traffic.
4. Create a target group for port 8080.
5. Set the health check path to `/test/health`.
6. Set healthy HTTP codes to `200-399`.
7. Use the load balancer name or description to clearly identify it as the backend entry point.

## 2.4.5 Scaling and health checks

1. Enable auto scaling on the service.
2. Use CPU target tracking.
3. Set the target utilization to 70 percent.
4. Set scale-in and scale-out cooldowns to 60 seconds.
5. Set the health check grace period to 180 seconds.
6. Confirm the service launches at least 2 tasks.

## 2.4.6 What the stack does differently from the console default

- It does not expose the ALB to the internet directly.
- It expects CloudFront to be the public entry point.
- It runs ECS tasks with public IPs so they can reach managed AWS services without NAT.
