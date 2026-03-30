---
title : "Tạo Application Load Balancer"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3.3. </b> "
---

Tạo ALB và target group để chuyển tiếp traffic vào EC2 backend.

## Các bước

1. Vào EC2 -> Load Balancers -> Create Load Balancer -> Application Load Balancer.
2. Chọn `Internet-facing`.
3. Chọn VPC và ít nhất 2 public subnet.
4. Tạo/chọn security group cho ALB:
   - Inbound HTTP/HTTPS từ người dùng.
5. Tạo target group:
   - Target type: Instance
   - Protocol/Port: HTTP:80
   - Register EC2 backend instance.
6. Gắn target group vào listener của ALB.

## Giá trị cần lưu lại

- ALB DNS name
- Tên Target Group

Các giá trị này sẽ được dùng cho bước cấu hình kế tiếp.