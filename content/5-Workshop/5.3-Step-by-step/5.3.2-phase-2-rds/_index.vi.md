---
title: "Phase 2 - RDS"
date: 2026-04-03
weight: 2
chapter: false
pre: " <b> 5.3.2. </b> "
---

## 1. Tạo DB subnet group

- Mở RDS Console - `Subnet groups` - `Create DB subnet group`.
![DB subnet group screen 1](/images/workshop/phase%202%20rds/create%20subnet%20group/subnet%20group%201.png)

- Nhập Name: `<your-db-subnet-group-name>`.
- Nhập Description: `<your-db-subnet-group-description>`.
- Chọn VPC: `your-vpc-id`.
- Chọn 2 AZ có 2 isolated subnet.
- Chọn 2 isolated subnet: `your-isolated-subnet-1-id` và `your-isolated-subnet-2-id`.
![DB subnet group screen 2](/images/workshop/phase%202%20rds/create%20subnet%20group/subnet%20group%202.png)

## 2. Tạo PostgreSQL RDS instance

- Mở RDS Console - `Databases` - `Create database`.
![Create RDS screen 1](/images/workshop/phase%202%20rds/create%20rds/create%20rds1.png)

- Chọn Engine type: `PostgreSQL`.
- Chọn Full Configuration.
![Create RDS screen 2](/images/workshop/phase%202%20rds/create%20rds/create%20rds2.png)

- Chọn `Multi AZ 2 instance`.
![Create RDS screen 3](/images/workshop/phase%202%20rds/create%20rds/create%20rds%203.png)

- Chọn VPC và Subnet group ID.
![DB subnet group screen 3](/images/workshop/phase%202%20rds/create%20subnet%20group/subnet%20group%203.png)

- Chọn VPC security group: `<your-database-security-group-id>`.
![DB subnet group screen 4](/images/workshop/phase%202%20rds/create%20subnet%20group/subnet%20group%204.png)

- Chọn Engine version: `15.14`.
- Nhập DB instance identifier: `<your-db-instance-identifier>`.
- Nhập Master username: `postgres`.
![Create RDS screen 4](/images/workshop/phase%202%20rds/create%20rds/create%20rds%204.png)

- Bấm `Manage in AWS Secret Manager`.
![Create RDS screen 5](/images/workshop/phase%202%20rds/create%20rds/create%20rds%205.png)

- Chọn DB instance class: `db.t4g.micro`.
![Create RDS screen 6](/images/workshop/phase%202%20rds/create%20rds/create%20rds%206.png)

- Chọn Storage type: `gp3`.
- Nhập Allocated storage: `20` GB.
- Bật Storage autoscaling: `Yes`.
- Nhập Maximum storage threshold: `50` GB.
![Create RDS storage settings](/images/workshop/fix-img-ver-01/rds/rds%20storage%20fix.png)

![Create RDS autoscaling threshold](/images/workshop/fix-img-ver-01/rds/rds%20storage%20fix%20for%20scaling.png)

- Nhập Initial database name: `myfit`.

- Nhập Backup retention period: `7` days.
- Giữ `Enable automated backup`: `enabled`.
- Giữ `Database Insights`: `Standard`.
- Giữ `Performance Insights`: `disabled`.
- Giữ `Enhanced Monitoring`: `disabled`.
- Bật CloudWatch logs export: `postgresql`.

![Create RDS database name and backup](/images/workshop/fix-img-ver-01/rds/fix%20rds%20database%20init%20name.png)

![Create RDS monitoring options](/images/workshop/fix-img-ver-01/rds/fix%20rds%20monitoring.png)

- Giữ `Enable replication in another AWS Region`: `disabled`.
- Giữ `Enable encryption`: `disabled`.
- Giữ `Enable deletion protection`: `enabled`.

![Create RDS backup, encryption, and maintenance](/images/workshop/fix-img-ver-01/rds/fix%20rds%20back%20up%20disable%20replication%20encrypt.png)

- Bấm `Create database`.

![Create database final step](/images/workshop/fix-img-ver-01/rds/fix%20rds%20final%20pricing%20and%20create.png)

- Chờ đến khi DB instance status là `available`.
![RDS result screen 1](/images/workshop/phase%202%20rds/create%20rds/rds%20result.png)

- Sao chép Endpoint address: `<your-rds-endpoint>`.
- Xác nhận Port: `5432`.
![RDS result endpoint and port](/images/workshop/fix-img-ver-01/rds/fix%20rds%20result%20endpoint.png)

## 3. Kiểm tra database secret trong Secrets Manager (tự động tạo)

1. Mở Secrets Manager Console.
2. Lưu secret và sao chép ARN: `<your-rds-secret-arn>`.

## 4. Checklist hoàn tất phase

1. Xác nhận DB subnet group là `Complete` và chỉ có 2 isolated subnet.
2. Xác nhận DB instance status là `available`.
3. Xác nhận Engine/Class/Multi-AZ là `postgres 15.14`, `db.t4g.micro`, `true`.
4. Xác nhận storage là `gp3`, `20` GB, autoscaling `50` GB.
5. Xác nhận Public access là `false`, port là `5432`.
6. Xác nhận Backup retention là `7` days và CloudWatch logs export có `postgresql`.
7. Xác nhận đã lưu secret ARN để dùng ở phase sau.
