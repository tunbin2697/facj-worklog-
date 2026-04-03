---
title: "Phase 5 - Frontend and CDN"
date: 2026-04-03
weight: 5
chapter: false
pre: " <b> 5.3.5. </b> "
---

## 1. Set up ACM certificate for custom domain

- Open the AWS Console search bar, type `acm`, and select `Certificate Manager`.
![Open ACM from search](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/1.png)

- In ACM, click `Request certificate`.
![ACM request certificate entry](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/2.png)

- Select `Request a public certificate`, then click `Next`.
![Choose public certificate](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/3.png)

- Enter fully qualified domain name as `<your-domain>` (example: `auth.example.com`).
- Keep export option as `Disable export`.
- Select validation method `DNS validation`.
- Keep key algorithm `RSA 2048`.
![Request public certificate form](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/4.png)

- Scroll down and click `Request`.
![Submit ACM request](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/5.png)

- Open the created certificate and check domain validation details.
- If Route 53 hosts your domain, click `Create records in Route 53`.
- If not, manually create the shown `CNAME name` and `CNAME value` in your DNS provider.
- Initial status is typically `Pending validation`.
![ACM pending validation](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/6.png)

- Wait until certificate status becomes `Issued`.
- Copy and keep the certificate `ARN` for CloudFront in later steps.
![ACM issued certificate](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/acm/7.png)

## 2. Create frontend S3 bucket

- Open S3 Console - Buckets - `Create bucket`.
![S3 create bucket screen 1](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/create1.png)

- Set `Bucket type` to `General purpose`.
- Enter `Bucket name` as `<your-frontend-bucket-name>`.
- Keep `Object Ownership` as `ACLs disabled (Bucket owner enforced)`.
- Keep `Block all public access` enabled.
![S3 create bucket screen 2](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/create2.png)

- Keep `Bucket Versioning` enabled.
- Keep `Default encryption` as `SSE-S3`.
- Keep `Object Lock` disabled.
- Click `Create bucket`.
![S3 create bucket screen 3](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/create3.png)

- Open the created bucket - `Permissions` tab.
- Verify `Block public access` remains enabled.
- Click `Edit` in `Bucket policy`.
![S3 permissions screen](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/craete4.png)

- Add a CloudFront read policy for this bucket.
- Set `AWS:SourceArn` to your CloudFront distribution ARN pattern:
	`arn:aws:cloudfront::<account-id>:distribution/<your-distribution-id>`
- Save changes.

Use the following bucket policy JSON:

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

- Open `Objects` tab and upload your frontend build output.
- Verify `index.html` and `assets` are present.
![S3 objects result screen](/images/workshop/Phase%205%20Frontend%20and%20CDN/s3/s3%20result.png)

## 3. Create CloudFront distribution for frontend

- Open CloudFront Console - Distributions - `Create distribution`.
![CloudFront distribution list](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%201.png)

- Select plan: `Free`.
![CloudFront choose plan](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%202.png)

- Enter `Distribution name` as `<your-distribution-name>`.
- Select `Distribution type`: `Single website or app`.
![CloudFront get started](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%203.png)

- Select `Origin type`: `Amazon S3`.
- Select your frontend S3 bucket as origin.
![CloudFront specify S3 origin](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%204.png)

- Keep security protections enabled.
- Click `Create distribution`.
![CloudFront distribution result](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%205.png)

- Wait for status to become `Deployed`.
- Copy CloudFront domain name as `<your-cloudfront-domain>`.

## 4. Add custom domain and TLS certificate

- Open your distribution - `General` tab - click `Add domain`.
![CloudFront add domain entry](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20add%20domain%201.png)

- Enter `Domains to serve` as `<your-domain>`.
- Click `Next`.
![CloudFront configure domains](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20add%20domain%202.png)

- Select the ACM certificate from section `1`.
- Click `Next`.
![CloudFront select TLS certificate](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20add%20domain%203.png)

- Review domain and TLS certificate values.
- Click `Add domains`.
![CloudFront review domain changes](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20add%20domain%204.png)

## 5. Configure default root object

- Open distribution settings and click `Edit`.
![CloudFront edit settings entry](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20root%20object%201.png)

- Enter `Default root object` as `index.html`.
- Save changes.
![CloudFront default root object](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/distribution/create%20distribution%20root%20object%202.png)

## 6. Add ALB origin for backend API

- Open `Origins` tab.
- Click `Create origin`.
![CloudFront origins tab](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/origin/create%20alb%20origin%201.png)

- Enter `Origin domain` as `<your-alb-dns-name>`.
- Select `Protocol`: `HTTP only`.
- Enter `Name` as `<your-backend-origin-name>`.
- Click `Create origin`.
![CloudFront create ALB origin](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/origin/create%20alb%20origin%202.png)

## 7. Add behaviors for API routes

- Open `Behaviors` tab.
- Click `Create behavior`.
![CloudFront behaviors tab](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/behavior/create%20behavior%201.png)

- Enter `Path pattern`: `/api/*`.
- Select `Origin`: `<your-backend-origin>`.
- Select `Compress objects automatically`: `Yes`.
- Select `Viewer protocol policy`: `Redirect HTTP to HTTPS`.
- Select `Allowed HTTP methods`: `GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE`.
![CloudFront behavior basic settings](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/behavior/create%20behavior%202.png)

- Select `Cache policy`: `Managed-CachingDisabled`.
- Select `Origin request policy`: `Managed-AllViewer`.
- Save behavior.
![CloudFront behavior cache settings](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/behavior/create%20behavior%203.png)

- Repeat the same behavior configuration for `/auth/*`, `/user/*`, and `/test/*`.
- Verify all API behaviors point to backend origin and default `(*)` points to S3 origin.
![CloudFront behaviors result](/images/workshop/Phase%205%20Frontend%20and%20CDN/cloudfront/behavior/behavior%20result.png)

## 8. Phase completion checklist

1. Confirm frontend S3 bucket exists and frontend build files are uploaded.
2. Confirm CloudFront distribution status is `Deployed`.
3. Confirm alternate domain name is attached and TLS certificate status is `Issued`.
4. Confirm default root object is `index.html`.
5. Confirm ALB origin protocol policy is `HTTP only`.
6. Confirm API behaviors `/api/*`, `/auth/*`, `/user/*`, `/test/*` use `Managed-CachingDisabled` and `Managed-AllViewer`.
7. Confirm ECS task definition still exposes container `web` on port `8080`.
8. Run AWS CLI command below and verify `CORS_ALLOWED_ORIGINS` includes `https://<your-domain>`.
