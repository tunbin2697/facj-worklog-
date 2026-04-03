---
title: "Clean Up Resource"
date: 2026-04-03
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

## 5.6 Clean Up Resource

Use this section to remove workshop resources and avoid unnecessary AWS cost.

## 1. Recommended order

1. Stop active app usage and traffic tests.
2. Delete stack resources with CDK destroy.
3. Clean failed rollback stacks with AWS CLI if needed.
4. Remove retained resources manually (for example S3 buckets, snapshots).
5. Verify no workshop resources remain.

## 2. Cleanup failed CloudFormation with AWS CLI (optional)

If a previous deployment failed and stack is stuck in rollback:

```powershell
aws cloudformation list-stacks \
	--stack-status-filter ROLLBACK_COMPLETE ROLLBACK_FAILED DELETE_FAILED \
	--query "StackSummaries[?contains(StackName, 'MyfitInfraStack')].[StackName,StackStatus]" \
	--output table

aws cloudformation delete-stack --stack-name MyfitInfraStack --region us-east-1
aws cloudformation wait stack-delete-complete --stack-name MyfitInfraStack --region us-east-1
```

## 3. Destroy stack with CDK

From myfit-infra root folder:

```powershell
npx cdk destroy MyfitInfraStack --region us-east-1 --force
```

## 4. Manual cleanup checks

1. CloudFormation: no stack in failed or active state.
2. ECS: no running services/tasks for workshop stack.
3. ALB/Target Group: removed.
4. RDS: instance and snapshots cleaned according to your retention policy.
5. CloudFront: distribution removed or disabled if no longer used.
6. Route 53: remove workshop alias records if no longer needed.
7. S3: empty and delete retained buckets if they are workshop-only.
8. Secrets Manager: remove temporary secrets that are no longer needed.
9. CloudWatch Logs: delete workshop log groups if not needed.

## 5. Final verification checklist

1. No active compute resources from workshop stack.
2. No active load balancer or ECS service from workshop stack.
3. No orphan DNS records pointing to deleted resources.
4. Billing dashboard shows no unexpected ongoing charges from this workshop.
