---
title : "Chuẩn bị"
date : 2024-01-01 
weight : 2 
chapter : false
pre : " <b> 5.2. </b> "
---

## Trước khi bắt đầu

{{% notice info %}}
## Thành phần bắt buộc (cần có)

Những thành phần sau là bắt buộc để workshop hoạt động đúng:

- **HTTPS Listener:** Application Load Balancer cần có listener HTTPS (ví dụ cổng 443) với chứng chỉ hợp lệ. Việc chuyển hướng tới Cognito-hosted UI và trao đổi token an toàn yêu cầu TLS trong production.
- **Amazon Cognito User Pool:** Một Cognito User Pool đã được cấu hình kèm App Client và callback/redirect URLs đúng.
- **Chứng chỉ SSL:** Chứng chỉ SSL hợp lệ cho domain của bạn (khuyến nghị dùng ACM) để gắn vào listener HTTPS của ALB.
- **Target Groups:** Target Group(s) đã được cấu hình cho ứng dụng backend, EC2 instance(s) đã đăng ký và passing health checks.

Nếu thiếu bất kỳ thành phần nào, các luồng xác thực và đường dẫn bảo vệ có thể không hoạt động như mong đợi.
{{% /notice %}}
Thêm chính sách IAM sau vào tài khoản của bạn để triển khai và dọn dẹp workshop:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "elasticloadbalancing:*",
                "cognito-idp:*",
                "iam:PassRole",
                "iam:CreateRole",
                "iam:CreateInstanceProfile",
                "iam:AddRoleToInstanceProfile",
                "iam:AttachRolePolicy",
                "logs:*"
            ],
            "Resource": "*"
        }
    ]
}
```

## Thành phần bắt buộc (cần có)

Những thành phần sau là bắt buộc để workshop hoạt động đúng:

- **HTTPS Listener:** Application Load Balancer cần có listener HTTPS (ví dụ cổng 443) với chứng chỉ hợp lệ. Việc chuyển hướng tới Cognito-hosted UI và trao đổi token an toàn yêu cầu TLS trong production.
- **Amazon Cognito User Pool:** Một Cognito User Pool đã được cấu hình kèm App Client và callback/redirect URLs đúng.
- **Chứng chỉ SSL:** Chứng chỉ SSL hợp lệ cho domain của bạn (khuyến nghị dùng ACM) để gắn vào listener HTTPS của ALB.
- **Target Groups:** Target Group(s) đã được cấu hình cho ứng dụng backend, EC2 instance(s) đã đăng ký và passing health checks.

Nếu thiếu bất kỳ thành phần nào, các luồng xác thực và đường dẫn bảo vệ có thể không hoạt động như mong đợi.
