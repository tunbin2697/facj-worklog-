---
title : "Tạo Application Load Balancer và Target Group"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.3.4. </b> "
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

Trình tạo ALB cũng sẽ tạo listener rule mặc định để forward traffic về target group. Phần này chỉ dừng ở cấu hình đó; các listener rule riêng cho ứng dụng với `/`, `/health`, `/dashboard` và `/admin` sẽ được cấu hình ở phần tiếp theo.

## Ảnh Target Group

Target group là nơi ALB sẽ forward traffic đến backend. Nó cũng định nghĩa health check để AWS biết EC2 instance đã sẵn sàng nhận request hay chưa, vì vậy hãy tạo và kiểm tra target group trước khi chuyển sang cấu hình listener của ALB.

![Target group bước 1](/images/5-Workshop/workshop-resource/target%20group/1.png)

![Target group bước 2](/images/5-Workshop/workshop-resource/target%20group/2.png)

![Target group bước 3](/images/5-Workshop/workshop-resource/target%20group/3.png)

![Target group bước 4](/images/5-Workshop/workshop-resource/target%20group/4.png)

![Target group bước 5](/images/5-Workshop/workshop-resource/target%20group/5.png)

![Target group bước 6](/images/5-Workshop/workshop-resource/target%20group/6.png)

![Target group bước 7](/images/5-Workshop/workshop-resource/target%20group/7.png)

## Ảnh ALB

![ALB bước 1](/images/5-Workshop/workshop-resource/alb/1.png)

![ALB bước 2](/images/5-Workshop/workshop-resource/alb/2.png)

![ALB bước 3](/images/5-Workshop/workshop-resource/alb/3.png)

![ALB bước 4](/images/5-Workshop/workshop-resource/alb/4.png)

![ALB bước 5](/images/5-Workshop/workshop-resource/alb/5.png)

![ALB bước 6](/images/5-Workshop/workshop-resource/alb/6.png)

![ALB bước 7](/images/5-Workshop/workshop-resource/alb/7.png)

![ALB bước 8](/images/5-Workshop/workshop-resource/alb/8.png)

![ALB bước 9](/images/5-Workshop/workshop-resource/alb/9.png)

![ALB bước 10](/images/5-Workshop/workshop-resource/alb/10.png)