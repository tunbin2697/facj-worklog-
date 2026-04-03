---
title: "Phase 3 - Container Infrastructure"
date: 2026-04-03
weight: 3
chapter: false
pre: " <b> 5.3.3. </b> "
---

## 1. Create ECR repository and push backend image

- Open ECR Console - `Repositories` - `Create repository`.
![Create ECR repository screen 1](/images/workshop/Phase%203%20Container%20Infrastructure/ecr/create%20ecr%20repo%201.png)

- Enter Repository name: `myfit-backend`.
- Select Image tag mutability: `MUTABLE`.
- Select Encryption configuration: `AES256`.
- Confirm repository URI format: `<your-account-id>.dkr.ecr.us-east-1.amazonaws.com/myfit-backend`.
![Create ECR repository screen 2](/images/workshop/Phase%203%20Container%20Infrastructure/ecr/create%20ecr%20repo%202.png)

Build and push image to ECR:

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.us-east-1.amazonaws.com
docker build -t <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/myfit-backend:latest .
docker push <your-account-id>.dkr.ecr.us-east-1.amazonaws.com/myfit-backend:latest
```

## 2. Create ECS cluster

- Open ECS Console - `Clusters` - `Create cluster`.
![Create ECS cluster screen 1](/images/workshop/Phase%203%20Container%20Infrastructure/ecs/cluster/create%20cluster%201.png)

- Enter Cluster name: `<your-ecs-cluster-name>`.
- Pick `Fargate only`.
![Create ECS cluster screen 2](/images/workshop/Phase%203%20Container%20Infrastructure/ecs/cluster/create%20cluster%202.png)

- Set Container Insights to either Disable or enable.
![Create ECS cluster screen 3](/images/workshop/Phase%203%20Container%20Infrastructure/ecs/cluster/create%20cluster%203.png)

- Click `Create`.
![Create ECS cluster screen 4](/images/workshop/Phase%203%20Container%20Infrastructure/ecs/cluster/create%20cluster%204.png)

- Confirm cluster status: `ACTIVE`.
- Copy cluster ARN: `<your-cluster-arn>`.
![ECS cluster result](/images/workshop/Phase%203%20Container%20Infrastructure/ecs/cluster/cluster%20result.png)

## 3. Register backend task definition

- Open ECS Console - `Task definitions` - `Create new task definition`.

![Create task definition screen 1](/images/workshop/Phase%203%20Container%20Infrastructure/task%20definition/create%20task%20def%201.png)

- Paste and edit this JSON base on your actual arn service ID:
```json

{
    "family": "myfit-backend-task",
    "taskRoleArn": "arn:aws:iam::YOUR_ACCOUNT_ID:role/myfit-task-role",
    "executionRoleArn": "arn:aws:iam::YOUR_ACCOUNT_ID:role/myfit-task-execution-role",
    "networkMode": "awsvpc",
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "cpu": "256",
    "memory": "512",
    "containerDefinitions": [
        {
            "name": "web",
            "image": "YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/myfit-backend:latest",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 8080,
                    "hostPort": 8080,
                    "protocol": "tcp"
                }
            ],
            "environment": [
                {
                    "name": "SPRING_PROFILES_ACTIVE",
                    "value": "prod"
                },
                {
                    "name": "AWS_REGION",
                    "value": "us-east-1"
                },
                {
                    "name": "DB_URL",
                    "value": "jdbc:postgresql://YOUR_RDS_ENDPOINT:5432/myfit?ssl=true&sslmode=require"
                },
                {
                    "name": "CORS_ALLOWED_ORIGINS",
                    "value": "https://YOUR_DOMAIN,https://*.cloudfront.net,http://localhost:8081,http://localhost:19006"
                },
                {
                    "name": "COGNITO_ISSUER_URI",
                    "value": "https://cognito-idp.us-east-1.amazonaws.com/YOUR_USER_POOL_ID"
                },
                {
                    "name": "COGNITO_USER_POOL_ID",
                    "value": "YOUR_USER_POOL_ID"
                },
                {
                    "name": "S3_BUCKET_NAME",
                    "value": "YOUR_MEDIA_BUCKET_NAME"
                }
            ],
            "secrets": [
                {
                    "name": "DB_USERNAME",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:YOUR_ACCOUNT_ID:secret:YOUR_DB_SECRET_NAME:username::"
                },
                {
                    "name": "DB_PASSWORD",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:YOUR_ACCOUNT_ID:secret:YOUR_DB_SECRET_NAME:password::"
                },
                {
                    "name": "BEDROCK_API_KEY",
                    "valueFrom": "arn:aws:secretsmanager:us-east-1:YOUR_ACCOUNT_ID:secret:YOUR_BEDROCK_SECRET_NAME"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/myfit-backend",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "backend",
                    "awslogs-create-group": "true"
                }
            }
        }
    ]
}
```
- Click `Create`.
![Create task definition screen 2](/images/workshop/Phase%203%20Container%20Infrastructure/task%20definition/create%20task%20def%202.png)

- Confirm task definition status: `ACTIVE`.
![Task definition result](/images/workshop/Phase%203%20Container%20Infrastructure/task%20definition/create%20task%20def%20result.png)

## 4. Phase completion checklist

1. Confirm ECR repository `myfit-backend` exists.
2. Confirm image tag `latest` is pushed.
3. Confirm ECS cluster status is `ACTIVE`.
4. Confirm task definition status is `ACTIVE`.
5. Confirm task definition uses `FARGATE`, `awsvpc`, CPU `256`, memory `512`.
6. Confirm container `web` uses image `<your-account-id>.dkr.ecr.us-east-1.amazonaws.com/myfit-backend:latest` and port `8080/tcp`.
7. Confirm environment variables, secrets, and awslogs values match section 3.

