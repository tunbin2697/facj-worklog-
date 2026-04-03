1. Create VPC
Navigate to VPC Console 

Create VPC with CIDR: 10.0.0.0/16
Enable DNS hostnames and DNS resolution
Create Internet Gateway and attach to VPC
2. Create Subnets
Create 4 subnets in 2 availability zones:

Public Subnets:

10.0.0.0/18 in AZ-a (Auto-assign public IP: Yes)
10.0.64.0/18 in AZ-b (Auto-assign public IP: Yes)
Private Isolated Subnets:

10.0.128.0/18 in AZ-a
10.0.192.0/18 in AZ-b
3. Create Route Tables
Public route table: Add route 0.0.0.0/0 → Internet Gateway
Associate public subnets with public route table
Private subnets use default route table (no internet access)
4. Create Security Groups
Create 3 security groups:

Backend Load Balancer SG:

Inbound: HTTP (80) from CloudFront prefix list
Outbound: Port 8080 to Backend Service SG
Backend Service SG:

Inbound: Port 8080 from Load Balancer SG
Outbound: All traffic (0.0.0.0/0)
Database SG:

Inbound: PostgreSQL (5432) from Backend Service SG
Outbound: All traffic (0.0.0.0/0)