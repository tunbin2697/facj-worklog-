---
title: "Phase 2 - RDS"
date: 2026-04-03
weight: 2
chapter: false
pre: " <b> 5.3.2. </b> "
---

## 1. Create DB subnet group

- Open RDS Console - `Subnet groups` - `Create DB subnet group`.
![DB subnet group screen 1](/images/workshop/phase%202%20rds/create%20subnet%20group/subnet%20group%201.png)

- Enter Name: `<your-db-subnet-group-name>`.
- Enter Description: `<your-db-subnet-group-description>`.
- Select VPC: `your-vpc-id`.
- Select 2 Az that have 2 isolated subnet.
- Seclect 2 isolated subnet: `your-isolated-subnet-1-id` and `your-isolated-subnet-2-id`.

![DB subnet group screen 2](/images/workshop/phase%202%20rds/create%20subnet%20group/subnet%20group%202.png)


## 2. Create PostgreSQL RDS instance

- Open RDS Console - `Databases` - `Create database`.
![Create RDS screen 1](/images/workshop/phase%202%20rds/create%20rds/create%20rds1.png)

- Select Engine type: `PostgreSQL`.
- Select Full Configuration.
![Create RDS screen 2](/images/workshop/phase%202%20rds/create%20rds/create%20rds2.png)

- Pick `Multi AZ 2 instance`.
![Create RDS screen 3](/images/workshop/phase%202%20rds/create%20rds/create%20rds%203.png)

- Select VPC and Subnetgroup id.
![DB subnet group screen 3](/images/workshop/phase%202%20rds/create%20subnet%20group/subnet%20group%203.png)

- Select Vpc security group: `<your-database-security-group-id>`.
![DB subnet group screen 4](/images/workshop/phase%202%20rds/create%20subnet%20group/subnet%20group%204.png)

- Select Engine version: `15.14`.
- Enter DB instance identifier: `<your-db-instance-identifier>`.
- Enter Master username: `postgres`.
![Create RDS screen 4](/images/workshop/phase%202%20rds/create%20rds/create%20rds%204.png)


- Click `Manage in AWS Secret Manager`
![Create RDS screen 5](/images/workshop/phase%202%20rds/create%20rds/create%20rds%205.png)

- Select DB instance class: `db.t4g.micro`.
![Create RDS screen 6](/images/workshop/phase%202%20rds/create%20rds/create%20rds%206.png)

- Select Storage type: `gp3`.
- Enter Allocated storage: `20` GB.
- Enable Storage autoscaling: `Yes`.
- Enter Maximum storage threshold: `50` GB.
![Create RDS storage settings](/images/workshop/fix-img-ver-01/rds/rds%20storage%20fix.png)

![Create RDS autoscaling threshold](/images/workshop/fix-img-ver-01/rds/rds%20storage%20fix%20for%20scaling.png)

- Enter Initial database name: `myfit`.
- Enter Backup retention period: `7` days.
- Keep `Enable automated backup`: `enabled`.
- Keep `Database Insights`: `Standard`.
- Keep `Performance Insights`: `disabled`.
- Keep `Enhanced Monitoring`: `disabled`.
- Enable CloudWatch logs export: `postgresql`.

![Create RDS database name and backup](/images/workshop/fix-img-ver-01/rds/fix%20rds%20database%20init%20name.png)

![Create RDS monitoring options](/images/workshop/fix-img-ver-01/rds/fix%20rds%20monitoring.png)

- Keep `Enable replication in another AWS Region`: `disabled`.
- Keep `Enable encryption`: `disabled`.
- Keep `Enable deletion protection`: `enabled`.

![Create RDS backup, encryption, and maintenance](/images/workshop/fix-img-ver-01/rds/fix%20rds%20back%20up%20disable%20replication%20encrypt.png)

- Click `Create database`.

![Create database final step](/images/workshop/fix-img-ver-01/rds/fix%20rds%20final%20pricing%20and%20create.png)

- Wait until DB instance status is `available`.
![RDS result screen 1](/images/workshop/phase%202%20rds/create%20rds/rds%20result.png)

- Copy Endpoint address: `<your-rds-endpoint>`.
- Confirm Port: `5432`.
![RDS result endpoint and port](/images/workshop/fix-img-ver-01/rds/fix%20rds%20result%20endpoint.png)

## 3. Check database secret in Secrets Manager (auto generated)

1. Open Secrets Manager Console.
2. Save secret and copy ARN: `<your-rds-secret-arn>`.

## 4. Phase completion checklist

1. Confirm DB subnet group is `Complete` and includes only the two isolated subnets.
2. Confirm DB instance status is `available`.
3. Confirm Engine/Class/Multi-AZ are `postgres 15.14`, `db.t4g.micro`, `true`.
4. Confirm storage is `gp3`, `20` GB, autoscaling `50` GB.
5. Confirm Public access is `false`, port is `5432`.
6. Confirm Backup retention is `7` days and CloudWatch logs export includes `postgresql`.
7. Confirm secret ARN for DB credentials is saved for later phases.

