---
title : "Dọn dẹp tài nguyên"
date : 2024-01-01
weight : 5
chapter : false
pre : " <b> 5.5. </b> "
---

# 5.5 Dọn dẹp tài nguyên

Xóa toàn bộ tài nguyên của workshop để tránh phát sinh chi phí ngoài ý muốn.

Phần này giả định các tài nguyên của workshop đã được tạo từ các bước trước đó. Bộ ảnh bên dưới dùng bộ ảnh cleanup hiện tại để bạn đối chiếu với môi trường của mình trước khi xóa.

## Thứ tự khuyến nghị

1. Xóa listener rules trên ALB nếu bạn muốn giữ load balancer thêm một lúc.
2. Xóa Application Load Balancer.
3. Xóa Target Group.
4. Terminate EC2 backend instance.
5. Xóa Cognito User Pool và app client.
6. Xóa ACM certificate nếu bạn đã tạo chứng chỉ cho lab này.
7. Xóa CloudWatch log groups tạo cho workshop.
8. Xóa IAM role và security group chỉ dùng cho lab.
9. Xóa VPC và các subnet, route table, gateway hoặc endpoint còn lại sau khi đã xóa hết tài nguyên phụ thuộc.

{{% notice warning %}}
Trước khi xóa IAM role hoặc security group, hãy xác nhận không có tài nguyên dùng chung phụ thuộc vào chúng.
{{% /notice %}}

## 1. Xóa listener rules trên ALB

Nếu load balancer vẫn còn, hãy xóa listener rules trước để ALB không còn routing riêng cho ứng dụng và có thể xóa sạch hơn.

## 2. Xóa Application Load Balancer

![Xóa ALB](/images/5-Workshop/workshop-resource/cleanup/clean%20alb.png)

Sau khi đã xóa listener rules, hãy xóa ALB để dừng toàn bộ traffic đi vào hệ thống và tránh phát sinh chi phí.

## 3. Xóa Target Group

![Xóa Target Group](/images/5-Workshop/workshop-resource/cleanup/clean%20targetgoup.png)

Khi ALB không còn dùng đến nữa, hãy xóa target group để dọn sạch cấu hình load balancing còn lại.

## 4. Terminate EC2 backend instance

![Terminate EC2](/images/5-Workshop/workshop-resource/cleanup/clean%20ec2.png)

Terminate EC2 sau khi target group đã được xóa. Đây là bước kết thúc phần compute và giúp tránh chi phí chạy instance.

## 5. Xóa Cognito User Pool và app client

![Xóa Cognito](/images/5-Workshop/workshop-resource/cleanup/clean%20cognito.png)

Chỉ xóa user pool khi bạn không cần phần đăng nhập của workshop nữa. Xóa luôn app client sẽ giúp dọn dẹp cấu hình Cognito đầy đủ hơn.

## 6. Xóa ACM certificate

![Xóa ACM](/images/5-Workshop/workshop-resource/cleanup/cleanup%20acm.png)

Nếu bạn đã request ACM certificate cho HTTPS, hãy xóa nó sau khi ALB đã được gỡ bỏ. ACM certificate không mất phí nhưng nên được dọn sạch để tài khoản gọn gàng hơn.

## 7. Xóa CloudWatch log groups

Xóa các log group do workshop tạo ra để không còn log cũ trong CloudWatch.

## 8. Xóa IAM role và security group

Xóa các IAM role và security group chỉ dùng cho workshop khi chắc chắn không còn tài nguyên nào phụ thuộc vào chúng.

## 9. Xóa VPC và phần mạng còn lại

![Xóa VPC](/images/5-Workshop/workshop-resource/cleanup/clean%20vpc.png)

Xóa VPC ở bước cuối cùng, sau khi đã gỡ hết subnet, route table, internet gateway, NAT gateway, và endpoint còn lại. Đây là bước kết thúc phần dọn dẹp mạng của workshop.

## Kiểm tra sau dọn dẹp

- Không còn EC2 đang chạy
- Không còn ALB hoặc Target Group
- Không còn Cognito User Pool của workshop
- Không còn ACM certificate của workshop
- Không còn CloudWatch log group dành riêng cho workshop
- Không còn VPC hoặc tài nguyên mạng còn sót lại của workshop
