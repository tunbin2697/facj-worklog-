---
title : "Tổng quan Workshop"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---
title : "Tổng quan Workshop"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---

Workshop này mô tả mô hình bảo mật web app trên AWS:
- Amazon EC2 chạy backend.
- Amazon Cognito quản lý đăng nhập người dùng.
- Application Load Balancer (ALB) áp chính sách truy cập theo đường dẫn.

Kết quả mong muốn:
- `/` truy cập công khai.
- `/dashboard` yêu cầu đăng nhập.
- `/admin` yêu cầu quyền admin.

{{% notice info %}}
Trang này giữ ở mức tổng quan ngắn gọn. Vui lòng mở từng mục bên dưới để xem chi tiết.
{{% /notice %}}

## Mục lục

1. [5.2 Điều kiện tiên quyết](../5.2-prerequiste/)
2. [5.3 Hướng dẫn từng bước](../5.3-step-by-step/)
3. [5.4 Kiểm thử và đánh giá kết quả](../5.4-test-evaluate/)
4. [5.5 Dọn dẹp tài nguyên](../5.5-cleanup/)

## Tóm tắt kiến trúc

1. Người dùng gửi request vào ALB.
2. ALB kiểm tra rule theo path.
3. Path bảo vệ sẽ chuyển hướng sang Cognito Hosted UI.
4. Sau khi đăng nhập, ALB forward vào EC2 kèm identity headers.

![Sơ đồ kiến trúc workshop](/images/5-Workshop/workshop-resource/diagram/aws%20architecture%20diagram%20workshop.png)

![Sơ đồ EC2 private](/images/5-Workshop/workshop-resource/diagram/private%20ec2%20-%20aws%20architeture%20diagram%20workshop.png)

CLI (optional): use AWS CLI to automate user/group creation for larger demos.
