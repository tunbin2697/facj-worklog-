---
title: "Tổng quan Workshop"
date: 2026-04-03
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---

## 5.1 Cloud-Native Fitness App Deployment on AWS

Workshop này hướng dẫn bạn triển khai và xác thực Cloud-Native Fitness App Deployment on AWS.

## Tổng quan dự án

MyFit là nền tảng fitness cloud-native phục vụ theo dõi sức khỏe, quản lý kế hoạch tập luyện, ghi log dinh dưỡng và tích hợp trợ lý AI.
Hệ thống gồm:

1. Frontend cho trải nghiệm người dùng và theo dõi tiến độ.
2. Backend API xử lý nghiệp vụ và bảo mật dữ liệu.
3. Hạ tầng AWS để triển khai, mở rộng và giám sát vận hành.

## Dự án được triển khai lên AWS như thế nào

Quy trình triển khai theo mô hình container CI/CD:

1. Developer đẩy source code lên GitHub.
2. GitHub Actions build backend container image.
3. Image được push lên Amazon ECR.
4. Amazon ECS Fargate cập nhật service theo rolling deployment.
5. Lưu lượng được định tuyến qua CloudFront đến S3 (frontend) và ALB/ECS (API).

## Sơ đồ kiến trúc

![kiến trúc hệ thống](/images/2-Proposal/image11.png)

## Bảng lựa chọn dịch vụ AWS

| Dịch vụ | Lý do sử dụng |
| --- | --- |
| CloudFront | Phân phối toàn cầu, giảm độ trễ, gom endpoint public |
| S3 | Lưu trữ frontend tĩnh và media |
| ALB | Cân bằng tải HTTP/HTTPS đến ECS |
| ECS Fargate | Chạy container theo mô hình managed, auto scaling |
| RDS PostgreSQL | Cơ sở dữ liệu quan hệ managed cho dữ liệu nghiệp vụ |
| Cognito | Xác thực và quản lý danh tính người dùng |
| ECR | Lưu trữ image container |
| CloudWatch | Tập trung log và giám sát hệ thống |
| Route 53 + ACM | DNS và quản lý chứng chỉ TLS |
| Secrets Manager | Lưu trữ secret an toàn cho runtime |

## Mục tiêu

Xây dựng một hệ thống theo hướng production gồm:

1. Nền tảng mạng VPC
2. Cơ sở dữ liệu PostgreSQL trên RDS
3. Backend container chạy trên ECS Fargate
4. Frontend trên S3 + CloudFront
5. Xác thực bằng Cognito
6. Tích hợp Bedrock API qua Secrets Manager

## Tóm tắt kiến trúc

1. Frontend đi qua CloudFront và S3.
2. API đi từ CloudFront vào ALB và ECS service.
3. ECS backend kết nối RDS và S3.
4. Cognito phụ trách xác thực người dùng.
5. Bedrock key (tùy chọn) được inject từ Secrets Manager.

## Cấu trúc workshop

1. [5.2 Prerequisite - IAM roles và policy baseline](../5.2-prerequiste/)
2. [5.3 Hướng dẫn từng bước theo phase](../5.3-step-by-step/)
3. [5.4 Kết quả ứng dụng](../5.4-app-result/)
4. [5.5 Triển khai CloudFormation bằng CDK và script](../5.5-cloudformation-deploy-cdk-and-script/)
5. [5.6 Dọn dẹp tài nguyên](../5.6-clean-up-resource/)

## Nguồn chuẩn để đối chiếu

- Stack hạ tầng: [myfit-infra/lib/myfit-infra-stack.ts (đã include trong mục 5.5)](../5.5-cloudformation-deploy-cdk-and-script/)
- Script triển khai hạ tầng: [myfit-infra/scripts/deploy-infra.ps1 (đã include trong mục 5.5)](../5.5-cloudformation-deploy-cdk-and-script/)
