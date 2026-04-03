---
title: "Infra Setup"
weight: 1
---

# Infra Setup

## Overview

This guide is a console-first walkthrough for recreating the MyFit infrastructure end to end.

It follows the current CDK stack in [lib/myfit-infra-stack.ts](lib/myfit-infra-stack.ts) and the deployment flow in [scripts/deploy-infra.ps1](scripts/deploy-infra.ps1).

The live stack currently exposes these reference values:

- Frontend URL: `https://myfit.click`
- Backend URL: `https://myfit.click`
- Hosted zone: `myfit.click`
- ECS cluster: `MyfitInfraStack-ClusterEB0386A7-6dZNgtqjJLJS`
- ECS service: `MyfitInfraStack-BackendService10C26BD4-niX7aNjE5IDi`

## Content

1. [Prerequisites](#prerequisites)
2. [IAM role and policies](1-iam-role-and-policies)
3. [Setup](2-setup)
4. [Testing and evaluating](3-testing-and-evaluating)
5. [Cleanup](4-cleanup)

## Prerequisites

1. Sign in to the AWS console in the same Region used by the stack, which defaults to `us-east-1`.
2. Confirm the Route 53 hosted zone for `myfit.click` exists before you start DNS and certificate steps.
3. Confirm the imported Cognito user pool ID and web client ID.
4. Confirm the Bedrock API key secret ARN if you plan to use the optional secret injection.
5. Use the AWS console search bar when service names differ slightly from the labels in this guide.

## Source of truth

- Infrastructure code: [lib/myfit-infra-stack.ts](lib/myfit-infra-stack.ts)
- Infra deployment script: [scripts/deploy-infra.ps1](scripts/deploy-infra.ps1)
- App deployment script: [scripts/deploy-app.ps1](scripts/deploy-app.ps1)
