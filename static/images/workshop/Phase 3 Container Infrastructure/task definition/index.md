task def json:


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


