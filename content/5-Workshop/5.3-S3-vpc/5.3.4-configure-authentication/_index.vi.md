---
title : "Cấu hình xác thực và routing"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.3.4. </b> "
---

Cấu hình listener rule trên ALB để mỗi path có đúng cơ chế truy cập.

## Rules

1. Public route:
   - Path: `/`
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