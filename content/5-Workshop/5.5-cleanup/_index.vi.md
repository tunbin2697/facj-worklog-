---
title : "Dọn dẹp tài nguyên"
date : 2024-01-01
weight : 5
chapter : false
pre : " <b> 5.5. </b> "
---

# 5.5 Dọn dẹp tài nguyên

Xóa toàn bộ tài nguyên của workshop để tránh phát sinh chi phí ngoài ý muốn.

## Thứ tự khuyến nghị

1. Xóa listener rules trên ALB (tùy chọn nếu xóa ALB trực tiếp).
2. Xóa Application Load Balancer.
3. Xóa Target Group.
4. Terminate EC2 backend instance.
5. Xóa Cognito User Pool (và app client).
6. Xóa CloudWatch log groups tạo cho workshop.
7. Xóa IAM role/security group chỉ dùng cho lab.

{{% notice warning %}}
Trước khi xóa IAM role hoặc security group, hãy xác nhận không có tài nguyên dùng chung phụ thuộc vào chúng.
{{% /notice %}}

## Kiểm tra sau dọn dẹp

- Không còn EC2 đang chạy
- Không còn ALB và Target Group
- Không còn Cognito User Pool của workshop
- Không còn CloudWatch log group dành riêng cho workshop
