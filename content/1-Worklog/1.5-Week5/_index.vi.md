---
title: "Worklog Tuần 5"
date: 2026-02-02
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

### Mục tiêu tuần 5:

* **Backend**: Xây dựng module `UserWorkoutPlan` — kế hoạch cá nhân với clone từ system template, soft-delete, và logic chỉ một kế hoạch active.
* **Frontend**: Xây dựng các màn hình quản lý kế hoạch — `MyPlansScreen`, `CreatePlanScreen`, `PlanEditScreen` với tab chỉnh sửa theo ngày.
* Cho phép user tự quản lý lịch tập cá nhân linh hoạt.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --------- | ------------ | --------------- | -------------- |
| 2   | - Xây dựng **UserWorkoutPlan** entity <br>&emsp; + Trường: `user (@ManyToOne)`, `name (≤150)`, `description`, `goalTypeId (UUID)`, `isActive`, `isDeleted` <br>&emsp; + Soft-delete qua `@SQLRestriction("is_deleted = false")` <br>&emsp; + Viết Flyway **V1**: tạo bảng `user_workout_plan`, `user_workout_plan_exercises` | 03/02/2026 | 03/02/2026 | |
| 2   | - Viết Flyway **V2**: thêm cột `is_deleted BOOLEAN DEFAULT FALSE` | 03/02/2026 | 03/02/2026 | |
| 3   | - Xây dựng **UserWorkoutPlanExercise** entity <br>&emsp; + `dayOfWeek`, `sets`, `reps`, `restSeconds`, `dayIndex`, `weekIndex`, `orderIndex` <br>&emsp; + Reference `Exercise` và `UserWorkoutPlan` | 04/02/2026 | 04/02/2026 | |
| 3   | - Triển khai business logic trong **UserWorkoutPlanService** <br>&emsp; + `userId` luôn lấy từ `Jwt.getSubject()` — ngăn chặn IDOR <br>&emsp; + **Clone**: sao chép sâu toàn bộ `WorkoutPlanExercise` — không giữ FK về kế hoạch gốc <br>&emsp; + **Activate**: đặt `isActive=true` cho plan mục tiêu, `isActive=false` cho tất cả plan khác | 04/02/2026 | 04/02/2026 | |
| 4   | - Xây dựng **UserWorkoutPlanController** (`/api/user-workout-plans`) <br>&emsp; + `POST /me` (tạo kế hoạch), `POST /me/clone/{systemPlanId}` (clone) <br>&emsp; + `GET /me`, `GET /me/active`, `GET /{id}` <br>&emsp; + `PUT /{id}`, `PUT /{id}/activate`, `DELETE /{id}` (soft) <br>&emsp; + CRUD bài tập trong kế hoạch | 05/02/2026 | 05/02/2026 | |
| 5   | - Xây dựng **MyPlansScreen** (Frontend) <br>&emsp; + Liệt kê tất cả kế hoạch với badge trạng thái active <br>&emsp; + Toggle kích hoạt; xóa với `ConfirmModal` <br> - Xây dựng **CreatePlanScreen** (Frontend) <br>&emsp; + Form: tên, mô tả, dropdown goal type | 06/02/2026 | 06/02/2026 | |
| 6   | - Xây dựng **PlanEditScreen** (Frontend) <br>&emsp; + Tab bar theo ngày (Thứ 2 - Chủ nhật) để xem bài tập từng ngày <br>&emsp; + Reorder (lên/xuống), xóa bài tập <br>&emsp; + Điến `PlanExercisePicker` để thêm bài tập | 07/02/2026 | 07/02/2026 | |

### Kết quả đạt được tuần 5:

* **Backend — Module UserWorkoutPlan**:
  * Flyway V1 + V2 migrations được apply thành công.
  * Soft-delete với `@SQLRestriction` hoạt động — kế hoạch đã xóa không bao giờ xuất hiện trong query.
  * Clone tạo bản sao độc lập — xem xét xác nhận không có FK về source.
  * Quy tắc một plan active được thực thi tại service layer.
  * `userId` luôn lấy từ JWT — bảo mật IDOR hoàn toàn.
* **Frontend — Quản lý kế hoạch**:
  * `MyPlansScreen` hiển thị đồng bộ trạng thái active/inactive.
  * `CreatePlanScreen` validate trước khi submit.
  * `PlanEditScreen` theo ngày dễ dùng, sử dụng `uiSlice` để sync trạng thái.

### Kiến thức AWS đã học:

* Nắm các khái niệm quan trọng khi vận hành PostgreSQL trên Amazon RDS: backup managed, maintenance window, parameter group và giới hạn dịch vụ.
* Hiểu cách cô lập database qua private subnet và security group chỉ cho backend truy cập.
* Nghiên cứu snapshot và point-in-time recovery để bảo vệ dữ liệu kế hoạch tập và dữ liệu cá nhân của người dùng.
* Củng cố kỷ luật migration bằng cách xem Flyway script như artifact deploy bắt buộc phải deterministic giữa nhiều môi trường.
* Hiểu vì sao kết nối tới cloud database là tài nguyên hữu hạn và connection pooling phía ứng dụng cần được cấu hình cẩn thận.
* Nắm hướng scale đọc bằng read replica khi sau này hệ thống phát sinh nhiều truy vấn thống kê hoặc báo cáo.
* Liên hệ chiến lược lưu trữ và khôi phục dữ liệu với nhu cầu audit, phục hồi lỗi thao tác và niềm tin người dùng.

Tóm lại, tuần 5 gắn thiết kế dữ liệu của dự án với các nguyên tắc vận hành database managed service trên AWS.

### Nhật ký lab AWS cá nhân (học độc lập):

**Ôn tập sâu — CloudFront Distribution Flow (tổng hợp từ Lab 130)**

Tuần này tôi hệ thống lại kiến thức CloudFront từ Lab 130 (tuần 4) thành mô hình tư duy có thể tái sử dụng:

* **Default Root Object**: Khi người dùng truy cập root distribution (ví dụ `https://d2b5rcxzmgnvyl.cloudfront.net/`), CloudFront tìm Default Root Object (`index.html`), lấy từ S3 origin rồi trả về cho người dùng.
* **Định tuyến theo Cache Behavior**:
  * `GET /api` → khớp với behavior `/api/*` → chuyển đến EC2 origin.
  * `GET /images/logo.png` → khớp `/images/*` → S3 origin.
  * `GET /about.html` → không khớp behavior nào → dùng default behavior → S3 origin.
  * Path được giữ nguyên khi chuyển tiếp đến origin.
* **Invalidation vs versioning**: Khi nội dung cache bị cập nhật nhưng URL không đổi, gửi CloudFront invalidation để xóa cache cũ. Hoặc dùng versioning URL (ví dụ `app.v2.js`) để vượt cache mà không cần invalidation.
* **So sánh S3 vs EC2 origin**: S3 ưu tiên cho nội dung tĩnh (sẵn sàng cao, auto-scaling, không cần bảo trì). EC2 dùng khi cần xử lý động hoặc logic ứng dụng tại origin.
* **Tại sao kiến trúc này hiệu quả**:
  1. Một domain duy nhất cho tất cả nội dung.
  2. Route tối ưu: file tĩnh từ S3, nội dung động từ EC2.
  3. Mỗi loại nội dung cache với TTL phù hợp.
  4. CloudFront phân phối toàn cầu và xử lý cache tại edge.
  5. Có thể áp dụng chính sách bảo mật khác nhau cho từng cache behavior.
* Dùng Amazon Q để hỏi các trường hợp biên (ví dụ xử lý khi nhiều pattern cùng khớp) và tổng hợp thành ghi chú kiến trúc ở trên.

* Củng cố mô hình request routing của CloudFront bằng cách đối chiếu default behavior và các path-based cache behavior.
* Tự tổng hợp lại luồng phân phối với các ví dụ `/`, `/api/*`, và static assets để tránh cấu hình origin sai.
* Làm rõ khi nào nên dùng URL versioning và khi nào cần invalidation thủ công trong vòng lặp cập nhật nội dung.
* So sánh ưu/nhược điểm S3 origin và EC2 origin để định hướng tách static content và API.
* Dùng thêm Amazon Q để kiểm chứng mental model CDN và chuẩn hóa lại ghi chú kỹ thuật cá nhân.

### Kế hoạch tuần tiếp theo:

* **Backend**: Xây dựng module `UserWorkoutSession` và `WorkoutLog` để theo dõi buổi tập thực tế.
* **Frontend**: Xây dựng `PlanDetailScreen` (dashboard kế hoạch active) và `WorkoutSessionScreen` (màn hình tập thực tế với Redux session state).
