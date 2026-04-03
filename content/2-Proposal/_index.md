---
title: "Proposal"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

This proposal presents the technical project I plan to implement during my internship and the practical value it brings to my team.

# MyFit - Fitness Management Platform
## A Comprehensive AWS Cloud Solution for Personal Health & Fitness Tracking

## **1. Project Overview**

MyFit is a comprehensive technology platform designed to accompany users on their health management and training journey. To deliver the smoothest and most reliable experience, the system is built on 3 core infrastructure layers:

* **User Experience (Frontend):** An intuitive, user-friendly application interface that helps users easily track progress, personal metrics and interact with features.  
* **Central Processing System (Backend):** A powerful data processing platform ensuring accuracy, real-time synchronization and maximum protection of user information.  
* **Operational Infrastructure (Cloud Infrastructure):** The system is fully deployed on AWS cloud computing infrastructure.

By adopting cloud managed services, MyFit not only optimizes operational costs but also commits to delivering a system that operates stably 24/7. This architecture ensures the application is always ready to scale flexibly to meet the ever-growing user base in the future without disrupting the user experience.

## **2. Objectives**

### **2.1. Overall Objectives:**

* Build a fitness app system capable of serving mobile/web simultaneously.  
* Build a fitness platform operating stably on AWS infrastructure.  
* Ensure availability and scaling capability according to cloud resources.  
* Ensure seamless user experience from login to health metric tracking  
* Establish clear, repeatable deployment processes and reduce operational errors

### **2.2. Specific Output Objectives:**

* Secure backend API using JWT Cognito  
* Frontend access via CloudFront with fast and stable loading  
* Dashboard/charts for health and workout data tracking  
* Separated infra and app deployment process with rollout status tracking capability

## **3. Problems to Address**

Key issues the project needs to handle:

* **Integration Issues:** frontend, backend and infrastructure need synchronized environment configuration  
* **Security Issues:** prevent credentials exposure, control API access, restrict unnecessary public resources  
* **Operational Issues:** need log/health observation to detect errors early during deployment  
* **Scalability Issues:** ensure system handles load well when user numbers increase

## **4. Solution Architecture**

### **4.1. Concept and Objectives**

**Context and Problem Statement**

The system is built to meet personal health management and training plan needs.

*What is the system used for:*

* Manage user profiles and synchronize login information  
* Track body metrics, calculate health indicators  
* Manage training plans, sessions and training logs  
* Manage nutrition data by meal and by day

*Who are the customers:*

* Individual users needing to track health and fitness

*What problems does it solve:*

* Unify health data in a single platform  
* Reduce manual operations through API and real-time applications as needed  
* Ensure system can be deployed, operated and scaled on AWS

*Use-case aligned with FCAJ/AWS:*

* This is a clear cloud-native use case closely aligned with AWS managed services  
* Stays on topic by focusing on deploying secure, scalable applications on AWS infrastructure

**Specific Objectives and Success Criteria**

*Expected Outputs:*

* Frontend application served via CloudFront  
* Stable backend API running on ECS Fargate  
* User authentication via Cognito Hosted UI and JWT  
* Centralized logging via CloudWatch

*Success Evaluation Criteria:*

* Users successfully log in and call main APIs  
* Core workflows (workout, health metrics, nutrition) work end-to-end  
* ECS service rollout succeeds and reaches stable state  
* Can quickly trace errors via logs and health checks

### **4.2. System Architecture:**

![Project Architecture Diagram](/images/proposal/project-architecture-diagram.png)

### **4.3. Main Data Flows:**

* **Authentication:** Mobile app connects directly to Amazon Cognito for identity management and login.  
* **Access & Distribution:** User requests go through Route 53 (DNS) to CloudFront (CDN).  
* **Request Routing:** CloudFront serves static interface from S3 Frontend Bucket (for web) or routes API requests through ALB.  
* **Backend Processing:** ALB load balances and forwards API requests to Spring Boot containers running on ECS Fargate.  
* **Task Initialization:** ECS Fargate retrieves container image from ECR and security information (DB password, API key) from Secrets Manager.  
* **Data Storage:** Fargate executes business logic, reads/writes data from RDS PostgreSQL and handles files with S3 Media Bucket.

### **4.4. AWS Services Selection and Rationale:**

Services currently used in the project:

* **Amazon CloudFront:** Content distribution (CDN), reduces latency, consolidates public endpoint for both frontend and API routing.  
* **Amazon S3:** Persistently stores static frontend and media files at low cost.  
* **Application Load Balancer (ALB):** Handles HTTP/HTTPS load balancing for backend services running on ECS.  
* **Amazon ECS Fargate:** Runs backend containers in managed mode, enabling automatic scaling without physical server management.  
* **Amazon RDS PostgreSQL:** Fully managed relational database, perfect for storing high-constraint business data.  
* **Amazon Bedrock:** Integrates intelligent chatbot for application to support user interaction.  
* **Amazon Cognito:** Provides user authentication solution, reducing time and cost to build custom identity management.  
* **Amazon ECR:** Safely stores and manages backend container images.  
* **Amazon CloudWatch:** Centralizes system logging, supports performance monitoring and operational alerting.  
* **AWS Route 53 and ACM:** Manages domain and provides/auto-renews TLS certificate for secure HTTPS access.

*Why not Lambda/API Gateway at this stage:*

* Backend is currently a monolithic Spring Boot application, suitable for long-term container model on ECS  
* Reduces effort to break into serverless functions in early phases  
* Optimizes delivery time and simplifies initial operations

### **4.5. Security and Basic IAM:** 

*Principles Applied:*

* Principle of Least Privilege for runtime roles  
* No hard-coded access keys in source  
* Restrict public resources at data layer

*Current Security Implementation:*

* ECS Task Execution Role uses standard policy for image pull/logging  
* ECS Task Role grants only necessary read/write permissions for media bucket  
* DB secret retrieved from Secrets Manager instead of hard-coded  
* RDS placed in private subnet, not public  
* ALB restricts traffic from CloudFront prefix list  
* Backend only accepts valid access tokens from Cognito.

### **4.6. Scalability and Operations:** 

*Scaling:*

* ECS auto scales based on CPU, current config min 2 and max 4 tasks  
* Layered architecture separating CloudFront and ECS for independent frontend/backend scaling

*Logging and Monitoring:*

* CloudWatch Logs for backend containers  
* RDS export logs to track queries/DB errors  
* ALB health check endpoint to detect unhealthy instances

### **4.7. Management and Automated Deployment Process (CI/CD & IaC)**

To optimize operational time and minimize manual errors, the system applies infrastructure-as-code and automated deployment:

* **Infrastructure as Code (IaC) with AWS CloudFormation:** All AWS resource configurations are defined and centrally managed through code, ensuring consistency and rapid synchronization between environments.  
* **Continuous Deployment (CI/CD):** Applies **Dev → GitHub Actions → Amazon ECS** workflow to automate application release:  
  1. **Dev:** Update and push source code to GitHub.  
  2. **GitHub Actions:** Automatically triggers Docker image build and pushes to Amazon ECR.  
  3. **Amazon ECS:** GitHub Actions calls ECS service update. ECS Fargate automatically pulls latest image and replaces old containers without service interruption (Rolling Update)

## **5. Code Snippets**

### **5.1 Dockerfile Backend**

![Docker File](/images/proposal/docker%20file.png)

### **5.2 CDK Route API Through CloudFront**

![CDK Route API via CloudFront](/images/proposal/cdk%20route%20api%20via%20cloudfront.png)

### **5.3 Script Deploy App**

![Deploy App Script](/images/proposal/deploy%20app%20scrip.png)  

### **5.4 Stack Initialization**  

![CDK Infra Code](/images/proposal/cdk%20infra%20code.png)  

### **5.5 App Screenshots:**  

![Web App 1](/images/proposal/web%20app1.png)  
![Web App 2](/images/proposal/web%20app2.png)  
![Web App 3](/images/proposal/web%20app3.png)  
![Web App 4](/images/proposal/web%20app4.png)  
![Web App 5](/images/proposal/web%20app5.png)

## **6. Budget Estimation**

Region: us-east-1:

| Item | Service | Actual Configuration | Estimated/Month |
| :---- | :---- | :---- | :---- |
| Frontend CDN | CloudFront | 1 distribution, ~10GB transfer/month | ~1-5 USD |
| Static hosting + Media | S3 | 2 buckets (frontend + media), ~10GB | ~0.5-2 USD |
| Backend compute | ECS Fargate | 2 tasks × 0.25 vCPU × 0.5 GB RAM, 24/7 | ~15-20 USD |
| Database | RDS PostgreSQL | t4g.micro, Multi-AZ, GP3 20GB, PostgreSQL 15 | ~30-35 USD |
| Container registry | ECR | 1 repo, ~1GB image storage | ~0.1-1 USD |
| Logging & Monitoring | CloudWatch | Container Insights + logs 1 week retention | ~5-15 USD |
| Secrets Manager | Secrets Manager | 2 secrets (DB credentials & Bedrock API) | ~1 USD |
| Load Balancer | ALB | 1 ALB, ~10 LCU/month | ~18-22 USD |
| User authentication | Cognito | MAU ≤ 50,000 (free tier) | ~0 USD |
| DNS + Certificate | Route 53 + ACM | 1 hosted zone, ACM free | ~0.5-1 USD |
| Chatbot | Bedrock |  |  |
| **Total Reference** | **Full System** |  | **~71-100 USD/month** |

**Notes:**

* Configuration does not use NAT Gateway (natGateways=0), saving ~32 USD/month compared to architecture with NAT  
* Actual costs depend on traffic, log volume, data transfer and number of active users
