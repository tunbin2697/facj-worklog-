---
title: "Worklog Tuần 10"
date: 2026-03-16
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

### Mục tiêu Tuần 10:

* **Frontend**:
  * Xây dựng `ChatScreen` tích hợp **AWS Bedrock (Claude 3.5 Haiku)** với bộ nhớ ngữ cảnh dạng cửa sổ trượt, và `ProfileScreen` với quản lý tài khoản người dùng.
  * Triển khai **logic làm mới token** mạnh mẽ qua Axios interceptor queue để đảm bảo UX mượt mà khi phiên đăng nhập hết hạn.
  * Xây dựng `HomeScreen` làm bảng điều khiển trung tâm, giải quyết tất cả các lỗi tồn đọng và hoàn thiện UX tổng thể trong toàn bộ ứng dụng.
* **Backend**:
  * Chuẩn bị triển khai: Docker Compose health check, đẩy image lên **Amazon ECR**, định nghĩa task **ECS Fargate**, kích hoạt **AWS WAF**.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --------- | ------------ | --------------- | ------------------ |
| 2   | - Tinh chỉnh Backend endpoint <br>&emsp; + Thêm annotation `@Valid` và custom constraint validator vào tất cả request DTO <br>&emsp; + Chuẩn hóa phản hồi phân trang: `PageResponse<T>` với `page`, `size`, `totalPages`, `totalElements` <br>&emsp; + Thêm bộ lọc khoảng ngày `GET /api/sessions/user/{userId}?startDate=&endDate=` cho session history | 03/16/2026 | 03/16/2026 | |
| 3   | - Viết **unit test** (Spring Boot Test + JUnit 5 + Mockito) <br>&emsp; + `UserWorkoutPlanServiceTest`: clone method, activate logic, IDOR prevention <br>&emsp; + `HealthCalculationServiceTest`: công thức BMI/BMR/TDEE cho nhiều input khác nhau <br>&emsp; + `UserWorkoutSessionServiceTest`: active session query, deactivate behavior | 03/17/2026 | 03/17/2026 | |
| 4   | - Xây dựng **chatService** (Frontend) <br>&emsp; + Gọi trực tiếp API AWS Bedrock Runtime (không qua Lambda proxy) <br>&emsp; + Model: `anthropic.claude-3-5-haiku-20241022-v1:0` <br>&emsp; + System prompt tiếng Việt: hóa thân thành huấn luyện viên thể hình <br>&emsp; + Gửi 12 lượt hội thoại gần nhất làm ngữ cảnh (bộ nhớ dạng cửa sổ trượt) | 03/18/2026 | 03/18/2026 | <https://docs.aws.amazon.com/bedrock/> |
| 5   | - Xây dựng **ChatScreen** (Frontend) <br>&emsp; + Giao diện chat toàn màn hình với danh sách bong bóng tin nhắn (người dùng / bot) <br>&emsp; + Hiệu ứng "đang gõ" (3 dấu chấm nảy) trong lúc chờ phản hồi <br>&emsp; + 4 chip tùy chọn nhanh: "Gợi ý bài tập", "Thực đơn hôm nay", "Mục tiêu calo", "Lời khuyên giảm cân" <br>&emsp; + Lời chào ban đầu bằng tiếng Việt từ bot thể hình <br>&emsp; + Hiệu ứng tránh bàn phím <br>&emsp; + Xử lý lỗi `notifyAlert` qua proxy thông báo toàn cục | 03/19/2026 | 03/19/2026 | |
| 6   | - Xây dựng **ProfileScreen** (Frontend) <br>&emsp; + Hiển thị avatar (chữ cái đầu tiên nếu không có ảnh), tên, email, username, ngày sinh, giới tính <br>&emsp; + Modal chỉnh sửa: cập nhật ngày sinh (YYYY-MM-DD) và giới tính qua API `updateUserProfile` + `dispatch(updateUserProfile)` <br>&emsp; + Đăng xuất: `signOut` (thu hồi Cognito) + `dispatch(logout)` + xóa secure storage <br>&emsp; + Xóa tài khoản: `deleteUserProfile` + `signOut` — cả hai đều được bảo vệ bởi `ConfirmModal` | 03/20/2026 | 03/20/2026 | |
| 7   | - Xây dựng **HomeScreen** (Frontend) — 5 luồng dữ liệu song song khi mount màn hình <br>&emsp; + Bữa ăn hôm nay: tổng calo MealFood → thanh tiến độ calo hàng ngày so với mục tiêu 2500 kcal <br>&emsp; + `HealthCalculation` mới nhất → hiển thị BMI <br>&emsp; + `BodyMetric` mới nhất → hiển thị chiều cao/cân nặng hiện tại <br>&emsp; + Tên kế hoạch tập luyện đang hoạt động → liên kết nhanh đến PlanDetail <br>&emsp; + Số phiên tập tuần này → tiến độ hàng tuần so với mục tiêu 4 phiên | 03/21/2026 | 03/21/2026 | |
| 7   | - Chuẩn bị triển khai Backend <br>&emsp; + Tinh chỉnh Docker Compose với `postgres` health check và `Spring Actuator` liveness/readiness probe <br>&emsp; + CI/CD: Đẩy image backend bất biến (immutable) lên **Amazon ECR** <br>&emsp; + Định nghĩa task **ECS Fargate** được ánh xạ tới **ALB** cho runtime serverless <br>&emsp; + Bảo vệ các public endpoint bằng **AWS WAF** | 03/21/2026 | 03/21/2026 | |
| 8   | - Phiên **sửa lỗi toàn diện** trên các màn hình Frontend chính <br>&emsp; + Sửa `WorkoutSessionScreen`: trường hợp ngoại lệ khi hoàn thành tất cả bài tập trước khi đồng hồ đếm ngược kết thúc <br>&emsp; + Sửa `DietScreen`: đảm bảo `ensureDailyMeals` không bị gọi trên mỗi lần render — chuyển vào `useEffect` với deps rỗng <br>&emsp; + Sửa `HealthDashboardScreen`: hiển thị trạng thái loading trong lúc gọi `calculateMetrics` | 03/22/2026 | 03/22/2026 | |

### Thành tựu Tuần 10:

* **Backend**:
  * Tất cả các request DTO hiện đã có ràng buộc `@Valid` — đầu vào không hợp lệ sẽ trả về lỗi trường `ApiResponse` có cấu trúc.
  * `PageResponse<T>` chuẩn hóa tất cả các endpoint phân trang một cách nhất quán.
  * Bộ lọc khoảng thời gian cho phiên tập (`?startDate=&endDate=`) hoạt động tốt với khả năng phân tích chuỗi của `@DateTimeFormat`.
  * Các unit test đã pass cho các kịch bản clone, kích hoạt và phòng chống IDOR của `UserWorkoutPlanService`.
  * Công thức BMI/BMR/TDEE đã được xác minh với các đầu vào ở trường hợp ngoại lệ (khoảng giới hạn min/max).
  * Health check trên service PostgreSQL đảm bảo container API đợi cho đến khi DB hoàn toàn sẵn sàng.
  * `GET /actuator/health` trả về `{status: UP}` với các sub-probe liveness/readiness.
  * `.env.example` đã ghi chú đầy đủ hơn 10 biến môi trường bắt buộc kèm theo mô tả chi tiết.
* **Frontend**:
  * `chatService.sendChatToBedrock` gọi trực tiếp AWS Bedrock Runtime bằng thông tin xác thực từ `.env`.
  * Bộ nhớ dạng cửa sổ trượt gồm 12 lượt giúp duy trì ngữ cảnh hội thoại một cách tiết kiệm.
  * Các chip tùy chọn nhanh mang đến tương tác tức thì ngay lần đầu mà không cần gõ phím.
  * Hiệu ứng đang gõ tạo cảm giác trò chuyện tự nhiên; tính năng tránh bàn phím hoạt động tốt trên cả iOS và Android.
  * Dữ liệu hồ sơ được tải từ Redux `authSlice` — không cần thêm lệnh gọi API nào khi mount màn hình.
  * Modal chỉnh sửa cập nhật state cục bộ theo hướng lạc quan (optimistically) và xác nhận qua API.
  * Luồng đăng xuất và xóa tài khoản đều yêu cầu xác nhận — không có nguy cơ mất dữ liệu do vô tình.
  * Gọi song song 5 `Promise.all` API hoàn thành dưới 1.5s trên localhost.
  * Các chỉ báo tiến độ calo hàng ngày + phiên tập hàng tuần giúp người dùng nắm bắt mục tiêu rõ ràng ngay từ cái nhìn đầu tiên.
  * Ảnh chụp nhanh BMI và các chỉ số cơ thể hiển thị ngay trên trang chủ mà không cần chuyển trang.
  * Lỗi trường hợp ngoại lệ khi hoàn thành phiên tập đã được giải quyết — ứng dụng không còn bị treo ở hiệp cuối cùng.
  * `ensureDailyMeals` chỉ được gọi một lần trong lần mount đầu tiên — loại bỏ 4 lệnh gọi API thừa ở mỗi lần render.
  * Hàng đợi token refresh ngăn chặn tình trạng nhấp nháy màn hình đăng xuất khi có nhiều yêu cầu đồng thời nhận mã 401.
  * `NotificationBox` thay thế cho cảnh báo gốc của hệ điều hành — đồng nhất phong cách thông báo trong ứng dụng.
  * Tất cả các trạng thái loading và thông báo lỗi được chuẩn hóa trên toàn bộ ứng dụng.
  * Nhãn tiếng Việt đầy đủ và nhất quán xuyên suốt giao diện người dùng.

### Kế hoạch Tuần tới:

* **Backend**:
  * Đánh giá API lần cuối, tinh chỉnh Docker Compose với health checks, viết tài liệu cho biến môi trường.
  * Viết tài liệu dự án (README, tài liệu tham khảo API, sơ đồ kiến trúc).
* **Frontend**:
  * Xây dựng trang tổng quan `HomeScreen` với tính năng gọi dữ liệu song song, giải quyết các lỗi còn lại và hoàn thiện tổng thể UX.
  * Chạy thử nghiệm tích hợp end-to-end toàn diện cho ứng dụng hoàn chỉnh (tất cả các tính năng, tất cả các màn hình).
  * Chuẩn bị bản demo cuối cùng và dọn dẹp mã nguồn để bàn giao dự án.