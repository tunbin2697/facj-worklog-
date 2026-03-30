---
title : "Tạo Cognito User Pool"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.3.2. </b> "
---

Tạo tài nguyên Cognito phục vụ đăng nhập và phân quyền theo nhóm.

## Các bước

1. Mở Amazon Cognito -> User pools -> Create user pool.
2. Chọn phương thức đăng nhập (email hoặc username).
3. Tạo App client:
	- Không bật client secret.
	- Callback URL: `https://<alb-dns>/oauth2/idpresponse`.
	- Sign-out URL: `https://<alb-dns>`.
4. Cấu hình Hosted UI domain.
5. Tạo người dùng test:
	- `user1` (user thường)
	- `admin1` (user quản trị)
6. Tạo group `admin` và thêm `admin1` vào group.

## Giá trị cần lưu lại

- User Pool ID
- App Client ID
- Hosted UI Domain

Các giá trị này sẽ được dùng ở bước cấu hình rule xác thực trên ALB.