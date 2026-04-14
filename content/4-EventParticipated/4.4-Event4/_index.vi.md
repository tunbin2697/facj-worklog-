---
title: "Cloud Mastery 2026 #3 - Networking, Security, and IAM on AWS"
date: 2026-04-11
weight: 4
chapter: false
pre: " <b> 4.4. </b> "
---

## Báo cáo tóm tắt: "Cloud Mastery 2026 #3"

## Mục tiêu sự kiện

* Xây dựng nền tảng thực tiễn trong việc thiết kế và bảo mật hạ tầng mạng trên AWS bằng VPC, Subnet và Gateway.
* Hiểu rõ bộ dịch vụ AWS về bảo vệ Network & Application để phòng chống DDoS và các lỗ hổng web.
* Tìm hiểu best practices của IAM, quản lý multi-account với SSO và các cơ chế kiểm soát quyền nâng cao.

## Diễn giả

* **Lam An Thinh & Nguyen Phan Quoc Viet** - Session: Networking on AWS  
* **Lam Tuan Kiet** - Session: AWS Network & Application Protection  
* **Huynh Hoang Long & Dang Thi Minh Thu** - Session: Identity & Access Management  

## Nội dung chính

### Session 1: Networking on AWS

Session đầu tiên giới thiệu các thành phần cốt lõi của networking trên AWS, tập trung vào cách kiểm soát "blast radius" và quản lý luồng traffic trong VPC.

**Key takeaways:**
* **Thành phần chính:** Bao gồm VPC & CIDR, Subnets (định nghĩa kích thước mạng), Internet Gateway (IGW) và Route Tables để định tuyến traffic.
* **Kiến trúc NAT Gateway:** Cho phép các resource trong Private Subnet truy cập internet (để update, cài package) nhưng chặn kết nối inbound từ bên ngoài. Sử dụng Source NAT (SNAT) và Port Address Translation (PAT).
* **Security Group vs NACL:**
  * Security Group: firewall dạng stateful ở level instance (ENI), tự động cho phép traffic trả về.
  * NACL: firewall dạng stateless ở level subnet, rule chạy theo thứ tự và cần config cả inbound/outbound.
* **Cô lập mạng (Network Isolation):** Thiết kế subnet + routing hợp lý giúp bảo vệ resource nhạy cảm khỏi internet nhưng vẫn giữ được outbound cần thiết.

![vpc architecture](/images/4-Event/e4vpc.jpg "actual")

---

### Session 2: Identity & Access Management (IAM)

Session thứ hai tập trung vào kiểm soát định danh và quyền truy cập, nhấn mạnh nguyên tắc "Least Privilege".

**Key takeaways:**
* **Best practices IAM:**
  * Bật MFA cho tất cả user
  * Xóa access key của root
  * Dùng IAM Role thay vì user credentials
  * Tránh dùng wildcard (`*`) trong policy
* **AWS IAM Identity Center (SSO):**  
  Cung cấp portal truy cập tập trung cho multi-account, ưu tiên hơn access key dài hạn vì sử dụng credential tạm thời.
* **Quản trị ở quy mô lớn:**
  * SCP (Service Control Policies): định nghĩa quyền tối đa cho account
  * Permission Boundaries: giới hạn quyền của IAM User/Role để tránh privilege escalation
* **Automation & Monitoring:**
  * IAM Access Analyzer: phát hiện resource bị share ra ngoài
  * Rotation credential tự động bằng Secrets Manager + Lambda

![iam boundary](/images/4-Event/e4iam.jpg "IAM Boundary")

---

### Session 3: AWS Network & Application Protection

Session cuối tập trung vào bảo vệ perimeter và giảm thiểu các mối đe dọa từ bên ngoài.

**Key takeaways:**
* **AWS WAF (Web Application Firewall):**
  * Bảo vệ khỏi SQL Injection, XSS
  * Filter HTTP/HTTPS request
  * Tích hợp với CloudFront, ALB, API Gateway
* **AWS Shield:**
  * Bảo vệ DDoS
  * Standard: bảo vệ cơ bản tự động
  * Advanced: nâng cao, có hỗ trợ từ Shield Response Team và cost protection
* **AWS Network Firewall:**
  * Firewall managed ở level VPC
  * Hỗ trợ IPS, filtering stateful/stateless
* **AWS Firewall Manager:**
  * Quản lý policy bảo mật tập trung cho multi-account
  * Đồng bộ rule cho WAF, Shield, Network Firewall

![waf architecture](/images/4-Event/e4waf.jpg "WAF Architecture")

---

## Kết quả và giá trị đạt được

Sự kiện cung cấp roadmap toàn diện để thiết kế hệ thống AWS an toàn:

* Thành thạo thiết kế network isolation với VPC và multi-tier subnet
* Xây dựng chiến lược phòng thủ nhiều lớp (instance, subnet, application)
* Quản lý identity trong môi trường multi-account phức tạp bằng IAM nâng cao

![actual event image](/images/4-Event/ws3team.jpg "Event audience")

Session nhấn mạnh rằng bảo mật cloud hiệu quả là sự kết hợp của:
* Network boundary chặt chẽ
* Bảo vệ application chuyên sâu
* Mô hình zero-trust trong quản lý identity

> Tổng kết: Cloud Mastery 2026 #3 mang lại kiến thức giá trị cao từ networking cơ bản đến quản trị bảo mật ở quy mô tổ chức.
