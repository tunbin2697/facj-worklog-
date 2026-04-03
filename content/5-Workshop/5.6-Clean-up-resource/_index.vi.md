---
title: "Dọn dẹp tài nguyên"
date: 2026-04-03
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

## 5.6 Dọn dẹp tài nguyên

Dùng mục này để xóa tài nguyên workshop và tránh phát sinh chi phí AWS không cần thiết.

## 1. Thứ tự khuyến nghị

1. Dừng sử dụng ứng dụng và các bài test traffic.
2. Xóa tài nguyên stack bằng CDK destroy.
3. Dọn các stack rollback lỗi bằng AWS CLI nếu có.
4. Xóa thủ công tài nguyên được giữ lại (ví dụ S3 bucket, snapshot).
5. Xác nhận không còn tài nguyên workshop.

## 2. Dọn stack CloudFormation lỗi bằng AWS CLI (tùy chọn)

Nếu deploy trước đó lỗi và stack bị kẹt rollback:

```powershell
aws cloudformation list-stacks \
	--stack-status-filter ROLLBACK_COMPLETE ROLLBACK_FAILED DELETE_FAILED \
	--query "StackSummaries[?contains(StackName, 'MyfitInfraStack')].[StackName,StackStatus]" \
	--output table

aws cloudformation delete-stack --stack-name MyfitInfraStack --region us-east-1
aws cloudformation wait stack-delete-complete --stack-name MyfitInfraStack --region us-east-1
```

## 3. Hủy stack bằng CDK

Tại thư mục gốc myfit-infra:

```powershell
npx cdk destroy MyfitInfraStack --region us-east-1 --force
```

## 4. Kiểm tra dọn thủ công

1. CloudFormation: không còn stack lỗi hoặc stack đang active.
2. ECS: không còn service/task đang chạy của workshop stack.
3. ALB/Target Group: đã được xóa.
4. RDS: instance và snapshot đã xử lý theo retention policy.
5. CloudFront: distribution đã xóa hoặc disable nếu không dùng nữa.
6. Route 53: xóa alias record của workshop nếu không cần nữa.
7. S3: empty và xóa các bucket retained chỉ dùng cho workshop.
8. Secrets Manager: xóa secret tạm không còn dùng.
9. CloudWatch Logs: xóa log group của workshop nếu không cần giữ.

## 5. Checklist xác nhận cuối

1. Không còn compute resource đang chạy từ workshop stack.
2. Không còn load balancer hoặc ECS service của workshop stack.
3. Không còn DNS record mồ côi trỏ đến tài nguyên đã xóa.
4. Billing dashboard không còn chi phí phát sinh ngoài dự kiến từ workshop này.
