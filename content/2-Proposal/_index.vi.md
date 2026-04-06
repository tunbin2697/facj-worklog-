---
title: "Proposal"
date:  2026-04-03
weight: 2
slug: "myfit-aws-architecture"
chapter: false
pre: " <b> 2. </b> "
---

## 1. Tổng quan dự án

MyFit là nền tảng công nghệ toàn diện được thiết kế để đồng hành cùng người dùng trong hành trình chăm sóc sức khỏe và quản lý tập luyện. Để mang lại trải nghiệm mượt mà và đáng tin cậy nhất, hệ thống được xây dựng dựa trên 3 nền tảng cốt lõi:

* Trải nghiệm người dùng (Frontend): Giao diện ứng dụng trực quan, thân thiện, giúp người dùng dễ dàng theo dõi tiến độ, chỉ số cá nhân và tương tác với các tính năng.
* Hệ thống xử lý trung tâm (Backend): Nền tảng xử lý dữ liệu mạnh mẽ, đảm bảo tính chính xác, đồng bộ hóa theo thời gian thực và bảo mật tối đa thông tin của người dùng.
* Hạ tầng vận hành (Cloud Infrastructure): Hệ thống được triển khai hoàn toàn trên nền tảng điện toán đám mây AWS.

Với định hướng ứng dụng các dịch vụ đám mây (Cloud Managed Services), MyFit không chỉ tối ưu hóa chi phí vận hành mà còn cam kết mang đến một hệ thống hoạt động ổn định 24/7. Kiến trúc này đảm bảo ứng dụng luôn sẵn sàng mở rộng quy mô linh hoạt để đáp ứng sự gia tăng không ngừng của lượng người dùng trong tương lai mà không làm gián đoạn trải nghiệm.

---

## 2. Mục tiêu

### 2.1. Mục tiêu tổng thể:

* Xây dựng hệ thống fitness app có khả năng phục vụ đồng thời mobile/web.
* Xây dựng nền tảng fitness hoạt động ổn định trên hạ tầng của AWS.
* Đảm bảo tính sẵn sàng và khả năng scale theo tài nguyên cloud.
* Đảm bảo trải nghiệm người dùng xuyên suốt từ đăng nhập đến theo dõi chỉ số sức khỏe
* Thiết lập quy trình deploy rõ ràng, có thể lặp lại và giảm lỗi vận hành

### 2.2. Mục tiêu cụ thể về đầu ra:

* API backend bảo mật bằng JWT Cognito
* Frontend truy cập qua CloudFront, tải nhanh và ổn định
* Dashboard/biểu đồ theo dõi sức khỏe và dữ liệu tập luyện
* Quy trình deploy infra và app tách biệt, có khả năng theo dõi trạng thái rollout

---

## 3. Vấn đề cần giải quyết

Các vấn đề thực tế dự án cần xử lý:

* Vấn đề tích hợp: frontend, backend và hạ tầng cần đồng bộ cấu hình môi trường
* Vấn đề bảo mật: tránh lộ credentials, kiểm soát truy cập API, hạn chế public resource không cần thiết
* Vấn đề vận hành: cần quan sát log/health để phát hiện lỗi sớm khi deploy
* Vấn đề mở rộng: đảm bảo hệ thống chịu tải tốt khi số lượng người dùng tăng

---

## 4. Kiến trúc giải pháp

### 4.1. Ý tưởng và mục tiêu

**Bối cảnh và bài toán**

Hệ thống được xây dựng cho nhu cầu quản lý sức khỏe cá nhân và kế hoạch tập luyện.

**Hệ thống dùng để làm gì:**

* Quản lý hồ sơ người dùng và đồng bộ thông tin đăng nhập
* Theo dõi chỉ số cơ thể, tính toán chỉ số sức khỏe
* Quản lý kế hoạch tập luyện, session và nhật ký tập
* Quản lý dữ liệu dinh dưỡng theo bữa và theo ngày

**Khách hàng là ai:**

* Người dùng cá nhân cần theo dõi sức khỏe và luyện tập

**Giải quyết vấn đề gì:**

* Thống nhất dữ liệu sức khỏe trong một nền tảng duy nhất
* Giảm thao tác thủ công bằng API và ứng dụng realtime theo nhu cầu người dùng
* Đảm bảo hệ thống có thể triển khai, vận hành và mở rộng trên AWS

**Use-case gắn với FCAJ/AWS:**

* Đây là use-case cloud-native rõ ràng, bám sát managed services AWS
* Không lệch chủ đề vì tập trung vào triển khai ứng dụng trên hạ tầng AWS có bảo mật, scale và monitoring

**Mục tiêu cụ thể và tiêu chí thành công**

**Đầu ra mong muốn:**

* Ứng dụng frontend phục vụ qua CloudFront
* Backend API chạy ổn định trên ECS Fargate
* Xác thực người dùng qua Cognito Hosted UI và JWT
* Logging tập trung qua CloudWatch

**Tiêu chí đánh giá thành công:**

* Người dùng đăng nhập thành công và gọi được các API chính
* Các luồng cốt lõi workout, health metrics, nutrition hoạt động end-to-end
* ECS service rollout thành công và đạt trạng thái stable
* Có thể truy vết lỗi nhanh qua log và health check

---

### 4.2. Kiến trúc hệ thống:

![kiến trúc hệ thống](/images/2-Proposal/image11.png)

---

### 4.3. Luồng dữ liệu chính:

* Tầng Xác thực: Mobile app kết nối trực tiếp với Amazon Cognito để quản lý định danh và đăng nhập.
* Tầng Truy cập & Phân phối: Yêu cầu đi qua Route 53 (DNS) đến CloudFront (CDN). CloudFront tải giao diện từ S3 Frontend Bucket hoặc định tuyến API qua ALB.
* Tầng Xử lý Backend: ALB cân bằng tải, chuyển request đến container Spring Boot trên ECS Fargate. ECS Fargate lấy image từ ECR và truy xuất thông tin từ Secrets Manager.
* Tầng Lưu trữ & Dữ liệu: Fargate thực hiện logic, đọc/ghi vào RDS PostgreSQL và thao tác file với S3 Media Bucket. Amazon Bedrock được tích hợp làm chatbot AI hỗ trợ người dùng.

---

### 4.4. Lựa chọn dịch vụ AWS và lý do:

**Các dịch vụ hiện dùng trong dự án:**

* Amazon CloudFront: Phân phối nội dung (CDN), giảm độ trễ, gom chung endpoint public cho cả frontend và API routing.
* Amazon S3: Lưu trữ static frontend và các tệp media một cách bền vững với chi phí thấp.
* Application Load Balancer (ALB): Đảm nhiệm cân bằng tải HTTP/HTTPS cho các dịch vụ backend chạy trên ECS.
* Amazon ECS Fargate: Chạy các container backend theo mô hình managed, giúp hệ thống tự động mở rộng mà không cần quản lý server vật lý.
* Amazon RDS PostgreSQL: Cơ sở dữ liệu quan hệ được quản lý toàn diện (managed), hoàn toàn phù hợp với các nghiệp vụ lưu trữ dữ liệu có tính ràng buộc cao.
* Amazon Bedrock: Tích hợp chatbot AI thông minh cho ứng dụng để hỗ trợ tương tác với người dùng.
* Amazon Cognito: Cung cấp giải pháp xác thực người dùng, giảm thiểu thời gian và chi phí tự xây dựng hệ thống quản lý danh tính (auth).
* Amazon ECR: Lưu trữ và quản lý an toàn các image container của backend.
* Amazon CloudWatch: Nơi tập trung log của toàn hệ thống, hỗ trợ giám sát hiệu suất và cảnh báo vận hành.
* AWS Route 53 và ACM: Quản lý domain và cung cấp/tự động gia hạn TLS certificate để đảm bảo truy cập an toàn qua giao thức HTTPS.

**Lý do không chọn Lambda/API Gateway ở giai đoạn hiện tại:**

* Backend hiện là ứng dụng Spring Boot nguyên khối, phù hợp mô hình container dài hạn trên ECS
* Giảm công sức tách nhỏ thành serverless functions trong giai đoạn đầu
* Tối ưu thời gian delivery và đơn giản hóa vận hành ban đầu

---

### 4.5. Bảo mật và IAM cơ bản:

**Nguyên tắc áp dụng:**

* Principle of Least Privilege cho role runtime
* Không hard-code access key trong source
* Hạn chế public resource ở lớp dữ liệu

**Triển khai bảo mật hiện có:**

* ECS Task Execution Role dùng policy chuẩn để pull image/log
* ECS Task Role chỉ cấp quyền đọc ghi media bucket cần thiết
* Secret DB lấy từ Secrets Manager thay vì hard-code
* RDS đặt private subnet, không public
* ALB giới hạn traffic vào từ CloudFront prefix list
* Backend chỉ chấp nhận access token hợp lệ từ Cognito

---

### 4.6. Khả năng mở rộng và vận hành:

**Scale:**

* ECS auto scaling theo CPU, cấu hình hiện tại min 2 và max 4 tasks
* Kiến trúc tách lớp CloudFront và ECS để scale frontend/backend độc lập

**Logging và Monitoring:**

* CloudWatch Logs cho backend container
* RDS export log để theo dõi truy vấn/lỗi DB
* ALB health check endpoint để phát hiện instance không khỏe

---

### 4.7. Quy trình Quản lý và Triển khai tự động (CI/CD & IaC)

Để tối ưu hóa thời gian vận hành và giảm thiểu sai sót thủ công, hệ thống áp dụng phương pháp quản lý hạ tầng bằng mã và luồng triển khai tự động:

* Quản lý hạ tầng (IaC) với AWS CloudFormation: Toàn bộ cấu hình tài nguyên AWS được định nghĩa và quản lý tập trung bằng code, đảm bảo tính nhất quán và khả năng đồng bộ nhanh chóng giữa các môi trường.

* Luồng triển khai liên tục (CI/CD):

  1. Dev: Cập nhật và đẩy (push) mã nguồn lên GitHub.
  2. GitHub Actions: Build Docker image và push lên Amazon ECR.
  3. Amazon ECS: Cập nhật service → rolling update không downtime.

---

## 5. Code Snippet

### 5.1 Dockerfile Backend

![S3 bucket properties tab](/images/2-Proposal/image5.png)


### 5.2 CDK Route API Qua CloudFront


![S3 bucket properties tab](/images/2-Proposal/image4.png)


### 5.3 Script Deploy App

![S3 bucket properties tab](/images/2-Proposal/image2.png)
![S3 bucket properties tab](/images/2-Proposal/image10.png)



### 5.4 Khởi tạo Stack


![S3 bucket properties tab](/images/2-Proposal/image6.png)


### 5.5 Ảnh app:

![App](/images/2-Proposal/image9.png)
![S3 bucket properties tab](/images/2-Proposal/image1.png)
![S3 bucket properties tab](/images/2-Proposal/image8.png)
![S3 bucket properties tab](/images/2-Proposal/image7.png)
![S3 bucket properties tab](/images/2-Proposal/image3.png)


---

## 6. Ngân sách dự kiến

**Region: us-east-1**

| Hạng mục      | Dịch vụ         | Cấu hình  | Ước tính/tháng |
| ------------- | --------------- | --------- | -------------- |
| Frontend CDN  | CloudFront      | ~10GB     | 1–5 USD        |
| Storage       | S3              | 2 buckets | 0.5–2 USD      |
| Backend       | ECS             | 2 tasks   | 15–20 USD      |
| Database      | RDS             | t4g.micro | 30–35 USD      |
| ECR           | Registry        | 1GB       | 0.1–1 USD      |
| Logging       | CloudWatch      | logs      | 5–15 USD       |
| Secrets       | Secrets Manager | 2 secrets | ~1 USD         |
| Load Balancer | ALB             | 1 ALB     | 18–22 USD      |
| Cognito       | Auth            | free tier | 0 USD          |
| DNS + SSL     | Route53 + ACM   |           | 0.5–1 USD      |

**Tổng: ~71–100 USD/tháng**

**Lưu ý:**

* Không dùng NAT Gateway → tiết kiệm ~32 USD/tháng
* Chi phí phụ thuộc traffic

---

## 7. Rủi Ro Và Giải Pháp Giảm Thiểu

| Rủi ro          | Tác động  | Mức ưu tiên | Giải pháp       |
| --------------- | --------- | ----------- | --------------- |
| Lộ thông tin    | Cao       | P0          | Secrets Manager |
| Sai path deploy | Trung-Cao | P0          | Pre-check       |
| OAuth mismatch  | Cao       | P0          | Sync env        |
| Health check    | Trung     | P1          | Chuẩn hóa       |
| Chi phí tăng    | Trung     | P1          | Budget alarm    |
---