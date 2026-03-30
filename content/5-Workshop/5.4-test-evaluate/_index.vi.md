---
title : "Kiểm thử và đánh giá kết quả"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

# 5.4 Kiểm thử và đánh giá kết quả

Trang này chứa các bước kiểm thử, checklist và hướng dẫn xử lý sự cố để xác nhận bản triển khai workshop (ALB + Cognito + EC2) trong mục 5.3.

Lưu các giá trị sau để phục vụ debug và cấu hình:
- Tên DNS của ALB
- Tên Target Group
- EC2 instance id
- Cognito User Pool id
- Cognito App Client id
- Cognito domain

## Ca kiểm thử & kết quả kỳ vọng

- Public path `/`
  - Mở `http://<alb-dns>/`
  - Kỳ vọng: HTTP 200, nội dung `Public`

- Path bảo vệ `/dashboard`
  - Mở `http://<alb-dns>/dashboard`
  - Kỳ vọng: chuyển hướng tới Cognito Hosted UI; sau khi đăng nhập, HTTP 200 và backend trả thông tin người dùng

- Path admin `/admin`
  - Mở `http://<alb-dns>/admin`
  - Kỳ vọng: chuyển hướng khi chưa đăng nhập; user thường bị từ chối; user admin được cho phép (backend kiểm tra group)

## Checklist xác minh

1. Listener rules trên ALB
   - Hành động mặc định cho `/` forward đến Target Group (không auth).
   - Rule cho `/dashboard` dùng `authenticate-cognito` rồi forward.
   - Rule cho `/admin` dùng `authenticate-cognito` rồi forward.

2. Cấu hình Cognito
   - User Pool và App Client tồn tại (không dùng client secret cho browser flow).
   - Callback/redirect URLs được cấu hình đúng.
   - Domain Cognito đã cấu hình.

3. Backend & Target Group
   - EC2 instance đang chạy và đã đăng ký vào Target Group.
   - Health checks đang OK.
   - Backend đọc header `x-amzn-oidc-identity` được ALB chèn.

4. Security groups
   - Security Group của ALB cho phép traffic đến EC2 security group trên port ứng dụng (ví dụ 80).

## Kiểm tra nhanh (thay `<alb-dns>`)

```bash
curl -i http://<alb-dns>/
curl -i http://<alb-dns>/dashboard
curl -i http://<alb-dns>/admin
```

Dùng trình duyệt để kiểm tra luồng redirect tới Cognito Hosted UI và trao đổi token.

## Xử lý sự cố

- Không thấy redirect tới Cognito: kiểm tra listener rule sử dụng `authenticate-cognito` và cấu hình App Client/domain Cognito.
- Backend trả `Guest` hoặc không có identity: xác nhận ALB chèn OIDC headers và backend đọc `x-amzn-oidc-identity`.
- Health checks lỗi: kiểm tra ứng dụng đang lắng nghe cổng đúng và security group cho phép traffic từ ALB.

## Giám sát & log

- Log ứng dụng EC2 (CloudWatch) — cấu hình CloudWatch Agent hoặc stream logs.
- ALB access logs (bật lưu vào S3) để audit request.
- Cognito logs (CloudWatch) cho debug xác thực.

## Dọn dẹp

Sau khi kiểm thử, dọn dẹp tài nguyên theo [5.5 Dọn dẹp tài nguyên](../5.5-cleanup/).
