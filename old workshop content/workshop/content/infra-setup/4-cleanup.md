---
title: "4. Cleanup"
weight: 40
---

# 4. Cleanup

This stack retains some resources by design. Clean up in the right order so you do not leave dangling DNS, certificates, or retained storage behind.

## Content

1. Recommended order
2. What will remain after stack deletion
3. Cleanup checklist

## 4.1 Recommended order

1. Stop or scale down the ECS service.
2. Remove Route 53 alias records.
3. Disable or delete the CloudFront distribution.
4. Delete the CloudFormation stack if you are using CDK-managed resources.
5. Delete retained S3 objects and buckets if you no longer need them.
6. Delete retained RDS snapshots only if you are certain you do not need recovery.
7. Delete the ACM certificate after DNS references are gone.

## 4.2 What will remain after stack deletion

- The frontend S3 bucket is retained.
- The RDS database uses snapshot removal policy.
- Imported resources such as the ECR repository and the media bucket are not deleted by the stack.
- The ACM certificate and Route 53 hosted zone are outside the normal stack cleanup path if they were created separately.

## 4.3 Cleanup checklist

1. Confirm that no app traffic is still using the stack.
2. Confirm that the CloudFront distribution is disabled before deleting aliases.
3. Confirm that the database snapshot exists if you need rollback.
4. Confirm that the retained bucket is empty before deleting it manually.
