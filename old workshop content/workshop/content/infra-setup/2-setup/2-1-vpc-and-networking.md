---
title: "2.1 VPC and networking"
weight: 21
---

# 2.1 VPC and networking

The stack creates a VPC with public and isolated private subnets. ECS tasks run in public subnets with public IPs, while the database stays in isolated private subnets.

## Content

1. Create the VPC
2. Create security groups
3. What the stack expects

## 2.1.1 Create the VPC

1. Open the VPC console.
2. In the left navigation, choose Your VPCs if you want to confirm the current state first.
3. Choose Create VPC.
4. Select VPC and more.
5. Set Name tag auto-generation to `MyfitVPC` or another descriptive value.
6. Set IPv4 CIDR block to the default unless you have an IP plan that requires a custom range.
7. Set the number of Availability Zones to 2.
8. Set public subnets to 2.
9. Set private subnets to 2.
10. Set NAT gateways to 0.
11. Select isolated private subnets for the data tier.
12. Enable DNS resolution.
13. Enable DNS hostnames.
14. Create the VPC.

## 2.1.2 Create security groups

### 2.1.2.1 Database security group

1. Open the EC2 console and choose Security Groups.
2. Choose Create security group.
3. Set the name to `MyfitDbSecurityGroup`.
4. Add a description such as `RDS PostgreSQL access for MyFit backend`.
5. Select the VPC you created.
6. Leave inbound rules empty until the ECS service security group exists.
7. Create the security group.

### 2.1.2.2 ECS service security group

1. Create a security group for the backend service.
2. Use a name like `MyfitBackendServiceSG`.
3. Add a description such as `Backend ECS tasks for MyFit`.
4. Allow inbound on port 8080 only from the ALB security group.
5. Allow outbound to the database on port 5432.

### 2.1.2.3 ALB security group

1. Create a security group for the application load balancer.
2. Use a name like `MyfitAlbSG`.
3. Add a description such as `CloudFront-only public entry point for MyFit`.
4. Allow inbound on port 80 from the CloudFront managed prefix list `pl-3b927c52`.
5. Do not open the ALB to `0.0.0.0/0`.

## 2.1.3 What the stack expects

- Public subnets for ALB and ECS tasks.
- Isolated private subnets for RDS.
- No NAT gateway.
- Security group flow: CloudFront to ALB, ALB to ECS, ECS to RDS.
