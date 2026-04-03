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

## Ảnh minh họa

![Cognito bước 1](/images/5-Workshop/workshop-resource/cognito/1.png)

![Cognito bước 2](/images/5-Workshop/workshop-resource/cognito/2.png)

![Cognito bước 3](/images/5-Workshop/workshop-resource/cognito/3.png)

![Cognito bước 4](/images/5-Workshop/workshop-resource/cognito/4.png)

![Cognito bước 5](/images/5-Workshop/workshop-resource/cognito/5.png)

![Cognito bước 6](/images/5-Workshop/workshop-resource/cognito/6.png)

![Cognito bước 7](/images/5-Workshop/workshop-resource/cognito/7.png)

![Cognito bước 8](/images/5-Workshop/workshop-resource/cognito/8.png)

![Cognito bước 9](/images/5-Workshop/workshop-resource/cognito/9.png)

### Thêm admin user vào group

![Thêm admin user 1](/images/5-Workshop/workshop-resource/result/add%20admin%20user%201.png)

![Thêm admin user 2](/images/5-Workshop/workshop-resource/result/add%20admin%20user%202.png)

![Thêm admin user 3](/images/5-Workshop/workshop-resource/result/add%20admin%20user%203.png)