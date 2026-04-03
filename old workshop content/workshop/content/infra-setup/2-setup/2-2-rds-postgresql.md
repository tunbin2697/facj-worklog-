---
title: "2.2 RDS PostgreSQL"
weight: 22
---

# 2.2 RDS PostgreSQL

The stack uses a PostgreSQL database named `myfit` with managed credentials and private networking.

## Content

1. Create the database
2. Configure availability and security
3. Configure backups and logs
4. What to verify after creation

## 2.2.1 Create the database

1. Open the RDS console.
2. Choose Databases, then Create database.
3. Select Standard create.
4. Under Engine options, choose PostgreSQL.
5. Under Engine version, choose PostgreSQL 15.
6. Under Templates, choose Free tier or Dev/Test only if you are matching the low-cost stack shape.
7. Set the DB instance identifier to `myfit`.
8. Set the initial database name to `myfit`.
9. Choose `db.t4g.micro`.
10. Set storage type to GP3.
11. Start with 20 GiB allocated storage.
12. Enable storage autoscaling and cap it at 50 GiB.

## 2.2.2 Configure availability and security

1. Set Multi-AZ to on.
2. Set Public access to No.
3. Place the database in the isolated private subnets of your VPC.
4. Attach the database security group you created in the networking section.
5. Choose self-managed credentials or AWS Secrets Manager managed credentials, depending on the console path you follow.
6. Use the username `postgres`.
7. Add a description such as `MyFit backend database` when the console prompts for database details.

## 2.2.3 Configure backups and logs

1. Set backup retention to 7 days.
2. Enable automated backups.
3. Turn on PostgreSQL log exports to CloudWatch.
4. Set CloudWatch log retention to 7 days if the console exposes the setting during creation.
5. Review the database summary page after creation and confirm the endpoint is private.

## 2.2.4 What to verify after creation

- Status is Available.
- Endpoint is reachable only from the ECS service security group.
- Secrets Manager contains the generated database secret.
- The database is not publicly accessible.
