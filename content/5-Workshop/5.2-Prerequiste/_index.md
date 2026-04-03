---
title: "Prerequisite - IAM roles and policy baseline"
date: 2026-04-03
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

## 1. Prepare ECS task execution role (stack baseline)

- Open IAM Console - `Roles` - `Create role`.
- Select trusted entity `AWS service`.
- Select service `Elastic Container Service`.
- Select use case `Elastic Container Service Task`.
- Click `Next`.
![Create task execution role - trusted entity](/images/workshop/IAM/task%20execution%20role/task%20execution%20role1.png)

- Search and select managed policy `AmazonECSTaskExecutionRolePolicy`.
- Click `Next`.
![Create task execution role - add managed policy](/images/workshop/IAM/task%20execution%20role/task%20execution%20role2.png)

- Enter role name `MyfitInfraStack-TaskExecutionRole`.
- Enter description `Allows ECS tasks to call AWS services on your behalf.`
- Click `Create role`.
![Create task execution role - name and create](/images/workshop/IAM/task%20execution%20role/task%20execution%20role3.png)
![Create task execution role - review and create](/images/workshop/IAM/task%20execution%20role/task%20execution%20role4.png)

## 2. Add execution role inline policy (ECR, Logs, Secrets)

- Open role `MyfitInfraStack-TaskExecutionRole`.
- Click `Add permissions` - `Create inline policy`.
![Task execution role - create inline policy entry](/images/workshop/IAM/task%20execution%20role/task%20execution%20role5.png)

- In `JSON` editor, add permissions equivalent to your stack policy `TaskExecutionRoleDefaultPolicy`.
- Keep at least these actions and resources:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      "Resource": "arn:aws:ecr:us-east-1:<your-service-arn-id>:repository/myfit-backend"
    },
    {
      "Effect": "Allow",
      "Action": "ecr:GetAuthorizationToken",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:us-east-1:<your-service-arn-id>:log-group:<your-service-arn-id>:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:DescribeSecret",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "arn:aws:secretsmanager:us-east-1:<your-service-arn-id>:secret:<your-service-arn-id>",
        "arn:aws:secretsmanager:us-east-1:<your-service-arn-id>:secret:<your-service-arn-id>"
      ]
    }
  ]
}
```

- Save as inline policy `TaskExecutionRoleDefaultPolicy`.
![Task execution role - inline policy JSON](/images/workshop/IAM/task%20execution%20role/task%20execution%20role6.png)
![Task execution role - create inline policy](/images/workshop/IAM/task%20execution%20role/task%20execution%20role7.png)

## 3. Prepare ECS task role (application data access)

- Open IAM role `MyfitInfraStack-TaskRole`.
- Edit inline policy `TaskRoleDefaultPolicy07FC53DE`.
- Confirm S3 access policy covers bucket `crawl.fitness` and object path `crawl.fitness/*`.
![Task role S3 policy JSON](/images/workshop/IAM/task%20role/task%20role.png)

## 4. Service-level policies required outside IAM role

Some permissions must be configured in the target service, not only in IAM role.

### 4.1 S3 bucket policy for CloudFront origin access

- Open S3 bucket used for frontend origin.
- Open `Permissions` - `Bucket policy` - `Edit`.
- Add CloudFront read statement with `AWS:SourceArn` of your distribution.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontServicePrincipalReadOnly",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::<your-frontend-bucket>/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::<your-service-arn-id>:distribution/<your-service-arn-id>"
        }
      }
    }
  ]
}
```

### 4.2 Secret value lifecycle for Bedrock key

- Keep Bedrock API key in Secrets Manager secret `myfit/bedrock-api-key`.
- When key rotates, update secret value and redeploy ECS service to refresh runtime value.

## 5. Prerequisite completion checklist

1. Confirm execution role exists and trust policy principal is `ecs-tasks.amazonaws.com`.
2. Confirm managed policy `AmazonECSTaskExecutionRolePolicy` is attached.
3. Confirm execution role inline policy includes ECR, logs, and Secrets Manager read permissions.
4. Confirm Bedrock secret ARN is included in execution role policy resources.
5. Confirm task role inline policy allows S3 actions for `crawl.fitness` bucket.
6. Confirm S3 bucket policy for frontend origin allows CloudFront service principal with distribution SourceArn.
7. Confirm ECS task definition maps secret name `BEDROCK_API_KEY` from Secrets Manager.
