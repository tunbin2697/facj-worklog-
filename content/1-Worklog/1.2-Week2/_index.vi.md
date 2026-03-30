---
title: "Worklog Tuần 2"
date: 2026-01-12
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

### Mục tiêu tuần 2:

* **Backend**: Tích hợp AWS Cognito vào Spring Security. Xây dựng module `UserProfile`.
* **Frontend**: Triển khai luồng xác thực hoàn chỉnh — từ màn hình đăng nhập đến lưu trữ token và quản lý trạng thái.
* Thiết lập pattern xử lý token an toàn được tái sử dụng xuyên suốt ứng dụng.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --------- | ------------ | --------------- | -------------- |
| 2   | - Nghiên cứu khái niệm AWS Cognito User Pools <br>&emsp; + Cấu hình User Pool: password policy, app clients, PKCE <br>&emsp; + Phân biệt ID Token và Access Token <br>&emsp; + JWT claims: `sub`, `cognito:groups`, `token_use` | 13/01/2026 | 13/01/2026 | <https://docs.aws.amazon.com/cognito/> |
| 3   | - Triển khai **Spring Security** cấu hình JWT <br>&emsp; + Thêm `spring-security-oauth2-resource-server` <br>&emsp; + Cấu hình `SecurityConfig`: stateless, CSRF disabled, CORS enabled <br>&emsp; + Cài đặt Cognito issuer-uri trong `application.properties` <br>&emsp; + Viết `OAuth2TokenValidator` tự định nghĩa — từ chối token có `token_use != "access"` | 14/01/2026 | 14/01/2026 | <https://docs.spring.io/spring-security/> |
| 3   | - Triển khai trích xuất role từ JWT <br>&emsp; + Đọc claim `cognito:groups` → chuyển thành `ROLE_<GROUP>` <br>&emsp; + Cấu hình `@PreAuthorize("hasRole('ADMIN')")` cho admin endpoints <br>&emsp; + Quy tắc phân quyền: public, authenticated, admin-only | 14/01/2026 | 14/01/2026 | |
| 4   | - Xây dựng **UserProfile** entity & repository <br>&emsp; + Các trường: `cognitoId (UNIQUE)`, `email (UNIQUE)`, `username`, `name`, `gender`, `birthdate`, `phoneNumber`, `picture`, `emailVerified` <br>&emsp; + `UserProfileRepository` kế thừa `JpaRepository` | 15/01/2026 | 15/01/2026 | |
| 4   | - Xây dựng **UserProfileService** & **UserProfileController** <br>&emsp; + `POST /user/sync` — upsert profile từ Cognito claims (an toàn IDOR: `cognitoSub` từ JWT `sub`) <br>&emsp; + `GET /user/{id}`, `PUT /user/{id}`, `DELETE /user/{id}` | 15/01/2026 | 15/01/2026 | |
| 5   | - Xây dựng **LoginScreen** cho Frontend <br>&emsp; + Nút "Đăng nhập với AWS Cognito" duy nhất <br>&emsp; + Khởi động PKCE flow qua `expo-auth-session` + `expo-web-browser` <br>&emsp; + Xử lý redirect callback: đổi code → tokens <br>&emsp; + Giải mã ID Token bằng `jwt-decode` để lấy thông tin user | 16/01/2026 | 16/01/2026 | <https://docs.expo.dev/guides/authentication/> |
| 6   | - Xây dựng **authSlice** (Redux) và lưu trữ token <br>&emsp; + State: `isAuthenticated`, `user`, `token`, `refreshToken`, `hasCompletedOnboarding` <br>&emsp; + Actions: `login`, `logout`, `completeOnboarding`, `updateUserProfile` <br>&emsp; + Lưu token vào `expo-secure-store` (mobile) / `localStorage` (web) qua `utils/storage.ts` <br> - Kết nối Axios **request interceptor**: tự động gắn `Authorization: Bearer <token>` | 17/01/2026 | 17/01/2026 | |

### Kết quả đạt được tuần 2:

* **Backend — Security**:
  * Spring Security cấu hình hoàn chỉnh với AWS Cognito làm JWT issuer.
  * `OAuth2TokenValidator` tự định nghĩa chặn ID token — chỉ Access Token được chấp nhận tại API.
  * Phân quyền theo role hoạt động: `ROLE_ADMIN` từ Cognito group cấp quyền admin.
  * Các quy tắc bảo mật được định nghĩa: public health check, authenticated routes, admin-only `/admin/**`.
* **Backend — Module UserProfile**:
  * `POST /user/sync` upsert user từ Cognito JWT claims an toàn, không có lỗ hổng IDOR.
  * Full CRUD (`GET`, `PUT`, `DELETE`) trên `/user/{id}` với kiểm tra phân quyền.
  * Entity `UserProfile` lưu thành công vào PostgreSQL qua JPA.
* **Frontend — Xác thực**:
  * `LoginScreen` hiển thị đúng; nhấn nút mở Cognito Hosted UI trong trình duyệt.
  * PKCE code exchange hoạt động end-to-end — tokens được trả về và lưu an toàn.
  * `authSlice` chuyển được `isAuthenticated`; `RootNavigator` điều hướng đúng stack.
  * Axios interceptor tự gắn Bearer token cho mọi API call tiếp theo.

### Nhật ký lab AWS cá nhân (học độc lập):

**Lab 2 — Thiết lập IAM Role cho công việc hàng ngày**
* Tạo IAM Role với các policy phù hợp và cấu hình để dùng thay thế IAM User có access key tĩnh.
* **Học được**: IAM Role ưu tiên hơn IAM User cho EC2 instance và tác vụ tự động vì role sử dụng temporary credentials (STS token) tự xoay vòng, loại bỏ rủi ro lộ key tĩnh.

**Lab 3 — Amazon VPC (Virtual Private Cloud)**
* Xây dựng VPC từ đầu với public và private subnet trải rộng nhiều AZ.
* Cấu hình **Route Tables**: mỗi route entry ánh xạ destination CIDR đến target (IGW, NAT, local). Public subnet route `0.0.0.0/0` đến IGW; private subnet route đến NAT Gateway.
* Triển khai **Internet Gateway (IGW)**: cho phép traffic internet 2 chiều cho resource trong public subnet có public IP. AWS quản lý, highly available, không cần bảo trì.
* So sánh **NAT Gateway vs NAT Instance**:
  * NAT Gateway: AWS quản lý, tốc độ đến 100 Gbps, không cần bảo trì, chỉ outbound, cần Elastic IP trong public subnet.
  * NAT Instance: EC2 do người dùng quản lý, single point of failure, linh hoạt hơn (hỗ trợ port forwarding, có thể làm bastion host), tính phí theo EC2.
* **Học về Security Group vs NACL**:
  * Security Group gắn vào ENI (Elastic Network Interface) — stateful, firewall cấp instance.
  * NACL gắn vào subnet — stateless, firewall cấp subnet. Cần cả rule inbound và outbound.
  * Quan trọng: Route Table và NACL là tài nguyên độc lập mà subnet tham chiếu đến (không nằm bên trong subnet). Nhiều subnet có thể dùng chung 1 route table hoặc NACL.
* Cấu hình **VPC Endpoint**: điểm truy cập nội bộ đến các dịch vụ AWS (S3, SSM, ECR) mà không qua internet.
  * Interface endpoint dùng ENI với private IP — cần Security Group kiểm soát truy cập.
  * Gateway endpoint (S3, DynamoDB) không dùng ENI, đi qua route table.
* Sửa lỗi cấu hình **EC2 Instance Connect Endpoint**: EIC security group phải cho phép outbound đến private subnet, và security group của instance private phải cho phép inbound từ EIC security group.
* Thiết lập **kết nối VPN** mô phỏng hybrid networking: một VPC thứ hai đóng vai on-prem, dùng AWS Site-to-Site VPN để kết nối private IP an toàn.
* Lab 10 — **Active Directory**: Dùng AWS Managed Microsoft AD (AWS Directory Service) triển khai vào 2 private subnet để mô phỏng domain controller Windows on-prem cho DNS và quản lý user.

* Xác định phạm vi project cá nhân và chọn kiến trúc sơ bộ, sau đó đối chiếu lựa chọn dịch vụ bằng trao đổi thêm với Amazon Q.
* Hoàn thành lab IAM role/policy và chuyển thói quen thao tác sang role thay vì root account.
* Hoàn thành lab Amazon VPC và hệ thống hóa các khái niệm Route Table, IGW, NAT Gateway/NAT Instance, NACL, Security Group.
* Ghi nhận và xử lý các lỗi lab khó liên quan VPC Endpoint và hướng cấu hình security group cho EC2 Instance Connect Endpoint.
* Tìm hiểu thêm mô hình kết nối hybrid qua lab VPN và Managed Microsoft AD.

### Tóm tắt kiến thức AWS (rút ra từ nhật ký lab):

* Xác nhận IAM role dùng temporary credential an toàn hơn access key dài hạn cho cả workload compute và automation.
* Nắm rõ mô hình định tuyến VPC giữa public/private subnet với IGW và NAT để kiểm soát mức độ phơi bày ra internet.
* Phân biệt chính xác Security Group (stateful, mức ENI) và NACL (stateless, mức subnet) để xây lớp bảo vệ mạng theo tầng.
* Hiểu cách dùng VPC Endpoint và Site-to-Site VPN để mở rộng kết nối private tới dịch vụ AWS và môi trường hybrid.
* Áp dụng triển khai dịch vụ directory trong private subnet như một pattern nhận dạng doanh nghiệp an toàn.

### Kế hoạch tuần tiếp theo:

* **Backend**: Xây dựng lớp cơ sở hạ tầng — `GlobalExceptionHandler`, `CorsConfig`. Triển khai module `GoalType`.
* **Frontend**: Xây dựng nền tảng navigation — `RootNavigator`, `AuthStack`, `MainTabs` với custom tab bar, `OnboardingStack`.
