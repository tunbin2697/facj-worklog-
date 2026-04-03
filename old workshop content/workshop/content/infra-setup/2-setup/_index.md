---
title: "2. Setup"
weight: 20
---

# 2. Setup

This chapter builds the infrastructure in the same order the stack expects it to exist.

## Content

1. VPC and networking
2. RDS PostgreSQL
3. ECR repository
4. ECS cluster, task definition, and service
5. S3 and CloudFront
6. Route 53 and ACM
7. Cognito and Secrets Manager

## 2.1 Stack values to reuse

- Domain: `myfit.click`
- API subdomain: `api.myfit.click`
- Backend repository: `myfit-backend`
- Media bucket name: `crawl.fitness`
- Database name: `myfit`
- Default region: `us-east-1`
- Live ECS cluster name: `MyfitInfraStack-ClusterEB0386A7-6dZNgtqjJLJS`
- Live ECS service name: `MyfitInfraStack-BackendService10C26BD4-niX7aNjE5IDi`
- Live frontend bucket name: `myfitinfrastack-frontendbucketefe2e19c-qjcbf75eyxbx`

## 2.2 Navigation

1. [VPC and networking](2-1-vpc-and-networking)
2. [RDS PostgreSQL](2-2-rds-postgresql)
3. [ECR repository](2-3-ecr-repository)
4. [ECS cluster, task definition, and service](2-4-ecs-cluster-task-definition-and-service)
5. [S3 and CloudFront](2-5-s3-and-cloudfront)
6. [Route 53 and ACM](2-6-route53-and-acm)
7. [Cognito and Secrets Manager](2-7-cognito-and-secrets-manager)

## 2.3 Console approach

The console steps below mirror the resources created by the CDK stack. Some parts are easier to create with CloudFormation, but the pages below keep the walkthrough console-first for course delivery.
