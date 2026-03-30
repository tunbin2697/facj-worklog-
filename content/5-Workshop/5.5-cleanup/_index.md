---
title : "Clean-up"
date : 2024-01-01
weight : 5
chapter : false
pre : " <b> 5.5. </b> "
---

# 5.5 Clean-up Resources

Delete all workshop resources to avoid unexpected charges.

## Recommended Order

1. Delete ALB listener rules (optional if deleting ALB directly).
2. Delete Application Load Balancer.
3. Delete Target Group.
4. Terminate EC2 backend instance.
5. Delete Cognito User Pool (and app client).
6. Delete CloudWatch log groups created for the workshop.
7. Delete custom IAM roles/security groups created only for this lab.

{{% notice warning %}}
Always verify there are no shared resources before deleting IAM roles or security groups.
{{% /notice %}}

## Final Verification

- No running EC2 instances
- No ALB and Target Group
- No workshop Cognito User Pool
- No workshop-specific CloudWatch log groups
---
title : "Step 3-4: Create ALB & Configure Auth"
date : 2024-01-01
weight : 5
chapter : false
pre : " <b> 5.5. </b> "
---

# Step 3-4: Create ALB & Configure Auth

### Step 3: Create Application Load Balancer

#### 1. Create ALB

1. Open AWS Console > EC2 > Load Balancers > Create Load Balancer > Application Load Balancer.
2. Name: for example `workshop-alb`.
3. Scheme: Internet-facing.
4. Listen on: HTTP (port 80) or HTTPS (port 443 if you have an ACM certificate).
5. VPC and subnets: select public subnets (or appropriate) where ALB will be deployed.
6. Security Group: create or select a group allowing inbound HTTP/HTTPS from 0.0.0.0/0.
7. Click Create.

#### 2. Create Target Group

1. Open EC2 > Target Groups > Create Target Group.
2. Protocol: HTTP, Port: 80.
3. VPC: select the VPC containing your EC2 instance.
4. Health check path: / (or depending on your app).
5. Register targets: select the EC2 instance you created in Step 1.
6. Click Create.

#### 3. Attach Target Group to ALB

1. Go back to ALB, open Listeners.
2. Listener HTTP:80 > Edit default action > Forward to target group > select the target group you created.
3. Click OK.

### Step 4: Configure Cognito Authentication on ALB

#### 1. Configure Listener Rules

1. Go to ALB > Listeners > HTTP:80 > View/edit rules.
2. Add rules:

**Rule 1: Public path**
- Condition: Path = `/`
- Action: Forward to target group

**Rule 2: Protected path (dashboard)**
- Condition: Path = `/dashboard`
- Action: Authenticate with Cognito
  - User pool: select your user pool
  - User pool client: select your app client
  - User pool domain: select your Cognito domain
  - Authentication request extra parameters: (leave empty or add scope)
- Then forward to target group

**Rule 3: Admin path**
- Condition: Path = `/admin`
- Action: Authenticate with Cognito (same config as Rule 2)
- Then forward to target group

#### 2. ALB Header Injection

After Cognito authentication succeeds, ALB automatically injects the following headers:
- `x-amzn-oidc-identity`: user identity (sub claim from Cognito token)
- `x-amzn-oidc-accesstoken`: access token
- `x-amzn-oidc-data`: additional info (JSON encoded)

Your backend (Node.js app) reads these headers to identify the user.

### Screenshot placeholder

```text
[Screenshot: ALB creation, Target Group, Listener rules with Cognito auth]
```

## Vietnamese

### Step 3: Tạo Application Load Balancer

#### 1. Create ALB

1. Vào AWS Console > EC2 > Load Balancers > Create Load Balancer > Application Load Balancer.
2. Tên: ví dụ `workshop-alb`.
3. Scheme: Internet-facing.
4. Listen on: HTTP (port 80) hoặc HTTPS (port 443 nếu có ACM certificate).
5. VPC và subnets: chọn subnet công khai (hoặc thích hợp) nơi ALB sẽ được triển khai.
6. Security Group: tạo hoặc chọn group cho phép inbound HTTP/HTTPS từ 0.0.0.0/0.
7. Nhấp Create.

#### 2. Create Target Group

1. Vào EC2 > Target Groups > Create Target Group.
2. Protocol: HTTP, Port: 80.
3. VPC: chọn VPC chứa EC2 instance.
4. Health check path: / (hoặc tùy ứng dụng).
5. Register targets: chọn EC2 instance bạn đã tạo ở Step 1.
6. Nhấp Create.

#### 3. Attach Target Group to ALB

1. Quay lại ALB, vào Listeners.
2. Listener HTTP:80 > Edit default action > Forward to target group > chọn target group vừa tạo.
3. Nhấp OK.

### Step 4: Cấu hình Cognito Authentication trên ALB

#### 1. Configure Listener Rules

1. Vào ALB > Listeners > HTTP:80 > View/edit rules.
2. Thêm rules:

**Rule 1: Public path**
- Condition: Path = `/`
- Action: Forward to target group

**Rule 2: Protected path (dashboard)**
- Condition: Path = `/dashboard`
- Action: Authenticate with Cognito
  - User pool: chọn user pool vừa tạo
  - User pool client: chọn app client
  - User pool domain: chọn domain Cognito
  - Authentication request extra parameters: (để trống hoặc thêm scope)
- Then forward to target group

**Rule 3: Admin path**
- Condition: Path = `/admin`
- Action: Authenticate with Cognito (cấu hình giống Rule 2)
- Then forward to target group

#### 2. ALB Header Injection

Sau khi Cognito authentication thành công, ALB sẽ tự động chèn những header sau vào request:
- `x-amzn-oidc-identity`: identity của user (sub claim from Cognito token)
- `x-amzn-oidc-accesstoken`: access token
- `x-amzn-oidc-data`: thông tin bổ sung (JSON encoded)

Backend của bạn (Node.js app) sẽ đọc header này để xác định user.

### Screenshot placeholder

```text
[Screenshot: ALB creation, Target Group, Listener rules with Cognito auth]
```

![custom policy](/images/5-Workshop/5.5-Policy/policy2.png)

Successfully customize policy

![success](/static/images/5-Workshop/5.5-Policy/success.png)

5. From your session on the Test-Gateway-Endpoint instance, test access to the S3 bucket you created in Part 1: Access S3 from VPC
```
aws s3 ls s3://<yourbucketname>
```

This command will return an error because access to this bucket is not permitted by your new VPC endpoint policy:

![error](/static/images/5-Workshop/5.5-Policy/error.png)

6. Return to your home directory on your EC2 instance ` cd~ `

+ Create a file ```fallocate -l 1G test-bucket2.xyz ```
+ Copy file to 2nd bucket ```aws s3 cp test-bucket2.xyz s3://<your-2nd-bucket-name>```

![success](/static/images/5-Workshop/5.5-Policy/test2.png)

This operation succeeds because it is permitted by the VPC endpoint policy.

![success](/static/images/5-Workshop/5.5-Policy/test2-success.png)

+ Then we test access to the first bucket by copy the file to 1st bucket `aws s3 cp test-bucket2.xyz s3://<your-1st-bucket-name>`

![fail](/static/images/5-Workshop/5.5-Policy/test2-fail.png)

This command will return an error because access to this bucket is not permitted by your new VPC endpoint policy.

#### Part 3 Summary:

In this section, you created a VPC endpoint policy for Amazon S3, and used the AWS CLI to test the policy. AWS CLI actions targeted to your original S3 bucket failed because you applied a policy that only allowed access to the second bucket you created. AWS CLI actions targeted for your second bucket succeeded because the policy allowed them. These policies can be useful in situations where you need to control access to resources through VPC endpoints.

