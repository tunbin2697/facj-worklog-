---
title: "Phase 6 - Xác thực và DNS"
date: 2026-04-03
weight: 6
chapter: false
pre: " <b> 5.3.6. </b> "
---

## 1. Cấu hình Google identity provider

- Mở Amazon Cognito Console ở region `us-east-1`.
- Mở user pool của bạn và vào `Social and external providers`.
- Bấm `Add identity provider`.
![Cognito social providers entry](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/google%20provider1.png)

- Chọn provider type `Google`.
- Nhập Google OAuth `Client ID` và `Client secret` từ Google Cloud Console.
- Đặt authorized scopes: `openid email profile`.
- Lưu thay đổi.

- Xác nhận provider `Google` đã tồn tại.
- Xác nhận mapping có các trường chính:
  - `email -> email`
  - `email_verified -> email_verified`
  - `name -> name`
  - `picture -> picture`
  - `username -> sub`
![Cognito Google provider details](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/google%20provider2.png)
![Cognito Google provider mappings](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/google%20provider3.png)

## 2. Tạo User Pool Cognito và App Client

- Mở Amazon Cognito Console ở region `us-east-1`.
- Mở `User pools`.
- Bấm `Create user pool`.
![Cognito user pools entry](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%201.png)

- Chọn application type `Single-page application (SPA)`.
- Nhập application name: `myfit cognito app client`.
- Trong sign-in identifiers, chọn `Email`.
![Cognito app setup basic](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%202.png)

- Giữ `Enable self-registration` ở trạng thái bật.
- Đặt required attributes gồm `email`.
- Nhập return URL: `https://myfit.click`.
- Bấm `Create user directory`.
![Cognito app setup and return URL](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%203.png)

## 3. Cấu hình managed login pages

- Mở user pool của bạn, sau đó mở `App clients`.
- Chọn app client `Fitme-cognito-web-auth-service`.
- Mở `Edit managed login pages configuration`.
![Cognito managed login callback URLs](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%204.png)

- Đặt `Allowed callback URLs`:
  - `http://localhost:8081/callback`
  - `https://myfit.click/callback`
  - `myfit://callback`
- Đặt `Default redirect URL`: `https://myfit.click/callback`.
- Đặt `Allowed sign-out URLs`:
  - `http://localhost:8081/logout`
  - `https://myfit.click/logout`
  - `myfit://logout`
- Trong identity providers, chọn `Google`.
- Trong OAuth 2.0 grant types, chọn `Authorization code grant`.
![Cognito managed login sign-out and OAuth flow](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%205.png)

- Trong OpenID Connect scopes, chọn:
  - `email`
  - `openid`
  - `profile`
- Bấm `Save changes`.
![Cognito managed login OIDC scopes](/images/workshop/Phase%206%20Authentication%20and%20DNS/cognito/create%20user%20pool%206.png)

## 4. Kiểm tra Hosted Zone và bản ghi Route 53

> Lưu ý:
> Domain mẫu `myfit.click` trong workshop đã được team đăng ký qua MatBao và chỉ dùng để minh họa.
> Khi tự triển khai, bạn nên dùng domain và DNS zone của riêng bạn.
> Nếu muốn setup dễ hơn, bạn có thể mua domain trực tiếp trên Route 53 (ví dụ `myapp.com`) và dùng domain đó xuyên suốt các bước.

- Mở Route 53 Console - `Hosted zones`.
- Xác nhận hosted zone `myfit.click` tồn tại và type là `Public`.
![Route 53 hosted zones](/images/workshop/Phase%206%20Authentication%20and%20DNS/route53%20dns/create%20hosted%20zone%201.png)

- Mở hosted zone `myfit.click` - `Records`.
- Xác nhận các record chính:
  - Alias `A` record cho `myfit.click` trỏ tới CloudFront domain.
  - Alias `A` record cho `api.myfit.click` trỏ tới ALB domain.
  - ACM validation `CNAME` records cho `myfit.click` và `api.myfit.click` tồn tại.
  - `NS` và `SOA` records mặc định tồn tại.
![Route 53 records list](/images/workshop/Phase%206%20Authentication%20and%20DNS/route53%20dns/create%20hosted%20zone%202.png)

## 5. Danh sách kiểm tra hoàn tất phase

1. Xác nhận Cognito user pool ID là `us-east-1_9AoKPqZO1`.
2. Xác nhận app client ID là `661fm3mj7s5qcmoldri1mem9sr`.
3. Xác nhận callback URLs gồm `http://localhost:8081/callback`, `https://myfit.click/callback`, và `myfit://callback`.
4. Xác nhận sign-out URLs gồm `http://localhost:8081/logout`, `https://myfit.click/logout`, và `myfit://logout`.
5. Xác nhận supported identity provider có `Google`.
6. Xác nhận OAuth flow là `code` và scopes gồm `email`, `openid`, `profile`.
