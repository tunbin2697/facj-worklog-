---
title: "Workshop Overview"
date: 2026-04-03
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---

## 5.1 Cloud-Native Fitness App Deployment on AWS

This workshop guides you through deploying and validating Cloud-Native Fitness App Deployment on AWS.

## Project overview

MyFit is a cloud-native fitness platform for health tracking, workout planning, nutrition logging, and AI-assisted coaching.
The system includes:

1. Frontend application for user interaction and progress tracking.
2. Backend API for business logic and secure data processing.
3. AWS infrastructure for managed deployment, scaling, and monitoring.

## How this project is deployed on AWS

Deployment follows a container-based CI/CD flow:

1. Developer pushes source code to GitHub.
2. GitHub Actions builds backend container image.
3. Image is pushed to Amazon ECR.
4. Amazon ECS Fargate service is updated with rolling deployment.
5. Traffic is routed through CloudFront to S3 (frontend) and ALB/ECS (API).

## Architecture diagram

![System Architecture](/images/2-Proposal/image11.png)

## AWS service selection

| Service | Why it is used |
| --- | --- |
| CloudFront | Low-latency global delivery and unified public entry point |
| S3 | Static frontend hosting and media storage |
| ALB | HTTP/HTTPS load balancing to ECS services |
| ECS Fargate | Managed container runtime with auto scaling |
| RDS PostgreSQL | Managed relational database for transactional data |
| Cognito | Authentication and identity management |
| ECR | Container image registry |
| CloudWatch | Centralized logging and monitoring |
| Route 53 + ACM | DNS and TLS certificate management |
| Secrets Manager | Secure secret storage for runtime configuration |

## Goal

Build a production-style stack with:

1. VPC and networking foundation
2. PostgreSQL database on RDS
3. Containerized backend on ECS Fargate
4. Frontend on S3 + CloudFront
5. Authentication with Cognito
6. Bedrock API integration through Secrets Manager

## Architecture summary

1. Frontend traffic goes to CloudFront and S3.
2. API traffic goes from CloudFront to ALB and ECS service.
3. ECS backend connects to RDS and S3.
4. Cognito is used for authentication.
5. Optional Bedrock key is injected from Secrets Manager.

## Workshop structure

1. [5.2 Prerequisite - IAM roles and policy baseline](../5.2-prerequiste/)
2. [5.3 Phase-based step-by-step](../5.3-step-by-step/)
3. [5.4 App Result](../5.4-app-result/)
4. [5.5 CloudFormation Deploy with CDK and Script](../5.5-cloudformation-deploy-cdk-and-script/)
5. [5.6 Clean Up Resource](../5.6-clean-up-resource/)

## Source of truth

- Infrastructure stack code: [myfit-infra/lib/myfit-infra-stack.ts (included in 5.5)](../5.5-cloudformation-deploy-cdk-and-script/)
- Infra deployment script: [myfit-infra/scripts/deploy-infra.ps1 (included in 5.5)](../5.5-cloudformation-deploy-cdk-and-script/)
