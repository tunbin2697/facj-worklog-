---
title: "Điều kiện tiên quyết - IAM roles và policy baseline"
date: 2026-04-03
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

## 1. Chuẩn bị ECS task execution role (stack baseline)

- Mở IAM Console - `Roles` - `Create role`.
- Chọn trusted entity `AWS service`.
- Chọn service `Elastic Container Service`.
- Chọn use case `Elastic Container Service Task`.
- Bấm `Next`.
![Create task execution role - trusted entity](/images/workshop/IAM/task%20execution%20role/task%20execution%20role1.png)

- Tìm và chọn managed policy `AmazonECSTaskExecutionRolePolicy`.
- Bấm `Next`.
![Create task execution role - add managed policy](/images/workshop/IAM/task%20execution%20role/task%20execution%20role2.png)

- Nhập role name `MyfitInfraStack-TaskExecutionRole`.
- Nhập description `Allows ECS tasks to call AWS services on your behalf.`
- Bấm `Create role`.
![Create task execution role - name and create](/images/workshop/IAM/task%20execution%20role/task%20execution%20role3.png)
![Create task execution role - review and create](/images/workshop/IAM/task%20execution%20role/task%20execution%20role4.png)

## 2. Thêm execution role inline policy (ECR, Logs, Secrets)

- Mở role `MyfitInfraStack-TaskExecutionRole`.
- Bấm `Add permissions` - `Create inline policy`.
![Task execution role - create inline policy entry](/images/workshop/IAM/task%20execution%20role/task%20execution%20role5.png)

- Trong `JSON` editor, thêm quyền tương đương policy `TaskExecutionRoleDefaultPolicyA84DD1B0` của stack.
- Giữ ít nhất các action và resource sau:

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

- Lưu với tên inline policy `TaskExecutionRoleDefaultPolicy`.
![Task execution role - inline policy JSON](/images/workshop/IAM/task%20execution%20role/task%20execution%20role6.png)
![Task execution role - create inline policy](/images/workshop/IAM/task%20execution%20role/task%20execution%20role7.png)

## 3. Chuẩn bị ECS task role (application data access)

- Mở IAM role `MyfitInfraStack-TaskRole`.
- Edit inline policy `TaskRoleDefaultPolicy`.
- Xác nhận S3 access policy bao gồm bucket `crawl.fitness` và object path `crawl.fitness/*`.
![Task role S3 policy JSON](/images/workshop/IAM/task%20role/task%20role.png)

## 4. Service-level policies bắt buộc ngoài IAM role

Một số quyền phải cấu hình tại service, không chỉ trong IAM role.

### 4.1 S3 bucket policy cho CloudFront origin access

- Mở S3 bucket dùng làm frontend origin.
- Mở `Permissions` - `Bucket policy` - `Edit`.
- Thêm statement cho CloudFront đọc object với `AWS:SourceArn` của distribution.

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

### 4.2 Vòng đời secret value cho Bedrock key

- Lưu Bedrock API key trong Secrets Manager secret `myfit/bedrock-api-key`.
- Khi rotate key, cập nhật secret value và deploy lại ECS service để runtime nhận giá trị mới.

## 5. Checklist hoàn tất điều kiện tiên quyết

1. Xác nhận execution role tồn tại và trust policy principal là `ecs-tasks.amazonaws.com`.
2. Xác nhận managed policy `AmazonECSTaskExecutionRolePolicy` đã attach.
3. Xác nhận execution role inline policy có quyền ECR, logs, và Secrets Manager read.
4. Xác nhận Bedrock secret ARN nằm trong resources của execution role policy.
5. Xác nhận task role inline policy cho phép S3 actions với bucket `crawl.fitness`.
6. Xác nhận S3 bucket policy frontend origin cho phép CloudFront service principal với distribution SourceArn.
7. Xác nhận ECS task definition map secret `BEDROCK_API_KEY` từ Secrets Manager.
