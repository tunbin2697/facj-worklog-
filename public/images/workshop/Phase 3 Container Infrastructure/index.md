Create IAM Roles (15 minutes)
Navigate to IAM Console
Go to IAM Console - Roles 

A. Create Task Execution Role
Create Role
Click "Create role"
Trusted entity type: AWS service
Use case: Elastic Container Service
Use case for other AWS services: Elastic Container Service Task
Click "Next"
Attach Permissions Policies
Search and select: AmazonECSTaskExecutionRolePolicy
Click "Next"
Role Details
Role name: myfit-task-execution-role
Description: ECS Task Execution Role for MyFit application
Click "Create role"
Add Inline Policy for Additional Permissions
Find your created role and click on it
Click "Add permissions" → "Create inline policy"
Switch to JSON tab and paste:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [
                "arn:aws:secretsmanager:*:*:secret:*database*",
                "arn:aws:secretsmanager:*:*:secret:*bedrock*"
            ]
        }
    ]
}

Policy name: TaskExecutionAdditionalPolicy
Click "Create policy"
B. Create Task Role
Create Role
Click "Create role"
Trusted entity type: AWS service
Use case: Elastic Container Service
Use case for other AWS services: Elastic Container Service Task
Click "Next"
Skip Permissions Policies
Don't attach any managed policies
Click "Next"
Role Details
Role name: myfit-task-role
Description: ECS Task Role for MyFit application runtime permissions
Click "Create role"
Add Inline Policy for S3 Access
Find your created role and click on it
Click "Add permissions" → "Create inline policy"
Switch to JSON tab and paste:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::crawl.fitness",
                "arn:aws:s3:::crawl.fitness/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel"
            ],
            "Resource": "*"
        }
    ]
}

Policy name: TaskRoleS3BedrockPolicy
Click "Create policy"
Step 10: Create Task Definition (12 minutes)
Navigate to ECS Console
Go to ECS Console - Task Definitions 

Create New Task Definition
Click "Create new task definition"
Task definition family: myfit-backend-task
Infrastructure Requirements
Launch type: AWS Fargate
Operating system/Architecture: Linux/X86_64
CPU: 0.25 vCPU (256)
Memory: 0.5 GB (512)
Task role: myfit-task-role (select from dropdown)
Task execution role: myfit-task-execution-role (select from dropdown)
Container Definition
Click "Add container"

Essential Container Details
Container name: web
Image URI: YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/myfit-backend:latest
Replace YOUR_ACCOUNT_ID with your actual AWS account ID
Essential: Yes (checked)
Port Mappings
Container port: 8080
Protocol: TCP
Port name: web-8080-tcp (auto-generated)
App protocol: HTTP
Environment Variables
Click "Add environment variable" for each:

Key	Value
SPRING_PROFILES_ACTIVE	prod
DB_URL	jdbc:postgresql://YOUR_RDS_ENDPOINT:5432/myfit?ssl=true&sslmode=require
CORS_ALLOWED_ORIGINS	https://YOUR_DOMAIN,https://*.cloudfront.net,http://localhost:8081,http://localhost:19006
AWS_REGION	us-east-1
COGNITO_ISSUER_URI	https://cognito-idp.us-east-1.amazonaws.com/YOUR_USER_POOL_ID
COGNITO_USER_POOL_ID	YOUR_USER_POOL_ID
S3_BUCKET_NAME	YOUR_MEDIA_BUCKET_NAME
Environment Variables from Secrets
Click "Add environment variable" and select "ValueFrom" for each:

Key	ValueFrom (Secret ARN)
DB_USERNAME	arn:aws:secretsmanager:us-east-1:YOUR_ACCOUNT:secret:YOUR_DB_SECRET:username::
DB_PASSWORD	arn:aws:secretsmanager:us-east-1:YOUR_ACCOUNT:secret:YOUR_DB_SECRET:password::
BEDROCK_API_KEY	arn:aws:secretsmanager:us-east-1:YOUR_ACCOUNT:secret:YOUR_BEDROCK_SECRET
Logging Configuration
Log driver: awslogs
Log group: Create new log group
Log group name: /ecs/myfit-backend
Log region: us-east-1
Log stream prefix: backend
Health Check (Optional but Recommended)
Command: CMD-SHELL,curl -f http://localhost:8080/actuator/health || exit 1
Interval: 30 seconds
Timeout: 5 seconds
Start period: 60 seconds
Retries: 3
Storage (Optional)
Leave default (no additional volumes needed)

Monitoring and Logging
Use log collection: Enabled
Log driver: awslogs (already configured above)
Tags
Add any desired tags for resource management

Create Task Definition
Click "Create" to create the task definition

Important Notes for Phase 3:
Replace Placeholders:
YOUR_ACCOUNT_ID: Your AWS account ID (12 digits)
YOUR_RDS_ENDPOINT: RDS endpoint from Phase 2
YOUR_DOMAIN: Your custom domain (if using)
YOUR_USER_POOL_ID: Cognito User Pool ID (from Phase 6)
YOUR_MEDIA_BUCKET_NAME: S3 media bucket name
YOUR_DB_SECRET: Database secret ARN from Secrets Manager
YOUR_BEDROCK_SECRET: Bedrock API key secret ARN
Verification Steps:
ECR Repository: Verify image is pushed successfully
ECS Cluster: Should show "Active" status
IAM Roles: Test policies with IAM Policy Simulator
Task Definition: Should show "ACTIVE" status