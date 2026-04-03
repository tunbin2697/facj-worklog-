---

title: "Proposal"
date: 2026-04-03
weight: 2
chapter: false
pre: " <b> 2. </b> "
--------------------

## 1. Project Overview

MyFit is a comprehensive technology platform designed to support users throughout their health management and fitness journey. To deliver a smooth and reliable experience, the system is built on three core foundations:

* **User Experience (Frontend):** An intuitive and user-friendly interface that allows users to easily track progress, personal metrics, and interact with features.
* **Core Processing System (Backend):** A powerful data processing platform ensuring accuracy, real-time synchronization, and maximum data security.
* **Cloud Infrastructure:** Fully deployed on AWS cloud infrastructure.

By leveraging Cloud Managed Services, MyFit:

* Optimizes operational costs
* Ensures 24/7 system availability
* Supports seamless scalability as user demand grows

---

## 2. Objectives

### 2.1 Overall Objectives:

* Build a fitness application supporting both mobile and web platforms.
* Ensure stable operation on AWS infrastructure.
* Guarantee availability and scalability based on cloud resources.
* Provide a seamless user experience from login to health tracking.
* Establish a clear, repeatable deployment process to reduce operational errors.

### 2.2 Specific Deliverables:

* Backend API secured using JWT and Cognito
* Frontend served via CloudFront for fast and stable delivery
* Health and workout tracking dashboard
* Separate deployment pipelines for infrastructure and application with rollout monitoring

---

## 3. Problems to Solve

Key challenges addressed in this project:

* **Integration:** Synchronizing configurations across frontend, backend, and infrastructure
* **Security:** Preventing credential leaks, controlling API access, minimizing unnecessary public exposure
* **Operations:** Monitoring logs and system health to detect issues early
* **Scalability:** Ensuring system performance under increasing user load

---

## 4. Solution Architecture

### 4.1 Idea and Objectives

**Context and Problem**

The system is designed to manage personal health and workout planning.

**System Capabilities:**

* Manage user profiles and authentication data
* Track body metrics and calculate health indicators
* Manage workout plans, sessions, and logs
* Manage nutrition data by meal and by day

**Target Users:**

* Individuals tracking health and fitness

**Problems Addressed:**

* Centralize health data in a single platform
* Reduce manual operations via APIs and real-time features
* Ensure deployability, operability, and scalability on AWS

**AWS/FCAJ Use-case Alignment:**

* A clear cloud-native use case leveraging AWS managed services
* Focused on secure, scalable, and monitored cloud deployment

**Success Criteria**

**Expected Outcomes:**

* Frontend delivered via CloudFront
* Backend APIs running on ECS Fargate
* Authentication via Cognito Hosted UI and JWT
* Centralized logging via CloudWatch

**Success Metrics:**

* Users can log in and access core APIs
* Core flows (workout, health metrics, nutrition) work end-to-end
* ECS service rollout completes successfully and remains stable
* Issues can be quickly traced via logs and health checks

---

### 4.2 System Architecture:

![System Architecture](/images/2-Proposal/image11.png)

---

### 4.3 Main Data Flow:

* **Authentication Layer:** Mobile app connects directly to Amazon Cognito for identity and login management.
* **Access & Distribution Layer:** Requests go through Route 53 (DNS) to CloudFront (CDN). CloudFront serves frontend from S3 or routes API requests to ALB.
* **Backend Processing Layer:** ALB balances traffic and forwards requests to Spring Boot containers on ECS Fargate. ECS pulls images from ECR and retrieves secrets from Secrets Manager.
* **Data Layer:** Fargate handles logic, interacts with RDS PostgreSQL and S3 Media Bucket. Amazon Bedrock is integrated as an AI chatbot.

---

### 4.4 AWS Services and Rationale:

**Services Used:**

* Amazon CloudFront – CDN for low latency and unified public endpoint
* Amazon S3 – Storage for static frontend and media files
* Application Load Balancer (ALB) – HTTP/HTTPS load balancing
* Amazon ECS Fargate – Managed container execution with auto scaling
* Amazon RDS PostgreSQL – Managed relational database
* Amazon Bedrock – AI chatbot integration
* Amazon Cognito – User authentication and identity management
* Amazon ECR – Container image registry
* Amazon CloudWatch – Centralized logging and monitoring
* AWS Route 53 & ACM – DNS and SSL/TLS certificate management

**Why not Lambda/API Gateway:**

* Backend is a Spring Boot monolith suited for container-based deployment
* Avoids complexity of serverless decomposition in early stages
* Speeds up delivery and simplifies operations

---

### 4.5 Security and IAM:

**Principles:**

* Least privilege for runtime roles
* No hard-coded credentials
* Minimize public exposure of data resources

**Implementation:**

* ECS Task Execution Role for image pulling and logging
* ECS Task Role limited to required S3 access
* Database credentials stored in Secrets Manager
* RDS deployed in private subnet
* ALB restricted to CloudFront traffic
* Backend validates Cognito access tokens

---

### 4.6 Scalability and Operations:

**Scaling:**

* ECS auto scaling based on CPU (min 2, max 4 tasks)
* Independent scaling for frontend and backend

**Monitoring:**

* CloudWatch Logs for containers
* RDS logs for query monitoring
* ALB health checks for instance status

---

### 4.7 CI/CD & IaC

To optimize operations and reduce manual errors:

* **Infrastructure as Code (IaC):** AWS CloudFormation for consistent infrastructure management
* **CI/CD Pipeline:**

  1. Developer pushes code to GitHub
  2. GitHub Actions builds Docker image and pushes to Amazon ECR
  3. ECS updates service using rolling deployment with zero downtime

---

## 5. Code Snippet

### 5.1 Dockerfile Backend

![Dockerfile](/images/2-Proposal/image5.png)

---

### 5.2 CDK Route API via CloudFront

![CDK Config](/images/2-Proposal/image4.png)

---

### 5.3 Deploy Script

![Deploy Script](/images/2-Proposal/image2.png)
![Deploy Script](/images/2-Proposal/image10.png)

---

### 5.4 Stack Initialization

![Stack Init](/images/2-Proposal/image6.png)

---

### 5.5 Application Screens
![App](/images/2-Proposal/image9.png)
![App](/images/2-Proposal/image1.png)
![App](/images/2-Proposal/image8.png)
![App](/images/2-Proposal/image7.png)
![App](/images/2-Proposal/image3.png)

---

## 6. Estimated Cost

**Region: us-east-1**

| Category      | Service         | Configuration | Monthly Estimate |
| ------------- | --------------- | ------------- | ---------------- |
| Frontend CDN  | CloudFront      | ~10GB         | $1–5             |
| Storage       | S3              | 2 buckets     | $0.5–2           |
| Backend       | ECS             | 2 tasks       | $15–20           |
| Database      | RDS             | t4g.micro     | $30–35           |
| Registry      | ECR             | 1GB           | $0.1–1           |
| Logging       | CloudWatch      | logs          | $5–15            |
| Secrets       | Secrets Manager | 2 secrets     | ~$1              |
| Load Balancer | ALB             | 1 ALB         | $18–22           |
| Auth          | Cognito         | free tier     | $0               |
| DNS + SSL     | Route53 + ACM   |               | $0.5–1           |

**Total: ~$71–100/month**

**Notes:**

* No NAT Gateway → saves ~$32/month
* Actual cost depends on traffic and usage

---

## 7. Timeline

*(Add image here if needed)*

---

## 8. Risks and Mitigation

| Risk                       | Impact      | Priority | Mitigation           |
| -------------------------- | ----------- | -------- | -------------------- |
| Sensitive data exposure    | High        | P0       | Use Secrets Manager  |
| Wrong deploy path          | Medium-High | P0       | Pre-check scripts    |
| OAuth mismatch             | High        | P0       | Sync environments    |
| Health check inconsistency | Medium      | P1       | Standardize endpoint |
| Cost increase              | Medium      | P1       | Budget alerts        |
