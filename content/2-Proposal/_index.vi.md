---
title: "Bản đề xuất"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

Phần này trình bày đề xuất dự án kỹ thuật em dự kiến triển khai trong kỳ thực tập và giá trị thực tế mang lại cho nhóm.

# MyFit - Nền tảng Quản lý Fitness
## Giải pháp AWS Cloud toàn diện cho Theo dõi Sức khỏe và Tập luyện Cá nhân

## **1. Tổng quan dự án**

MyFit là nền tảng công nghệ toàn diện được thiết kế để đồng hành cùng người dùng trong hành trình chăm sóc sức khỏe và quản lý tập luyện. Để mang lại trải nghiệm mượt mà và đáng tin cậy nhất, hệ thống được xây dựng dựa trên 3 nền tảng cốt lõi:

* **Trải nghiệm người dùng (Frontend):** Giao diện ứng dụng trực quan, thân thiện, giúp người dùng dễ dàng theo dõi tiến độ, chỉ số cá nhân và tương tác với các tính năng.  
* **Hệ thống xử lý trung tâm (Backend):** Nền tảng xử lý dữ liệu mạnh mẽ, đảm bảo tính chính xác, đồng bộ hóa theo thời gian thực và bảo mật tối đa thông tin của người dùng.  
* **Hạ tầng vận hành (Cloud Infrastructure):** Hệ thống được triển khai hoàn toàn trên nền tảng điện toán đám mây AWS.

Với định hướng ứng dụng các dịch vụ đám mây(Cloud Managed Services), MyFit không chỉ tối ưu hóa chi phí vận hành mà còn cam kết mang đến một hệ thống hoạt động ổn định 24/7. Kiến trúc này đảm bảo ứng dụng luôn sẵn sàng mở rộng quy mô linh hoạt để đáp ứng sự gia tăng không ngừng của lượng người dùng trong tương lai mà không làm gián đoạn trải nghiệm.

## **2. Mục tiêu**

### **2.1. Mục tiêu tổng thể:**

* Xây dựng hệ thống fitness app có khả năng phục vụ đồng thời mobile/web.  
* Xây dựng nền tảng fitness hoạt động ổn định trên hạ tầng của AWS.  
* Đảm bảo tính sẵn sàng và khả năng scale theo tài nguyên cloud.  
* Đảm bảo trải nghiệm người dùng xuyên suốt từ đăng nhập đến theo dõi chỉ số sức khỏe  
* Thiết lập quy trình deploy rõ ràng, có thể lặp lại và giảm lỗi vận hành

### **2.2. Mục tiêu cụ thể về đầu ra:**

* API backend bảo mật bằng JWT Cognito  
* Frontend truy cập qua CloudFront, tải nhanh và ổn định  
* Dashboard/biểu đồ theo dõi sức khỏe và dữ liệu tập luyện  
* Quy trình deploy infra và app tách biệt, có khả năng theo dõi trạng thái rollout

## **3. Vấn đề cần giải quyết**

Các vấn đề thực tế dự án cần xử lý:

* **Vấn đề tích hợp:** frontend, backend và hạ tầng cần đồng bộ cấu hình môi trường  
* **Vấn đề bảo mật:** tránh lộ credentials, kiểm soát truy cập API, hạn chế public resource không cần thiết  
* **Vấn đề vận hành:** cần quan sát log/health để phát hiện lỗi sớm khi deploy  
* **Vấn đề mở rộng:** đảm bảo hệ thống chịu tải tốt khi số lượng người dùng tăng

## **4. Kiến trúc giải pháp**

### **4.1. Ý tưởng và mục tiêu**

**Bối cảnh và bài toán**

Hệ thống được xây dựng cho nhu cầu quản lý sức khỏe cá nhân và kế hoạch tập luyện.

*Hệ thống dùng để làm gì:*

* Quản lý hồ sơ người dùng và đồng bộ thông tin đăng nhập  
* Theo dõi chỉ số cơ thể, tính toán chỉ số sức khỏe  
* Quản lý kế hoạch tập luyện, session và nhật ký tập  
* Quản lý dữ liệu dinh dưỡng theo bữa và theo ngày

*Khách hàng là ai:*

* Người dùng cá nhân cần theo dõi sức khỏe và luyện tập

*Giải quyết vấn đề gì:*

* Thống nhất dữ liệu sức khỏe trong một nền tảng duy nhất  
* Giảm thao tác thủ công bằng API và ứng dụng realtime theo nhu cầu người dùng  
* Đảm bảo hệ thống có thể triển khai, vận hành và mở rộng trên AWS

*Use-case gắn với FCAJ/AWS:*

* Đây là use-case cloud-native rõ ràng, bám sát managed services AWS  
* Không lệch chủ đề vì tập trung vào triển khai ứng dụng trên hạ tầng AWS có bảo mật, scale và monitoring

**Mục tiêu cụ thể và tiêu chí thành công**

*Đầu ra mong muốn:*

* Ứng dụng frontend phục vụ qua CloudFront  
* Backend API chạy ổn định trên ECS Fargate  
* Xác thực người dùng qua Cognito Hosted UI và JWT  
* Logging tập trung qua CloudWatch

*Tiêu chí đánh giá thành công:*

* Người dùng đăng nhập thành công và gọi được các API chính  
* Các luồng cốt lõi workout, health metrics, nutrition hoạt động end-to-end  
* ECS service rollout thành công và đạt trạng thái stable  
* Có thể truy vết lỗi nhanh qua log và health check

### **4.2. Kiến trúc hệ thống:**

![Project Architecture Diagram](/images/proposal/project-architecture-diagram.png)

### **4.3. Luồng dữ liệu chính:**

* **Xác thực:** Mobile app kết nối trực tiếp với Amazon Cognito để quản lý định danh và đăng nhập.  
* **Truy cập & Phân phối:** Yêu cầu từ người dùng đi qua Route 53 (DNS) đến CloudFront (CDN).  
* **Phân nhánh Request:** CloudFront tải giao diện tĩnh từ S3 Frontend Bucket (đối với web) hoặc định tuyến các request API qua ALB.  
* **Xử lý Backend:** ALB cân bằng tải và chuyển API request đến các container Spring Boot đang chạy trên ECS Fargate.  
* **Khởi tạo Task:** ECS Fargate lấy container image từ ECR và truy xuất các thông tin bảo mật (DB password, API key) từ Secrets Manager.  
* **Lưu trữ & Dữ liệu:** Fargate thực hiện logic nghiệp vụ, đọc/ghi dữ liệu vào RDS PostgreSQL và thao tác file với S3 Media Bucket.

### **4.4. Lựa chọn dịch vụ AWS và lý do:**

Các dịch vụ hiện dùng trong dự án:

* **Amazon CloudFront:** Phân phối nội dung (CDN), giảm độ trễ, gom chung endpoint public cho cả frontend và API routing.  
* **Amazon S3:** Lưu trữ static frontend và các tệp media một cách bền vững với chi phí thấp.  
* **Application Load Balancer (ALB):** Đảm nhiệm cân bằng tải HTTP/HTTPS cho các dịch vụ backend chạy trên ECS.  
* **Amazon ECS Fargate:** Chạy các container backend theo mô hình managed, giúp hệ thống tự động mở rộng mà không cần quản lý server vật lý.  
* **Amazon RDS PostgreSQL:** Cơ sở dữ liệu quan hệ được quản lý toàn diện (managed), hoàn toàn phù hợp với các nghiệp vụ lưu trữ dữ liệu có tính ràng buộc cao.  
* **Amazon Bedrock:** Tích hợp chatbot AI thông minh cho ứng dụng để hỗ trợ tương tác với người dùng.  
* **Amazon Cognito:** Cung cấp giải pháp xác thực người dùng, giảm thiểu thời gian và chi phí tự xây dựng hệ thống quản lý danh tính (auth).  
* **Amazon ECR:** Lưu trữ và quản lý an toàn các image container của backend.  
* **Amazon CloudWatch:** Nơi tập trung log của toàn hệ thống, hỗ trợ giám sát hiệu suất và cảnh báo vận hành.  
* **AWS Route 53 và ACM:** Quản lý domain và cung cấp/tự động gia hạn TLS certificate để đảm bảo truy cập an toàn qua giao thức HTTPS.

*Lý do không chọn Lambda/API Gateway ở giai đoạn hiện tại:*

* Backend hiện là ứng dụng Spring Boot nguyên khối, phù hợp mô hình container dài hạn trên ECS  
* Giảm công sức tách nhỏ thành serverless functions trong giai đoạn đầu  
* Tối ưu thời gian delivery và đơn giản hóa vận hành ban đầu

### **4.5. Bảo mật và IAM cơ bản:** 

*Nguyên tắc áp dụng:*

* Principle of Least Privilege cho role runtime  
* Không hard-code access key trong source  
* Hạn chế public resource ở lớp dữ liệu

*Triển khai bảo mật hiện có:*

* ECS Task Execution Role dùng policy chuẩn để pull image/log  
* ECS Task Role chỉ cấp quyền đọc ghi media bucket cần thiết  
* Secret DB lấy từ Secrets Manager thay vì hard-code  
* RDS đặt private subnet, không public  
* ALB giới hạn traffic vào từ CloudFront prefix list  
* Backend chỉ chấp nhận access token hợp lệ từ Cognito.

### **4.6. Khả năng mở rộng và vận hành:** 

*Scale:*

* ECS auto scaling theo CPU, cấu hình hiện tại min 2 và max 4 tasks  
* Kiến trúc tách lớp CloudFront và ECS để scale frontend/backend độc lập

*Logging và Monitoring:*

* CloudWatch Logs cho backend container  
* RDS export log để theo dõi truy vấn/lỗi DB  
* ALB health check endpoint để phát hiện instance không khỏe

### **4.7. Quy trình Quản lý và Triển khai tự động (CI/CD & IaC)**

Để tối ưu hóa thời gian vận hành và giảm thiểu sai sót thủ công, hệ thống áp dụng phương pháp quản lý hạ tầng bằng mã và luồng triển khai tự động:

* **Quản lý hạ tầng (IaC) với AWS CloudFormation:** Toàn bộ cấu hình tài nguyên AWS được định nghĩa và quản lý tập trung bằng code, đảm bảo tính nhất quán và khả năng đồng bộ nhanh chóng giữa các môi trường.  
* **Luồng triển khai liên tục (CI/CD):** Áp dụng luồng **Dev → GitHub Actions → Amazon ECS** để tự động hóa quá trình phát hành ứng dụng:  
  1. **Dev:** Cập nhật và đẩy (push) mã nguồn lên GitHub.  
  2. **GitHub Actions:** Tự động kích hoạt luồng build Docker image và đẩy (push) lên kho lưu trữ Amazon ECR.  
  3. **Amazon ECS:** GitHub Actions gọi lệnh cập nhật service trên ECS. ECS Fargate tự động kéo image mới nhất và tiến hành thay thế các container cũ mà không làm gián đoạn trải nghiệm người dùng (Rolling Update)

## **5. Code Snippet**

### **5.1 Dockerfile Backend**

![Docker File](/images/proposal/docker%20file.png)

### **5.2 CDK Route API Qua CloudFront**

![CDK Route API via CloudFront](/images/proposal/cdk%20route%20api%20via%20cloudfront.png)

### **5.3 Script Deploy App**

![Deploy App Script](/images/proposal/deploy%20app%20scrip.png)  

### **5.4 Khởi tạo Stack**  

![CDK Infra Code](/images/proposal/cdk%20infra%20code.png)  

### **5.5 Ảnh app:**  

![Web App 1](/images/proposal/web%20app1.png)  
![Web App 2](/images/proposal/web%20app2.png)  
![Web App 3](/images/proposal/web%20app3.png)  
![Web App 4](/images/proposal/web%20app4.png)  
![Web App 5](/images/proposal/web%20app5.png)

## **6. Ngân sách dự kiến**

Region: us-east-1:

| Hạng mục | Dịch vụ | Cấu hình thực tế | Ước tính/tháng |
| :---- | :---- | :---- | :---- |
| Frontend CDN | CloudFront | 1 distribution, ~10GB transfer/tháng | ~1-5 USD |
| Static hosting + Media | S3 | 2 buckets (frontend + media), ~10GB | ~0.5-2 USD |
| Backend compute | ECS Fargate | 2 tasks × 0.25 vCPU × 0.5 GB RAM, chạy 24/7 | ~15-20 USD |
| Database | RDS PostgreSQL | t4g.micro, Multi-AZ, GP3 20GB, PostgreSQL 15 | ~30-35 USD |
| Container registry | ECR | 1 repo, ~1GB image storage | ~0.1-1 USD |
| Logging & Monitoring | CloudWatch | Container Insights + logs 1 tuần retention | ~5-15 USD |
| Secrets Manager | Secrets Manager | 2 secret (DB credentials & Bedrock API) | ~1 USD |
| Load Balancer | ALB | 1 ALB, ~10 LCU/tháng | ~18-22 USD |
| Xác thực người dùng | Cognito | MAU ≤ 50,000 (free tier) | ~0 USD |
| DNS + Certificate | Route 53 + ACM | 1 hosted zone, ACM miễn phí | ~0.5-1 USD |
| Chatbot | Bedrock |  |  |
| **Tổng tham chiếu** | **Toàn hệ thống** |  | **~71-100 USD/tháng** |

**Lưu ý:**

* Cấu hình không dùng NAT Gateway (natGateways=0), tiết kiệm ~32 USD/tháng so với kiến trúc có NAT  
* Chi phí thực tế phụ thuộc traffic, dung lượng log, data transfer và số người dùng hoạt động
