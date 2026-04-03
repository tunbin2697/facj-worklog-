---
title: "2.3 ECR repository"
weight: 23
---

# 2.3 ECR repository

The stack imports an existing backend repository named `myfit-backend`. The deployment script pushes the image tag `latest` to that repository.

## Content

1. Create or confirm the repository
2. Image contract used by the stack
3. Validate the repo before deployment

## 2.3.1 Create or confirm the repository

1. Open the ECR console.
2. Choose Repositories.
3. Create repository if `myfit-backend` does not already exist.
4. Set the repository name to `myfit-backend`.
5. Add a description such as `MyFit backend application images`.
6. Keep image tags mutable so repeated deploys can replace `latest`.
7. Keep scanning enabled if your account policy requires it.
8. Create the repository.

## 2.3.2 Image contract used by the stack

- Repository name: `myfit-backend`
- Tag used by deploy: `latest`
- Container port: `8080`

## 2.3.3 Validate the repo before deployment

1. Open the repository.
2. Confirm that the repository URI is available.
3. Make sure the IAM principal running the deployment can push images.
4. Confirm the live repository name matches the value the stack imports.
