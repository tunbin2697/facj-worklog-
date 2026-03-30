---
title : "Workshop Overview"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---

This workshop demonstrates a secure web application pattern on AWS:
- Amazon EC2 hosts the backend.
- Amazon Cognito handles user authentication.
- Application Load Balancer (ALB) enforces access rules.

The target behavior:
- `/` is public.
- `/dashboard` requires login.
- `/admin` requires authenticated admin access.

{{% notice info %}}
This page is intentionally short. Use the table of contents below to open each section.
{{% /notice %}}

## Table of Contents

1. [5.2 Prerequisites](../5.2-prerequiste/)
2. [5.3 Step-by-step](../5.3-step-by-step/)
3. [5.4 Test and Evaluate Results](../5.4-test-evaluate/)
4. [5.5 Clean-up](../5.5-cleanup/)

## Architecture Summary

1. User requests the ALB endpoint.
2. ALB checks path-based rules.
3. Protected paths are redirected to Cognito Hosted UI.
4. After login, ALB forwards requests to EC2 with identity headers.

![Workshop architecture diagram](/images/5-Workshop/workshop-resource/diagram/aws%20architecture%20diagram%20workshop.png)

![Private EC2 architecture diagram](/images/5-Workshop/workshop-resource/diagram/private%20ec2%20-%20aws%20architeture%20diagram%20workshop%20.png)