---
title: "Phase 5 - Frontend và CDN"
date: 2026-04-03
weight: 5
chapter: false
pre: " <b> 5.3.5. </b> "
---

## 1. Thiết lập chứng chỉ ACM cho custom domain

- Mở thanh tìm kiếm trong AWS Console, nhập `acm`, và chọn `Certificate Manager`.
![Open ACM from search](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/1.png)

- Trong ACM, bấm `Request certificate`.
![ACM request certificate entry](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/2.png)

- Chọn `Request a public certificate`, sau đó bấm `Next`.
![Choose public certificate](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/3.png)

- Nhập fully qualified domain name là `<your-domain>` (ví dụ: `auth.example.com`).
- Giữ export option là `Disable export`.
- Chọn validation method `DNS validation`.
- Giữ key algorithm `RSA 2048`.
![Request public certificate form](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/4.png)

- Cuộn xuống và bấm `Request`.
![Submit ACM request](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/5.png)

- Mở certificate vừa tạo và kiểm tra chi tiết domain validation.
- Nếu Route 53 đang host domain của bạn, bấm `Create records in Route 53`.
- Nếu không, tạo thủ công `CNAME name` và `CNAME value` hiển thị trong nhà cung cấp DNS.
- Trạng thái ban đầu thường là `Pending validation`.
![ACM pending validation](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/6.png)

- Chờ đến khi certificate có trạng thái `Issued`.
- Sao chép và lưu lại certificate `ARN` để dùng cho CloudFront ở các bước sau.
![ACM issued certificate](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/7.png)

## 2. Tạo frontend S3 bucket

- Mở S3 Console - Buckets - `Create bucket`.
![S3 create bucket screen 1](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/create1.png)

- Đặt `Bucket type` là `General purpose`.
- Nhập `Bucket name` là `<your-frontend-bucket-name>`.
- Giữ `Object Ownership` là `ACLs disabled (Bucket owner enforced)`.
- Giữ `Block all public access` ở trạng thái bật.
![S3 create bucket screen 2](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/create2.png)

- Giữ `Bucket Versioning` ở trạng thái bật.
- Giữ `Default encryption` là `SSE-S3`.
- Giữ `Object Lock` ở trạng thái tắt.
- Bấm `Create bucket`.
![S3 create bucket screen 3](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/create3.png)

- Mở bucket vừa tạo - tab `Permissions`.
- Xác nhận `Block public access` vẫn đang bật.
- Bấm `Edit` tại `Bucket policy`.
![S3 permissions screen](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/craete4.png)


- Thêm policy để CloudFront đọc object trong bucket.
- Đặt `AWS:SourceArn` theo mẫu ARN CloudFront distribution:
	`arn:aws:cloudfront::<account-id>:distribution/<your-distribution-id>`
- Lưu thay đổi.

Sử dụng bucket policy JSON sau:

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity <YOUR_CLOUDFRONT_OAI_ID>"
			},
			"Action": [
				"s3:GetBucket*",
				"s3:GetObject*",
				"s3:List*"
			],
			"Resource": [
				"arn:aws:s3:::<your-s3-bucket-name>",
				"arn:aws:s3:::<your-s3-bucket-name>/*"
			]
		},
		{
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity <YOUR_CLOUDFRONT_OAI_ID>"
			},
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::<your-s3-bucket-name>/*"
		},
		{
			"Sid": "AllowCloudFrontServicePrincipal",
			"Effect": "Allow",
			"Principal": {
				"Service": "cloudfront.amazonaws.com"
			},
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::<your-s3-bucket-name>/*",
			"Condition": {
				"ArnLike": {
					"AWS:SourceArn": "arn:aws:cloudfront::YOUR_ACCOUNT_ID:distribution/<your-cloudfront-name>"
				}
			}
		}
	]
}
```
![S3 bucket policy screen](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/create5.png)

- Mở tab `Objects` và upload frontend build output.
- Xác nhận đã có `index.html` và thư mục `assets`.
![S3 objects result screen](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/s3%20result.png)

## 3. Tạo CloudFront distribution cho frontend

- Mở CloudFront Console - Distributions - `Create distribution`.
![CloudFront distribution list](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%201.png)

- Chọn plan: `Free`.
![CloudFront choose plan](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%202.png)

- Nhập `Distribution name` là `<your-distribution-name>`.
- Chọn `Distribution type`: `Single website or app`.
![CloudFront get started](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%203.png)

- Chọn `Origin type`: `Amazon S3`.
- Chọn frontend S3 bucket của bạn làm origin.
![CloudFront specify S3 origin](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%204.png)

- Giữ security protections ở trạng thái bật.
- Bấm `Create distribution`.
![CloudFront distribution result](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%205.png)

- Chờ trạng thái chuyển sang `Deployed`.
- Sao chép CloudFront domain name là `<your-cloudfront-domain>`.

## 4. Thêm custom domain và TLS certificate

- Mở distribution - tab `General` - bấm `Add domain`.
![CloudFront add domain entry](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20add%20domain%201.png)

- Nhập `Domains to serve` là `<your-domain>`.
- Bấm `Next`.
![CloudFront configure domains](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20add%20domain%202.png)

- Chọn ACM certificate đã tạo ở mục `1`.
- Bấm `Next`.
![CloudFront select TLS certificate](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20add%20domain%203.png)

- Kiểm tra lại domain và TLS certificate.
- Bấm `Add domains`.
![CloudFront review domain changes](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20add%20domain%204.png)

## 5. Cấu hình default root object

- Mở phần settings của distribution và bấm `Edit`.
![CloudFront edit settings entry](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20root%20object%201.png)

- Nhập `Default root object` là `index.html`.
- Lưu thay đổi.
![CloudFront default root object](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20root%20object%202.png)

## 6. Thêm ALB origin cho backend API

- Mở tab `Origins`.
- Bấm `Create origin`.
![CloudFront origins tab](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/origin/create%20alb%20origin%201.png)

- Nhập `Origin domain` là `<your-alb-dns-name>`.
- Chọn `Protocol`: `HTTP only`.
- Nhập `Name` là `<your-backend-origin-name>`.
- Bấm `Create origin`.
![CloudFront create ALB origin](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/origin/create%20alb%20origin%202.png)

## 7. Tạo behaviors cho API routes

- Mở tab `Behaviors`.
- Bấm `Create behavior`.
![CloudFront behaviors tab](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/behavior/create%20behavior%201.png)

- Nhập `Path pattern`: `/api/*`.
- Chọn `Origin`: `<your-backend-origin>`.
- Chọn `Compress objects automatically`: `Yes`.
- Chọn `Viewer protocol policy`: `Redirect HTTP to HTTPS`.
- Chọn `Allowed HTTP methods`: `GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE`.
![CloudFront behavior basic settings](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/behavior/create%20behavior%202.png)

- Chọn `Cache policy`: `Managed-CachingDisabled`.
- Chọn `Origin request policy`: `Managed-AllViewer`.
- Lưu behavior.
![CloudFront behavior cache settings](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/behavior/create%20behavior%203.png)

- Lặp lại cấu hình behavior tương tự cho `/auth/*`, `/user/*`, và `/test/*`.
- Xác nhận tất cả API behaviors trỏ về backend origin và default `(*)` trỏ về S3 origin.
![CloudFront behaviors result](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/behavior/behavior%20result.png)

## 8. Checklist hoàn tất phase

1. Xác nhận frontend S3 bucket đã có và đã upload frontend build files.
2. Xác nhận CloudFront distribution status là `Deployed`.
3. Xác nhận alternate domain name đã gắn và TLS certificate status là `Issued`.
4. Xác nhận default root object là `index.html`.
5. Xác nhận ALB origin protocol policy là `HTTP only`.
6. Xác nhận API behaviors `/api/*`, `/auth/*`, `/user/*`, `/test/*` dùng `Managed-CachingDisabled` và `Managed-AllViewer`.
7. Xác nhận ECS task definition vẫn expose container `web` ở port `8080`.
8. Chạy lệnh AWS CLI bên dưới và xác nhận `CORS_ALLOWED_ORIGINS` có `https://<your-domain>`.
