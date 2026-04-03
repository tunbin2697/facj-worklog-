---
title: "Tổng quan Workshop"
date: 2026-04-03
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---

## 5.1 Deploy Fitness Platfrom in AWS Cloud enviroment.

Workshop này hướng dẫn bạn triển khai và xác thực Deploy Fitness Platfrom in AWS Cloud enviroment.

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
