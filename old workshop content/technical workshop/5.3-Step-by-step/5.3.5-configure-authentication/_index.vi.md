---
title : "Cấu hình xác thực và routing"
date : 2024-01-01
weight : 5
chapter : false
pre : " <b> 5.3.5. </b> "
---

Cấu hình listener rule trên ALB để mỗi path có đúng cơ chế truy cập.

Phần này dùng để cấu hình các listener rule riêng cho ứng dụng. Ở bước 5.3.4, ALB wizard đã tạo sẵn rule mặc định forward về target group; tại đây chúng ta thêm hành vi routing cho các path của ứng dụng.

## Rules

1. Public routes:
   - Path: `/`
   - Path: `/health`
   - Action: Forward đến target group
2. Route cần đăng nhập:
   - Path: `/dashboard`
   - Action: Authenticate bằng Cognito rồi forward
3. Route admin:
   - Path: `/admin`
   - Action: Authenticate bằng Cognito rồi forward
   - Backend phải kiểm tra claim/group admin trước khi cho truy cập

## Thông số Cognito cần nhập vào ALB

Dùng các giá trị từ bước 5.3.2:
- User Pool
- App Client
- Hosted UI domain

## Kiểm tra

- Truy cập `/` không cần đăng nhập phải hoạt động.
- Truy cập `/dashboard` phải redirect sang Cognito login.
- Truy cập `/admin` bằng user không thuộc admin phải bị từ chối.

## Ảnh listener rule

![ALB auth bước 11](/images/5-Workshop/workshop-resource/alb/11.png)

Path `/` và `/health` chỉ forward thẳng đến target group. Path `/dashboard` và `/admin` sẽ dùng Cognito authentication trước khi forward, nên chỉ người đã đăng nhập mới truy cập được.