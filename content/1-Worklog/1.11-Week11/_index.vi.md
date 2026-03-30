---
title: "Worklog Tuần 11"
date: 2026-03-23
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

### Mục tiêu Tuần 11:

* Thực hiện **kiểm thử tích hợp end-to-end toàn bộ ứng dụng myFit** (tất cả tính năng, tất cả màn hình).
* Viết **tài liệu dự án đầy đủ** — README, tài liệu API, tổng quan kiến trúc.
* **Dọn dẹp code**, loại bỏ các đoạn debug và chuẩn bị dự án cho việc bàn giao.

### Các nhiệm vụ thực hiện trong tuần:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - **Kiểm thử tích hợp end-to-end** — Backend <br>&emsp; + Xác minh tất cả API endpoint với input hợp lệ và không hợp lệ <br>&emsp; + Xác nhận các migration Flyway V1/V2/V3 chạy trên database mới <br>&emsp; + Docker Compose khởi động lạnh: `db` + `api` trạng thái healthy trong dưới 30s <br>&emsp; + Kiểm tra `application.properties` — đảm bảo không có giá trị chỉ dùng cho dev bị đưa vào production | 23/03/2026 | 23/03/2026 | |
| 3   | - **Kiểm thử tích hợp end-to-end** — Frontend (6 luồng người dùng) <br>&emsp; + Luồng 1: Đăng ký → Onboard → Home Dashboard <br>&emsp; + Luồng 2: Tạo plan → Clone system plan → Đặt plan hoạt động <br>&emsp; + Luồng 3: Bắt đầu workout session → Ghi lại sets → Rest timer → Hoàn thành → Màn hình thành công <br>&emsp; + Luồng 4: Thêm thực phẩm vào 4 bữa ăn → Kiểm tra tổng lượng calo trong ngày <br>&emsp; + Luồng 5: Nhập chỉ số cơ thể → Tính BMI/BMR/TDEE → Hiển thị biểu đồ <br>&emsp; + Luồng 6: Chat với AI assistant → Bedrock phản hồi bằng tiếng Việt | 24/03/2026 | 24/03/2026 | |
| 4   | - Viết **Backend README** (`myFit-api/README.md`) <br>&emsp; + Tổng quan dự án & sơ đồ kiến trúc (API ↔ PostgreSQL ↔ Cognito ↔ S3) <br>&emsp; + Tài liệu module: Auth, Food, SystemWorkout, UserWorkoutPlan, Session, UserMetric, Media, GoalType <br>&emsp; + Hướng dẫn cài đặt: prerequisites, biến `.env`, lệnh Docker Compose <br>&emsp; + Bảng tham chiếu API endpoint (tất cả route, method, mô tả, yêu cầu xác thực) | 25/03/2026 | 25/03/2026 | |
| 4   | - Cập nhật **Frontend** `guide.md` <br>&emsp; + Bảng tóm tắt tech stack <br>&emsp; + Sơ đồ cấu trúc navigation (AuthStack / OnboardingStack / MainTabs) <br>&emsp; + Hướng dẫn cài đặt: `npm install`, biến `.env`, `npx expo start` <br>&emsp; + Danh sách các screen kèm mô tả tính năng <br>&emsp; + Ghi chú cấu hình AWS Cognito PKCE + Bedrock | 25/03/2026 | 25/03/2026 | |
| 5   | - **Dọn dẹp code** — Backend <br>&emsp; + Xóa tất cả `TODO`, `FIXME`, và các câu lệnh debug `System.out.println` <br>&emsp; + Đảm bảo các phương thức public phức tạp đều có comment Javadoc <br>&emsp; + Kiểm tra cấu hình bảo mật để tránh việc lộ các route public ngoài ý muốn <br>&emsp; + Build cuối: `mvn clean package -DskipTests` → xác nhận file JAR build thành công | 26/03/2026 | 26/03/2026 | |
| 6   | - **Dọn dẹp code** — Frontend <br>&emsp; + Xóa tất cả các câu lệnh debug `console.log` <br>&emsp; + Chạy `eslint` và sửa các cảnh báo lint còn lại <br>&emsp; + Xóa các import không sử dụng <br>&emsp; + Export cuối: `npx expo export` → xác nhận không còn lỗi TypeScript <br> - **Đánh giá dự án (retrospective)**: ghi lại bài học rút ra, các quyết định công nghệ và các cải tiến có thể thực hiện trong tương lai | 27/03/2026 | 27/03/2026 | |

### Thành tựu Tuần 11:

* **Kiểm thử tích hợp**:
  * Tất cả backend API endpoint đều vượt qua kiểm thử thủ công với input hợp lệ và không hợp lệ.
  * Docker Compose khởi động lạnh ổn định — API healthy trong vòng 25 giây sau khi chạy `docker-compose up`.
  * Flyway V1, V2, V3 migration chạy thành công trên database PostgreSQL mới.
  * Tất cả **6 luồng người dùng** được kiểm thử end-to-end mà không có lỗi nghiêm trọng.

* **Tài liệu**:
  * `myFit-api/README.md` bao gồm hướng dẫn cài đặt đầy đủ, tài liệu biến môi trường và mô tả tất cả endpoint.
  * `guide.md` của frontend được cập nhật với sơ đồ navigation, danh sách screen và cấu hình dịch vụ AWS.
  * Tổng quan kiến trúc được tài liệu hóa: Spring Boot API ↔ PostgreSQL ↔ AWS Cognito ↔ AWS S3 ↔ React Native App ↔ AWS Bedrock.

* **Chất lượng code**:
  * Không còn `console.log` hoặc `System.out.println` trong code production.
  * Build TypeScript (`npx expo export`) hoàn thành mà không có lỗi.
  * Maven `mvn clean package` build file JAR cuối cùng thành công.

* **Đánh giá dự án — Bài học chính**:
  * **Phòng chống IDOR** thông qua việc trích xuất `sub` từ JWT là một mẫu bảo mật quan trọng và cần được áp dụng nhất quán trong toàn bộ REST API có phạm vi người dùng.
  * **Soft delete** với `@SQLRestriction` thân thiện với người dùng hơn so với hard delete đối với dữ liệu thuộc về người dùng — cho phép khả năng khôi phục trong tương lai.
  * Kiến trúc **Stateless JWT** loại bỏ sự phức tạp của session phía server, đổi lại phải xử lý vấn đề thu hồi token (được giải quyết bằng forced logout + refresh queue).
  * **React Native + NativeWind** là một sự kết hợp mạnh mẽ — cú pháp quen thuộc với TailwindCSS giúp tăng tốc đáng kể việc phát triển UI mobile.
  * Việc tách trách nhiệm **Redux + React Query** hoạt động hiệu quả: Redux quản lý trạng thái auth/session; React Query quản lý cache dữ liệu từ server và cơ chế refetch nền.

### Kiến thức AWS học được:

* Thực hiện đánh giá theo mô hình **Well-Architected** dựa trên năm trụ cột: Security, Reliability, Performance Efficiency, Cost Optimization và Operational Excellence.
* Tài liệu hóa khả năng **độ tin cậy hệ thống** thông qua kiểm tra health dependency, kế hoạch backup & restore, và các kỳ vọng thực tế về RPO/RTO.
* Áp dụng tư duy **FinOps** bằng cách rà soát cơ hội tối ưu tài nguyên, lifecycle policies, cảnh báo ngân sách và dọn dẹp tài nguyên không sử dụng.
* Tổng hợp checklist **tăng cường bảo mật** bao gồm kiểm tra IAM, chính sách token, phạm vi mã hóa, quản lý secret và audit logs.
* Chuẩn bị **runbook vận hành cloud** cho deployment, rollback, phản ứng sự cố và kiểm tra vận hành định kỳ.
* Xác định tiêu chí **sẵn sàng bàn giao** như: môi trường có thể tái tạo, tài liệu môi trường đầy đủ và ranh giới trách nhiệm rõ ràng.
* Xây dựng **lộ trình AWS trong tương lai** bao gồm ECS + tăng cường ALB, tối ưu CloudFront, cải thiện observability và triển khai production theo từng giai đoạn.

Tóm lại, tuần 11 đã chuyển các kiến thức AWS học được trong dự án thành **một bản đánh giá vận hành và kế hoạch bàn giao hệ thống**.

### Kế hoạch tuần tiếp theo:

* Thực hiện **bài thuyết trình cuối cùng** cho tất cả các bên liên quan.
* Hoàn thành phần **tự đánh giá và phản hồi**.
* Nộp **báo cáo thực tập**.
* **Ăn mừng hoàn thành dự án!**


