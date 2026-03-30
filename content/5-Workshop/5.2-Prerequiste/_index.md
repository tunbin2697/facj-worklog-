---
title : "Prerequisites"
date : 2024-01-01 
weight : 2 
chapter : false
pre : " <b> 5.2. </b> "
---

## Before You Start

{{% notice info %}}
## Required components (must have)


These components are required for the workshop to function correctly:

- **HTTPS Listener:** Your Application Load Balancer must include an HTTPS (TLS) listener (for example port 443) with a valid certificate. Cognito-hosted UI redirects and secure token exchanges require TLS in production.
- **Amazon Cognito User Pool:** A configured Cognito User Pool with an App Client and correct callback/redirect URLs.
- **SSL Certificate:** A valid SSL certificate for your domain (ACM is recommended) to attach to the ALB HTTPS listener.
- **Target Groups:** Configured Target Group(s) for your backend application(s) with EC2 instance(s) registered and passing health checks.

If any of the above are missing, authentication flows and protected routes may not work as expected.
{{% /notice %}}
Add the following IAM permission policy to your user account to deploy and cleanup this workshop:

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

## Required components (must have)

These components are required for the workshop to function correctly:

- **HTTPS Listener:** Your Application Load Balancer must include an HTTPS (TLS) listener (for example port 443) with a valid certificate. Cognito-hosted UI redirects and secure token exchanges require TLS in production.
- **Amazon Cognito User Pool:** A configured Cognito User Pool with an App Client and correct callback/redirect URLs.
- **SSL Certificate:** A valid SSL certificate for your domain (ACM is recommended) to attach to the ALB HTTPS listener.
- **Target Groups:** Configured Target Group(s) for your backend application(s) with EC2 instance(s) registered and passing health checks.

If any of the above are missing, authentication flows and protected routes may not work as expected.
