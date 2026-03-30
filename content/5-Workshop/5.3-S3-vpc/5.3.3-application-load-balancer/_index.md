---
title : "Create Application Load Balancer"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3.3. </b> "
---

Create ALB and target group to route traffic to the EC2 backend.

## Steps

1. Open EC2 -> Load Balancers -> Create Load Balancer -> Application Load Balancer.
2. Choose `Internet-facing`.
3. Select VPC and at least 2 public subnets.
4. Create/select ALB security group:
   - Inbound HTTP/HTTPS from users.
5. Create target group:
   - Target type: Instance
   - Protocol/Port: HTTP:80
   - Register your EC2 backend instance.
6. Attach target group to ALB listener.

## Output to Save

- ALB DNS name
- Target Group name

These values are required for the next configuration step.