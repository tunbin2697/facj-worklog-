---
title: "Phase 1 - VPC and Networking"
date: 2026-04-03
weight: 1
chapter: false
pre: " <b> 5.3.1. </b> "
---

## 1. Create VPC

- Select Resources to create: `VPC only`.
- Enter Name tag: `<your-vpc-name>`.
- Enter IPv4 CIDR: `10.0.0.0/16`.
- Set IPv6 CIDR: `No IPv6 CIDR block`.
- Set Tenancy: `Default`.

![Create VPC step](/images/workshop/phase1%20vpc%20and%20networking/create%20vpc/1.png)
![Create VPC step 2](/images/workshop/phase1%20vpc%20and%20networking/create%20vpc/2.png)
- Enable DNS hostnames.
- Enable DNS resolution.
- Click `Create VPC`.

- Go to Internet Gateway section and create an Internet Gateway.
- Attach the Internet Gateway to `<your-vpc-name>`.




## 2. Create 4 subnets across 2 AZs

![Create subnet step](/images/workshop/phase1%20vpc%20and%20networking/create%20subnet/1.png)
| Subnet           | Name                                    | AZ           | CIDR            |
| ---------------- | --------------------------------------- | ------------ | --------------- |
| Public Subnet 1  | `<your-public-subnet-1-name>`           | `us-east-1a` | `10.0.0.0/18`   |
| Public Subnet 2  | `<your-public-subnet-2-name>`           | `us-east-1b` | `10.0.64.0/18`  |
| Private Subnet 1 | `<your-private-isolated-subnet-1-name>` | `us-east-1a` | `10.0.128.0/18` |
| Private Subnet 2 | `<your-private-isolated-subnet-2-name>` | `us-east-1b` | `10.0.192.0/18` |


- Enable auto-assign public IPv4 for the 2 public subnets.
- Keep auto-assign public IPv4 disabled for the 2 isolated subnets.

![Subnet result](/images/workshop/phase1%20vpc%20and%20networking/create%20subnet/subnet%20result.png)

## 3. Configure route tables

- Create public route table `<your-public-route-table-name>`.
- Enter Route: `0.0.0.0/0` - `<your-internet-gateway-id>`.
- Associate public route table with `10.0.0.0/18` and `10.0.64.0/18` subnets.
- Create isolated route table `<your-isolated-route-table-name>`.
- Keep only local route `10.0.0.0/16` in isolated route table.
- Associate isolated route table with `10.0.128.0/18` and `10.0.192.0/18` subnets.
![Route table result](/images/workshop/phase1%20vpc%20and%20networking/route%20table/route%20table%20result.png)

## 4. Create 3 security groups and connect traffic flow

### A. ALB Security Group

- Enter Security group name: `<your-alb-security-group-name>`.
- Enter Inbound rule: `HTTP`, port `80`, source `pl-3b927c52`. pl-3b927c52 is public endpoint from CloudFront, this mean alb only allow inboud traffic from cloudfront.
![ALB SG init](/images/workshop/phase1%20vpc%20and%20networking/security%20group/alb%20init%20with%20inbound.png)

### B. Backend Service Security Group
- Enter Security group name: `<your-backend-service-security-group-name>`.
- Enter Inbound rule: `Custom TCP`, port `8080`, source `<your-alb-security-group-id>`.
![ECS SG init](/images/workshop/phase1%20vpc%20and%20networking/security%20group/ecs%20init%20with%20inbound.png)

### C. Database Security Group
- Enter Security group name: `<your-database-security-group-name>`.
- Enter Inbound rule: `PostgreSQL`, port `5432`, source `<your-backend-service-security-group-id>`.
![DB SG init](/images/workshop/phase1%20vpc%20and%20networking/security%20group/db%20init%20with%20inbound.png)


### Edit outbound rules

- Edit outbound rules of `<your-alb-security-group-name>`.
- Enter Outbound rule: `Custom TCP`, port `8080`, destination `<your-backend-service-security-group-id>`.
![Edit outbound ALB-ECS](/images/workshop/phase1%20vpc%20and%20networking/security%20group/edit%20outbound%20from%20alb%20to%20ecs.png)

- Keep outbound rule of backend and database security groups as `All traffic`.
![Security group result](/images/workshop/phase1%20vpc%20and%20networking/security%20group/sg%20result.png)

## 5. Phase completion checklist

1. Confirm VPC CIDR is `10.0.0.0/16`.
2. Confirm 4 subnets use exact CIDR/AZ values from section 2.
3. Confirm public route table has `0.0.0.0/0 - <your-internet-gateway-id>`.
4. Confirm isolated route table has no internet route.
5. Confirm security group rules are exactly: CloudFront - ALB (`80`), ALB - backend (`8080`), backend - database (`5432`).

- VPC CIDR: `10.0.0.0/16`
- DNS hostnames: `true`
- DNS support: `true`
- Public subnet 1 CIDR/AZ: `10.0.0.0/18` in `us-east-1a`
- Public subnet 2 CIDR/AZ: `10.0.64.0/18` in `us-east-1b`
- Isolated subnet 1 CIDR/AZ: `10.0.128.0/18` in `us-east-1a`
- Isolated subnet 2 CIDR/AZ: `10.0.192.0/18` in `us-east-1b`
- Public route: `0.0.0.0/0 - <your-internet-gateway-id>`
- Isolated routes: keep local route only
- ALB security group inbound source: CloudFront prefix list `pl-3b927c52`
- ALB to backend port: `8080`
- Backend to database port: `5432`

![VPC created result](/images/workshop/phase1%20vpc%20and%20networking/create%20vpc/vcp%20result.png)