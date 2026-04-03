---
title: "2.6 Route 53 and ACM"
weight: 26
---

# 2.6 Route 53 and ACM

This stack uses DNS validation for the certificate and alias records for the frontend and backend hostnames.

## Content

1. Use the hosted zone
2. Request the ACM certificate
3. Create the alias records
4. What the stack expects

## 2.6.1 Use the hosted zone

1. Open Route 53.
2. Open Hosted zones.
3. Select the hosted zone for `myfit.click`.
4. Confirm that the hosted zone exists before you request the certificate.
5. If you are creating a new hosted zone, use a descriptive name that matches the domain exactly.

## 2.6.2 Request the ACM certificate

1. Open the ACM console in `us-east-1`.
2. Request a public certificate.
3. Add `myfit.click` as the primary domain.
4. Add `api.myfit.click` as a subject alternative name.
5. Choose DNS validation.
6. Create the validation records in Route 53.
7. Wait until the certificate is issued.
8. Use a certificate description in your deployment notes because ACM does not expose a full free-form description field.

## 2.6.3 Create the alias records

### 2.6.3.1 Frontend alias

1. Create an A record for `myfit.click`.
2. Point it to the CloudFront distribution.
3. Use alias routing.
4. Use the CloudFront distribution ID `E3D9E3SXXZACHN` if you are validating against the live stack.

### 2.6.3.2 Backend alias

1. Create an A record for `api.myfit.click`.
2. Point it to the ALB.
3. Use alias routing.
4. Use the ALB DNS name `MyfitI-Backe-Rh0SwQcGp3vQ-385341478.us-east-1.elb.amazonaws.com` if you are validating against the live stack.

## 2.6.4 What the stack expects

- Frontend domain: `myfit.click`
- Backend domain: `api.myfit.click`
- ACM certificate validated by the hosted zone
- DNS alias records in the same zone
