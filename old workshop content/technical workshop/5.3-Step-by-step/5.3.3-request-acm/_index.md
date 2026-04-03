---
title : "Request ACM Certificate"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3.3. </b> "
---

Request a public ACM certificate for the ALB authentication domain and validate it with DNS.

## Steps

1. Open AWS Certificate Manager and request a public certificate.
2. Enter the domain name for the Cognito/auth endpoint.
3. Keep DNS validation enabled and request the certificate.
4. Create the Route 53 validation record.
5. Wait until the certificate status becomes `Issued`.
6. Copy the certificate ARN for the ALB HTTPS listener.

## Screenshot flow

![ACM step 1](/images/5-Workshop/workshop-resource/acm/1.png)

![ACM step 2](/images/5-Workshop/workshop-resource/acm/2.png)

![ACM step 3](/images/5-Workshop/workshop-resource/acm/3.png)

![ACM step 4](/images/5-Workshop/workshop-resource/acm/4.png)

![ACM step 5](/images/5-Workshop/workshop-resource/acm/5.png)

![ACM step 6](/images/5-Workshop/workshop-resource/acm/6.png)

![ACM step 7](/images/5-Workshop/workshop-resource/acm/7.png)

## Notes

- The certificate must cover the domain used by the ALB login flow.
- Use the issued certificate when configuring the HTTPS listener.