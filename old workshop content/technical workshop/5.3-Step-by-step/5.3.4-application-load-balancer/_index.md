---
title : "Create Application Load Balancer and Target Group"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.3.4. </b> "
---

Create the ALB and target group that route traffic to the EC2 backend.

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

The ALB creation wizard also creates the default listener rule that forwards traffic to the target group. That is the only listener setup covered in this step; the application-specific listener rules for `/`, `/health`, `/dashboard`, and `/admin` are configured in the next section.

## Target group screenshots

The target group is the backend destination for the ALB. It also defines the health check that tells AWS whether the EC2 instance is ready to receive traffic, so create and verify it before moving on to the load balancer listener configuration.

![Target group step 1](/images/5-Workshop/workshop-resource/target%20group/1.png)

![Target group step 2](/images/5-Workshop/workshop-resource/target%20group/2.png)

![Target group step 3](/images/5-Workshop/workshop-resource/target%20group/3.png)

![Target group step 4](/images/5-Workshop/workshop-resource/target%20group/4.png)

![Target group step 5](/images/5-Workshop/workshop-resource/target%20group/5.png)

![Target group step 6](/images/5-Workshop/workshop-resource/target%20group/6.png)

![Target group step 7](/images/5-Workshop/workshop-resource/target%20group/7.png)

## ALB screenshots

![ALB step 1](/images/5-Workshop/workshop-resource/alb/1.png)

![ALB step 2](/images/5-Workshop/workshop-resource/alb/2.png)

![ALB step 3](/images/5-Workshop/workshop-resource/alb/3.png)

![ALB step 4](/images/5-Workshop/workshop-resource/alb/4.png)

![ALB step 5](/images/5-Workshop/workshop-resource/alb/5.png)

![ALB step 6](/images/5-Workshop/workshop-resource/alb/6.png)

![ALB step 7](/images/5-Workshop/workshop-resource/alb/7.png)

![ALB step 8](/images/5-Workshop/workshop-resource/alb/8.png)

![ALB step 9](/images/5-Workshop/workshop-resource/alb/9.png)

![ALB step 10](/images/5-Workshop/workshop-resource/alb/10.png)