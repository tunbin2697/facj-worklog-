---
title: "Worklog Tuần 11"
date: 2026-03-23
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

### Mục tiêu Tuần 11:

* Thực hiện **kiểm thử tích hợp end-to-end toàn bộ** ứng dụng myFit (tất cả tính năng, tất cả màn hình).
* Viết **tài liệu dự án đầy đủ** — README, tài liệu API tham chiếu, tổng quan kiến trúc.
* **Dọn dẹp code**, loại bỏ các đoạn debug và chuẩn bị dự án cho việc bàn giao.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --------- | ------------ | --------------- | ------------------ |
| 2   | - **Kiểm thử tích hợp end-to-end** — Backend <br>&emsp; + Xác minh tất cả API endpoint với input hợp lệ và không hợp lệ <br>&emsp; + Xác nhận các migration Flyway V1/V2/V3 chạy trên DB mới <br>&emsp; + Docker Compose khởi động lạnh: `db` + `api` trạng thái healthy trong dưới 30s <br>&emsp; + Kiểm tra `application.properties` — đảm bảo không có giá trị chỉ dùng cho dev bị đưa vào production | 03/23/2026 | 03/23/2026 | |
| 3   | - **Kiểm thử tích hợp end-to-end** — Frontend (6 luồng người dùng) <br>&emsp; + Luồng 1: Đăng ký → Onboard → Home Dashboard <br>&emsp; + Luồng 2: Tạo plan → Clone system plan → Đặt plan hoạt động <br>&emsp; + Luồng 3: Bắt đầu workout session → Ghi lại sets → Rest timer → Hoàn thành → Màn hình thành công <br>&emsp; + Luồng 4: Thêm thực phẩm vào 4 bữa ăn → Kiểm tra tổng lượng calo trong ngày <br>&emsp; + Luồng 5: Nhập chỉ số cơ thể → Tính BMI/BMR/TDEE → Hiển thị biểu đồ <br>&emsp; + Luồng 6: Chat với AI assistant → Bedrock phản hồi bằng tiếng Việt | 03/24/2026 | 03/24/2026 | |
| 4   | - Viết **Backend README** (`myFit-api/README.md`) <br>&emsp; + Tổng quan dự án & sơ đồ kiến trúc (API ↔ PostgreSQL ↔ Cognito ↔ S3) <br>&emsp; + Tài liệu module: Auth, Food, SystemWorkout, UserWorkoutPlan, Session, UserMetric, Media, GoalType <br>&emsp; + Hướng dẫn cài đặt: prerequisites, biến `.env`, lệnh Docker Compose <br>&emsp; + Bảng tham chiếu API endpoint (tất cả route, method, mô tả, yêu cầu xác thực) | 03/25/2026 | 03/25/2026 | |
| 4   | - Cập nhật **Frontend** `guide.md` <br>&emsp; + Bảng tóm tắt tech stack <br>&emsp; + Sơ đồ cấu trúc navigation (AuthStack / OnboardingStack / MainTabs) <br>&emsp; + Hướng dẫn cài đặt: `npm install`, biến `.env`, `npx expo start` <br>&emsp; + Danh sách các screen kèm mô tả tính năng <br>&emsp; + Ghi chú cấu hình AWS Cognito PKCE + Bedrock | 03/25/2026 | 03/25/2026 | |
| 5   | - **Dọn dẹp code** — Backend <br>&emsp; + Xóa tất cả `TODO`, `FIXME`, và các câu lệnh debug `System.out.println` <br>&emsp; + Đảm bảo các phương thức public không tầm thường đều có comment Javadoc <br>&emsp; + Kiểm tra cấu hình bảo mật để tránh việc lộ các route public ngoài ý muốn <br>&emsp; + Build cuối: `mvn clean package -DskipTests` → xác nhận file JAR build thành công | 03/26/2026 | 03/26/2026 | |
| 5   | - Cải thiện **Response interceptor** + **UX polish** + **Final bug fix** (chuyển tiếp từ Tuần 10) <br>&emsp; + Triển khai token refresh với request queue: các phản hồi `401` đồng thời được xếp hàng, thực hiện một lần refresh, sau đó thử lại tất cả <br>&emsp; + Thêm component `NotificationBox` global alert (thay thế native `Alert.alert` qua `installAlertProxy`) <br>&emsp; + Thêm pull-to-refresh trên `HomeScreen` + sửa trạng thái loading của `HealthDashboardScreen` <br>&emsp; + Thêm tên hiển thị tiếng Việt `ActivityLevelLabels` cho tất cả enum value <br>&emsp; + Đảm bảo loading spinner và error state nhất quán trên tất cả các màn hình | 03/26/2026 | 03/26/2026 | |
| 6   | - **Dọn dẹp code** — Frontend + **Final bug fix** <br>&emsp; + Xóa tất cả câu lệnh debug `console.log` <br>&emsp; + Chạy `eslint` và sửa các lint warning còn lại <br>&emsp; + Xóa các import không sử dụng <br>&emsp; + Sửa trạng thái trống của `BMITrendChart` (chuyển tiếp từ Tuần 10) <br>&emsp; + Export cuối: `npx expo export` → xác nhận zero TypeScript error <br> - **Đánh giá dự án (retrospective)**: ghi lại bài học rút ra, quyết định công nghệ nhìn lại, các cải tiến tương lai tiềm năng | 03/27/2026 | 03/27/2026 | |

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

### Kế hoạch tuần tiếp theo:

* Thực hiện **bài thuyết trình cuối cùng** cho tất cả các bên liên quan.
* Hoàn thành phần **tự đánh giá và phản hồi**.
* Nộp **báo cáo thực tập**.
* **Ăn mừng hoàn thành dự án!**


