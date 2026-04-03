---
title: "Phase 1 - VPC và Networking"
date: 2026-04-03
weight: 1
chapter: false
pre: " <b> 5.3.1. </b> "
---

## 1. Tạo VPC

- Chọn Resources to create: `VPC only`.
- Nhập Name tag: `<your-vpc-name>`.
- Nhập IPv4 CIDR: `10.0.0.0/16`.
- Đặt IPv6 CIDR: `No IPv6 CIDR block`.
- Đặt Tenancy: `Default`.

![Create VPC step](/images/workshop/phase1%20vpc%20and%20networking/create%20vpc/1.png)
![Create VPC step 2](/images/workshop/phase1%20vpc%20and%20networking/create%20vpc/2.png)
- Bật DNS hostnames.
- Bật DNS resolution.
- Bấm `Create VPC`.

- Vào mục Internet Gateway và tạo Internet Gateway.
- Gắn Internet Gateway vào `<your-vpc-name>`.

## 2. Tạo 4 subnet trên 2 AZ

![Create subnet step](/images/workshop/phase1%20vpc%20and%20networking/create%20subnet/1.png)
| Subnet           | Name                                    | AZ           | CIDR            |
| ---------------- | --------------------------------------- | ------------ | --------------- |
| Public Subnet 1  | `<your-public-subnet-1-name>`           | `us-east-1a` | `10.0.0.0/18`   |
| Public Subnet 2  | `<your-public-subnet-2-name>`           | `us-east-1b` | `10.0.64.0/18`  |
| Private Subnet 1 | `<your-private-isolated-subnet-1-name>` | `us-east-1a` | `10.0.128.0/18` |
| Private Subnet 2 | `<your-private-isolated-subnet-2-name>` | `us-east-1b` | `10.0.192.0/18` |

- Bật auto-assign public IPv4 cho 2 public subnet.
- Giữ auto-assign public IPv4 ở trạng thái tắt cho 2 isolated subnet.

![Subnet result](/images/workshop/phase1%20vpc%20and%20networking/create%20subnet/subnet%20result.png)

## 3. Cấu hình route tables

- Tạo public route table `<your-public-route-table-name>`.
- Nhập Route: `0.0.0.0/0` - `<your-internet-gateway-id>`.
- Associate public route table với subnet `10.0.0.0/18` và `10.0.64.0/18`.
- Tạo isolated route table `<your-isolated-route-table-name>`.
- Giữ chỉ local route `10.0.0.0/16` trong isolated route table.
- Associate isolated route table với subnet `10.0.128.0/18` và `10.0.192.0/18`.
![Route table result](/images/workshop/phase1%20vpc%20and%20networking/route%20table/route%20table%20result.png)

## 4. Tạo 3 security groups và kết nối luồng truy cập

### A. ALB Security Group

- Nhập Security group name: `<your-alb-security-group-name>`.
- Nhập Inbound rule: `HTTP`, port `80`, source `pl-3b927c52`. `pl-3b927c52` là public endpoint từ CloudFront, nghĩa là ALB chỉ cho phép inbound traffic từ CloudFront.
![ALB SG init](/images/workshop/phase1%20vpc%20and%20networking/security%20group/alb%20init%20with%20inbound.png)

### B. Backend Service Security Group
- Nhập Security group name: `<your-backend-service-security-group-name>`.
- Nhập Inbound rule: `Custom TCP`, port `8080`, source `<your-alb-security-group-id>`.
![ECS SG init](/images/workshop/phase1%20vpc%20and%20networking/security%20group/ecs%20init%20with%20inbound.png)

### C. Database Security Group
- Nhập Security group name: `<your-database-security-group-name>`.
- Nhập Inbound rule: `PostgreSQL`, port `5432`, source `<your-backend-service-security-group-id>`.
![DB SG init](/images/workshop/phase1%20vpc%20and%20networking/security%20group/db%20init%20with%20inbound.png)

### Chỉnh outbound rules

- Chỉnh outbound rules của `<your-alb-security-group-name>`.
- Nhập Outbound rule: `Custom TCP`, port `8080`, destination `<your-backend-service-security-group-id>`.
![Edit outbound ALB-ECS](/images/workshop/phase1%20vpc%20and%20networking/security%20group/edit%20outbound%20from%20alb%20to%20ecs.png)

- Giữ outbound rule của backend và database security groups là `All traffic`.
![Security group result](/images/workshop/phase1%20vpc%20and%20networking/security%20group/sg%20result.png)

## 5. Checklist hoàn tất phase

1. Xác nhận VPC CIDR là `10.0.0.0/16`.
2. Xác nhận 4 subnet dùng đúng giá trị CIDR/AZ như mục 2.
3. Xác nhận public route table có `0.0.0.0/0 - <your-internet-gateway-id>`.
4. Xác nhận isolated route table không có internet route.
5. Xác nhận security group rules đúng như sau: CloudFront - ALB (`80`), ALB - backend (`8080`), backend - database (`5432`).

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

