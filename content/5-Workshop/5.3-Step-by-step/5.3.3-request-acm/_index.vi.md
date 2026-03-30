---
title : "Yêu cầu chứng chỉ ACM"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3.3. </b> "
---

Yêu cầu một ACM public certificate cho domain dùng trong luồng đăng nhập của ALB và xác thực bằng DNS.

## Các bước

1. Mở AWS Certificate Manager và request public certificate.
2. Nhập domain dùng cho endpoint Cognito/auth.
3. Giữ DNS validation và gửi yêu cầu cấp chứng chỉ.
4. Tạo bản ghi Route 53 để xác thực.
5. Chờ trạng thái certificate chuyển sang `Issued`.
6. Sao chép certificate ARN để dùng cho HTTPS listener của ALB.

## Chuỗi ảnh minh họa

![ACM bước 1](/images/5-Workshop/workshop-resource/acm/1.png)

![ACM bước 2](/images/5-Workshop/workshop-resource/acm/2.png)

![ACM bước 3](/images/5-Workshop/workshop-resource/acm/3.png)

![ACM bước 4](/images/5-Workshop/workshop-resource/acm/4.png)

![ACM bước 5](/images/5-Workshop/workshop-resource/acm/5.png)

![ACM bước 6](/images/5-Workshop/workshop-resource/acm/6.png)

![ACM bước 7](/images/5-Workshop/workshop-resource/acm/7.png)

## Ghi chú

- Certificate phải bao phủ domain dùng trong luồng đăng nhập của ALB.
- Dùng certificate đã Issued khi cấu hình HTTPS listener.