---
title: "Worklog Tuần 10"
date: 2026-03-16
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

### Mục tiêu Tuần 10:

* **Backend**:
  * Tinh chỉnh các API endpoint — cải thiện xác thực đầu vào, phân trang và viết unit test cho các phương thức service cốt lõi.
  * Đánh giá API lần cuối, chuẩn bị sẵn sàng môi trường production cho Docker Compose và hoàn thiện tài liệu về biến môi trường.
* **Frontend**:
  * Xây dựng `ChatScreen` tích hợp AI AWS Bedrock và `ProfileScreen` để quản lý tài khoản người dùng.
  * Cung cấp tính năng trợ lý AI như một giá trị gia tăng khác biệt cho ứng dụng.
  * Xây dựng `HomeScreen` làm bảng điều khiển trung tâm, giải quyết tất cả các lỗi còn tồn đọng và hoàn thiện trải nghiệm người dùng (UX) trên toàn bộ ứng dụng.
  * Đạt được một ứng dụng tích hợp, đầy đủ chức năng và sẵn sàng cho đợt kiểm thử cuối cùng.

### Các nhiệm vụ cần thực hiện trong tuần này:
| Ngày | Nhiệm vụ | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Tinh chỉnh các endpoint Backend <br>&emsp; + Thêm annotation `@Valid` và các custom constraint validator vào tất cả các request DTO <br>&emsp; + Chuẩn hóa phản hồi phân trang: `PageResponse<T>` với `page`, `size`, `totalPages`, `totalElements` <br>&emsp; + Thêm bộ lọc khoảng thời gian `GET /api/sessions/user/{userId}?startDate=&endDate=` cho lịch sử phiên tập | 17/03/2026 | 17/03/2026 | |
| 3   | - Viết **unit test** (Spring Boot Test + JUnit 5 + Mockito) <br>&emsp; + `UserWorkoutPlanServiceTest`: phương thức clone, logic kích hoạt, phòng chống IDOR <br>&emsp; + `HealthCalculationServiceTest`: công thức BMI/BMR/TDEE cho các đầu vào khác nhau <br>&emsp; + `UserWorkoutSessionServiceTest`: truy vấn phiên tập đang hoạt động, hành vi hủy kích hoạt | 18/03/2026 | 18/03/2026 | |
| 4   | - Xây dựng **chatService** (Frontend) <br>&emsp; + Gọi trực tiếp API AWS Bedrock Runtime (không qua Lambda proxy) <br>&emsp; + Model: `anthropic.claude-3-5-haiku-20241022-v1:0` <br>&emsp; + System prompt tiếng Việt: hóa thân thành huấn luyện viên thể hình <br>&emsp; + Gửi 12 lượt hội thoại gần nhất làm ngữ cảnh (bộ nhớ dạng cửa sổ trượt) | 19/03/2026 | 19/03/2026 | <https://docs.aws.amazon.com/bedrock/> |
| 5   | - Xây dựng **ChatScreen** (Frontend) <br>&emsp; + Giao diện chat toàn màn hình với danh sách bong bóng tin nhắn (người dùng / bot) <br>&emsp; + Hiệu ứng "đang gõ" (3 dấu chấm nảy) trong lúc chờ phản hồi <br>&emsp; + 4 chip tùy chọn nhanh: "Gợi ý bài tập", "Thực đơn hôm nay", "Mục tiêu calo", "Lời khuyên giảm cân" <br>&emsp; + Lời chào ban đầu bằng tiếng Việt từ bot thể hình <br>&emsp; + Hiệu ứng tránh bàn phím <br>&emsp; + Xử lý lỗi `notifyAlert` qua proxy thông báo toàn cục | 20/03/2026 | 20/03/2026 | |
| 6   | - Xây dựng **ProfileScreen** (Frontend) <br>&emsp; + Hiển thị avatar (chữ cái đầu tiên nếu không có ảnh), tên, email, username, ngày sinh, giới tính <br>&emsp; + Modal chỉnh sửa: cập nhật ngày sinh (YYYY-MM-DD) và giới tính qua API `updateUserProfile` + `dispatch(updateUserProfile)` <br>&emsp; + Đăng xuất: `signOut` (thu hồi Cognito) + `dispatch(logout)` + xóa secure storage <br>&emsp; + Xóa tài khoản: `deleteUserProfile` + `signOut` — cả hai đều được bảo vệ bởi `ConfirmModal` | 21/03/2026 | 21/03/2026 | |
| 2   | - Xây dựng **HomeScreen** (Frontend) — Gọi song song 5 luồng dữ liệu khi mount màn hình <br>&emsp; + Bữa ăn hôm nay: tổng calo MealFood → thanh tiến độ calo hàng ngày so với mục tiêu 2500 kcal <br>&emsp; + `HealthCalculation` mới nhất → hiển thị BMI <br>&emsp; + `BodyMetric` mới nhất → hiển thị chiều cao/cân nặng hiện tại <br>&emsp; + Tên kế hoạch tập luyện đang hoạt động → liên kết nhanh đến PlanDetail <br>&emsp; + Số phiên tập tuần này → tiến độ hàng tuần so với mục tiêu 4 phiên | 24/03/2026 | 24/03/2026 | |
| 3   | - Tinh chỉnh lần cuối **Docker Compose** cho Backend <br>&emsp; + Thêm `healthcheck` cho service `postgres`: `pg_isready` với `interval`, `timeout`, `retries` <br>&emsp; + Thêm `depends_on.db.condition: service_healthy` vào service API <br>&emsp; + Xác minh các probe liveness + readiness của `Spring Actuator` `/actuator/health` <br>&emsp; + Hoàn thiện `.env.example` với tài liệu đầy đủ cho các biến bắt buộc | 25/03/2026 | 25/03/2026 | |
| 4   | - Phiên **sửa lỗi toàn diện** trên tất cả các màn hình Frontend <br>&emsp; + Sửa lỗi `WorkoutSessionScreen`: trường hợp ngoại lệ khi hoàn thành tất cả bài tập trước khi đồng hồ đếm ngược kết thúc <br>&emsp; + Sửa lỗi `DietScreen`: đảm bảo `ensureDailyMeals` không bị gọi trên mỗi lần render — chuyển vào `useEffect` với deps rỗng <br>&emsp; + Sửa lỗi `HealthDashboardScreen`: hiển thị trạng thái loading trong lúc gọi `calculateMetrics` <br>&emsp; + Sửa lỗi `BMITrendChart`: trạng thái trống khi người dùng có ít hơn 2 lần tính toán sức khỏe | 26/03/2026 | 26/03/2026 | |
| 5   | - Cải thiện **Response interceptor** (Axios `client.ts`) <br>&emsp; + Triển khai token refresh với hàng đợi request: xếp hàng các phản hồi `401` đồng thời, thử refresh một lần, sau đó thử lại tất cả <br>&emsp; + Khi refresh thất bại: `forceLogout` xóa token + gọi Redux `logout` + điều hướng về trang Đăng nhập <br>&emsp; + Xử lý `code === 4040` "không tìm thấy user cho cognitoId" → tự động `forceLogout` | 27/03/2026 | 27/03/2026 | |
| 6   | - Đợt **chuốt lại UX** trên tất cả các màn hình <br>&emsp; + Thêm component thông báo toàn cục `NotificationBox` (thay thế `Alert.alert` mặc định thông qua `installAlertProxy`) <br>&emsp; + Thêm thao tác kéo-để-tải-lại (pull-to-refresh) trên `HomeScreen` <br>&emsp; + Đảm bảo tính nhất quán của các vòng xoay tải (loading spinners) và trạng thái lỗi trên toàn ứng dụng <br>&emsp; + Thêm tên hiển thị tiếng Việt `ActivityLevelLabels` cho tất cả các giá trị enum <br>&emsp; + Kiểm tra tính đồng nhất của nhãn tiếng Việt trên các tab điều hướng và tiêu đề | 28/03/2026 | 28/03/2026 | |

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