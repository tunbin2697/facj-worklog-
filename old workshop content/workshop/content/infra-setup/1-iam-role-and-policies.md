---
title: "1. IAM role and policies"
weight: 10
---

# 1. IAM role and policies

This chapter covers the two IAM roles used by ECS and the permissions they need in the stack.

## Content

1. Task execution role
2. Task role
3. Console steps
4. What to match from the stack

## 1.1 Roles used by the stack

### 1.1.1 Task execution role

The task execution role is assumed by the ECS agent when it starts the container.

In the CDK stack, this role uses the AWS managed policy `service-role/AmazonECSTaskExecutionRolePolicy` and also needs read access to the secrets consumed at startup.

### 1.1.2 Task role

The task role is assumed by your application code inside the container.

In this stack, it is granted access to the media bucket and, if configured, the Bedrock API key secret.

## 1.2 Console steps

### 1.2.1 Create the execution role

1. Open the IAM console.
2. In the left navigation, choose Roles.
3. Choose Create role.
4. Under Select trusted entity, choose AWS service.
5. Under Use case, choose Elastic Container Service and then Elastic Container Service Task.
6. Choose Next.
7. On Add permissions, select `AmazonECSTaskExecutionRolePolicy`.
8. Choose Next.
9. On Role details, set Role name to something descriptive such as `MyfitTaskExecutionRole`.
10. Add a description such as `Execution role for MyFit backend ECS tasks`.
11. Create the role.

### 1.2.2 Add secret read access

1. Open the role you created.
2. Open the Permissions tab.
3. Choose Add permissions.
4. Choose Create inline policy or attach a customer managed policy.
5. Restrict the policy to the exact secret ARN values used by the stack.
6. Save the policy with a name that describes the secret source.

Suggested permissions:

- `secretsmanager:GetSecretValue`
- `secretsmanager:DescribeSecret`

### 1.2.3 Create the task role

1. Create a second role for ECS tasks.
2. Use the same trust relationship for `ecs-tasks.amazonaws.com`.
3. Start with no managed policy attachments.
4. Give the role a clear name such as `MyfitTaskRole`.
5. Add only the minimum access needed for runtime calls.

### 1.2.4 Grant bucket access

1. Open the S3 bucket that stores media files.
2. Attach a bucket policy or IAM policy that allows the task role to read and write objects.
3. Keep access limited to the bucket ARN and object ARN only.
4. Use the live media bucket name `crawl.fitness`.

## 1.3 What to match from the stack

- Execution role: ECS startup, secret resolution, log delivery.
- Task role: S3 read/write for media assets.
- Optional Bedrock secret access: only when `bedrockApiKeySecretArn` is provided.
