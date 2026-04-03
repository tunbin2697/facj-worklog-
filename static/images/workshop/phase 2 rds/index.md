5. Create RDS Database
Navigate to RDS Console 

Engine: PostgreSQL 15.14
Instance class: db.t4g.micro
Database name: myfit
Multi-AZ: Yes
Storage: 20 GB GP3 (auto-scaling to 50 GB)
VPC: Select your created VPC
Subnet group: Use isolated subnets
Security group: Database SG
Backup retention: 7 days
Enable CloudWatch logs export
6. Create Database Secret
Navigate to Secrets Manager Console 

Create secret for RDS database credentials
Note the ARN for later use