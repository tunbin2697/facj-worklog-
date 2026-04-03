Phase 5: Frontend & CDN - Detailed Manual Recreation Guide
Based on Your Current MyfitInfraStack Configuration

Step 13: Create S3 Buckets (10-12 minutes)
A. Create Frontend Bucket
Navigate to S3 Console
Go to S3 Console 

Create Bucket
Click "Create bucket"
Bucket name: myfit-frontend-UNIQUE-SUFFIX (must be globally unique)
Your current: myfitinfrastack-frontendbucketefe2e19c-qjcbf75eyxbx
Example: myfit-frontend-20240403-xyz789
AWS Region: us-east-1
Object Ownership
Object Ownership: ACLs disabled (Bucket owner enforced)
This matches your current configuration
Block Public Access Settings
Block all public access: ✅ CHECK all boxes
Block public ACLs: ✅ Enabled
Ignore public ACLs: ✅ Enabled
Block public policy: ✅ Enabled
Restrict public buckets: ✅ Enabled
This matches your current security configuration
Bucket Versioning
Bucket Versioning: ✅ Enable
This matches your current configuration
Default Encryption
Default encryption: Server-side encryption with Amazon S3 managed keys (SSE-S3)
Bucket Key: Disable
This matches your current encryption setup
Advanced Settings
Object Lock: Disable
Create Bucket
Click "Create bucket"
Configure Bucket Policy (After CloudFront Creation)
Note: You'll add this policy after creating CloudFront distribution

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::YOUR-ACCOUNT-ID:distribution/YOUR-DISTRIBUTION-ID"
                }
            }
        },
        {
            "Sid": "AllowCloudFrontOriginAccessIdentity",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity YOUR-OAI-ID"
            },
            "Action": [
                "s3:GetBucketAcl",
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME"
        },
        {
            "Sid": "AllowCloudFrontOriginAccessIdentityGetObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity YOUR-OAI-ID"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
        }
    ]
}

B. Create Media Bucket
Create Bucket
Click "Create bucket"
Bucket name: crawl.fitness or your preferred media bucket name
AWS Region: ap-southeast-1 (matches your current setup) or us-east-1 for consistency
Configure Same Settings as Frontend Bucket
Object Ownership: ACLs disabled
Block all public access: ✅ Enabled
Versioning: ✅ Enable
Encryption: SSE-S3
Object Lock: Disable
Configure CORS (After Creation)
Go to "Permissions" tab
Scroll to "Cross-origin resource sharing (CORS)"
Click "Edit"
Add CORS configuration based on your domains:
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "PUT",
            "POST",
            "DELETE",
            "HEAD"
        ],
        "AllowedOrigins": [
            "https://myfit.click",
            "https://*.cloudfront.net",
            "http://localhost:8081",
            "http://localhost:19006"
        ],
        "ExposeHeaders": [
            "ETag",
            "x-amz-meta-custom-header"
        ]
    }
]

Step 14: Create CloudFront Distribution (15-20 minutes)
Navigate to CloudFront Console
Go to CloudFront Console 

A. Create Distribution
Click "Create distribution"
B. Origins Configuration
Origin 1: S3 Frontend Bucket
Origin domain: Select your frontend S3 bucket
Name: S3-Frontend-Origin (or auto-generated)
Origin access: Origin access control settings (recommended)
Origin access control: Create new OAC
Name: myfit-frontend-oac
Origin type: S3
Signing behavior: Sign requests
Additional settings: Leave defaults
Add Second Origin: Application Load Balancer
Click "Add origin"
Origin domain: Your ALB DNS name from Phase 4
Example: myfit-backend-alb-123456789.us-east-1.elb.amazonaws.com
Name: ALB-Backend-Origin (or auto-generated)
Protocol: HTTP only (matches your current setup)
HTTP port: 80
HTTPS port: 443
Origin SSL protocols: TLSv1.2
Connection attempts: 3
Connection timeout: 10 seconds
Response timeout: 30 seconds
Keep-alive timeout: 5 seconds
C. Default Cache Behavior (Frontend/SPA)
Path pattern: Default (*)
Origin and origin groups: S3 Frontend Origin
Viewer protocol policy: Redirect HTTP to HTTPS
Allowed HTTP methods: GET, HEAD (for static content)
Cached HTTP methods: GET, HEAD
Compress objects automatically: Yes
Cache policy: Create custom or use managed policy
Origin request policy: None
D. Additional Cache Behaviors (API Routes)
Behavior 1: /api/*
Click "Add behavior"
Path pattern: /api/*
Origin: ALB Backend Origin
Viewer protocol policy: Redirect HTTP to HTTPS
Allowed HTTP methods: GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE
Cached HTTP methods: GET, HEAD
Compress objects: Yes
Cache policy: CachingDisabled (for API calls)
Origin request policy: CORS-S3Origin or AllViewer
Behavior 2: /auth/*
Path pattern: /auth/*
Same settings as /api/*
Behavior 3: /user/*
Path pattern: /user/*
Same settings as /api/*
Behavior 4: /test/*
Path pattern: /test/*
Same settings as /api/*
E. Distribution Settings
Price class: Use all edge locations (PriceClass_All)
Alternate domain name (CNAME): myfit.click (your custom domain)
Custom SSL certificate:
Use existing certificate: arn:aws:acm:us-east-1:294568841239:certificate/6d940e53-bb45-41cd-aee3-7acecc26b5ac
Or request new certificate for your domain
Security policy: TLSv1.2_2021
Supported HTTP versions: HTTP/2 and HTTP/1.1
Default root object: index.html
Standard logging: Off
IPv6: On
F. Create CloudFront Function for SPA Routing
Go to CloudFront Functions 
Click "Create function"
Name: spa-rewrite-function
Description: Rewrite URLs for SPA routing
Function code:
function handler(event) {
    var request = event.request;
    var uri = request.uri;
    
    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    }
    // Check whether the URI is missing a file extension.
    else if (!uri.includes('.')) {
        request.uri = '/index.html';
    }
    
    return request;
}

Save function
Test function with sample events
Publish function
G. Associate Function with Distribution
Go back to your CloudFront distribution
Edit the default cache behavior
Function associations:
Viewer request: Select your spa-rewrite-function
Save changes
H. Create Distribution
Review all settings
Click "Create distribution"
Note the Distribution ID for S3 bucket policy
Wait for deployment (10-15 minutes)
I. Update S3 Bucket Policy
After distribution is created, update your S3 bucket policy with the actual values:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-ACTUAL-BUCKET-NAME/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::YOUR-ACCOUNT-ID:distribution/YOUR-ACTUAL-DISTRIBUTION-ID"
                }
            }
        }
    ]
}

Step 15: Upload Frontend Files (5 minutes)
Upload to S3
Build your frontend application
Go to your frontend S3 bucket
Upload all files from your build/dist folder
Set appropriate cache-control headers:
Static assets (JS, CSS, images): public, max-age=31536000
index.html: public, max-age=0, must-revalidate
Configuration Summary Based on Your Current Stack
Key Differences from Standard Setup:
Dual Origins: Your CloudFront serves both S3 (frontend) and ALB (backend API)
Multiple API Paths: /api/*, /auth/*, /user/*, /test/* all route to backend
SPA Function: CloudFront Function handles SPA URL rewriting
Custom Domain: myfit.click with ACM certificate
Media Bucket: Separate bucket (crawl.fitness) in different region
Security Configuration:
S3 buckets have all public access blocked
CloudFront uses Origin Access Control (OAC) for S3 access
HTTPS redirect enforced on all content
TLS 1.2 minimum for SSL connections
Performance Optimizations:
Global edge locations (PriceClass_All)
HTTP/2 enabled
Compression enabled for all content
Appropriate caching policies for static vs dynamic content