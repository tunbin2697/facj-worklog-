---
title: "Worklog Tuần 4"
date: 2026-01-26
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

### Mục tiêu tuần 4:

* **Backend**: Xây dựng module System Workout — dữ liệu bài tập và kế hoạch mẫu do admin quản lý.
* **Frontend**: Xây dựng các màn hình duyệt bài tập — wizard gợi ý kế hoạch và bộ chọn bài tập.
* Thiết lập mối quan hệ `GoalType` ↔ `WorkoutPlan` ↔ `Exercise` cho tính năng gợi ý kế hoạch.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --------- | ------------ | --------------- | -------------- |
| 2   | - Xây dựng **MuscleGroup** entity & admin CRUD <br>&emsp; + Entity: `name (UNIQUE, ≤100)`, `description (≤500)` <br>&emsp; + `AdminMuscleGroupController` với `@PreAuthorize("hasRole('ADMIN')")` <br>&emsp; + CRUD đầy đủ: `POST`, `GET /`, `GET /{id}`, `PUT /{id}`, `DELETE /{id}` | 27/01/2026 | 27/01/2026 | |
| 3   | - Xây dựng **Exercise** entity & admin CRUD <br>&emsp; + Entity: `name (≤150)`, `description`, `equipment`, `muscleGroup (@ManyToOne)` <br>&emsp; + `AdminExerciseController`: full CRUD + filter by muscle group <br>&emsp; + Public: `GET /api/workouts/exercises`, `GET /{id}`, `GET /by-muscle-group/{id}`, `POST /custom` | 28/01/2026 | 28/01/2026 | |
| 4   | - Xây dựng **WorkoutPlan** & **WorkoutPlanExercise** <br>&emsp; + `WorkoutPlan`: `name`, `description`, `goalType (@ManyToOne)`, `difficultyLevel`, `estimatedDurationMinutes`, `isSystemPlan` <br>&emsp; + `WorkoutPlanExercise`: lịch theo `dayOfWeek (1-7)`, `sets`, `reps`, `restSeconds`, `dayIndex`, `weekIndex`, `orderIndex` <br>&emsp; + `AdminWorkoutPlanController`: CRUD đầy đủ + filter theo goal type | 29/01/2026 | 29/01/2026 | |
| 4   | - Mở các **public workout endpoints** qua `WorkoutController` (`/api/workouts`) <br>&emsp; + `GET /muscle-groups`, `GET /muscle-groups/{id}` <br>&emsp; + `GET /exercises`, `GET /exercises/{id}`, `GET /exercises/by-muscle-group/{id}` <br>&emsp; + `GET /plans`, `GET /plans/{id}`, `GET /plans/by-goal-type/{id}` | 29/01/2026 | 29/01/2026 | |
| 5   | - Xây dựng **SuggestedPlanScreen** (Frontend) — wizard 3 bước <br>&emsp; + Bước 1: Chọn loại mục tiêu (gọi `GET /api/goal-types`) <br>&emsp; + Bước 2: Duyệt kế hoạch mẫu với hình ảnh và độ khó <br>&emsp; + Bước 3: Xem chi tiết kế hoạch theo ngày → clone qua `cloneFromSystemPlan` | 30/01/2026 | 30/01/2026 | |
| 6   | - Xây dựng **PlanExercisePicker** screen (Frontend) <br>&emsp; + Liệt kê tất cả bài tập hệ thống với hình ảnh và nhóm cơ <br>&emsp; + Tìm kiếm theo tên <br>&emsp; + Khi chọn: gọi `addExerciseToPlan(planId, dayOfWeek, exerciseId)` <br> - Seed dữ liệu bài tập và nhóm cơ ban đầu qua `DatabaseSeeder` | 31/01/2026 | 31/01/2026 | |

### Kết quả đạt được tuần 4:

* **Backend — System Workout**:
  * Entity `MuscleGroup` + admin CRUD hoạt động; đã seed: Ngực, Lưng, Chân, Vai, Tay, Cơ bụng.
  * `Exercise` + admin CRUD + public read endpoints hoạt động.
  * `WorkoutPlan` với `WorkoutPlanExercise` (lịch theo ngày, hỗ trợ multi-week qua `weekIndex`) triển khai xong.
  * Admin endpoints được bảo vệ bởi `ROLE_ADMIN`; public read truy cập không cần auth.
* **Frontend — Duyệt bài tập**:
  * `SuggestedPlanScreen` hướng dẫn user qua mục tiêu → chọn kế hoạch trong 3 bước rõ ràng.
  * `PlanExercisePicker` liệt kê bài tập với context nhóm cơ; chọn bài tập thêm vào kế hoạch user.
* `DatabaseSeeder` seed dữ liệu nhóm cơ + bài tập ban đầu khi khởi động ứng dụng.

### Kiến thức AWS đã học:

* Học cách thiết kế kiến trúc media với Amazon S3 cho file nhị phân và PostgreSQL cho metadata để mỗi hệ thống lưu đúng loại dữ liệu phù hợp.
* Xây dựng quy ước object key như `workouts/`, `exercises/`, `foods/` để phục vụ tổ chức dữ liệu, cleanup và áp lifecycle policy dễ dàng.
* Hiểu nguyên tắc private-by-default cho bucket và lý do không nên lạm dụng public ACL với tài nguyên của ứng dụng.
* Nắm các tùy chọn mã hóa server-side như SSE-S3 và SSE-KMS, cùng tình huống nên dùng KMS để kiểm soát chặt hơn.
* Hiểu vai trò của S3 versioning trong việc bảo vệ trước các trường hợp ghi đè hoặc xóa nhầm file media.
* Phân tích được trade-off chi phí lưu trữ và băng thông đối với ảnh, từ đó thấy rõ tầm quan trọng của tối ưu dung lượng file.
* Chuẩn bị mô hình lưu trữ sẵn sàng để sau này đặt CloudFront trước S3 mà không phải đổi business logic hiện có.

Tóm lại, tuần 4 biến kiến thức về S3 thành một định hướng kiến trúc media rõ ràng cho ứng dụng.

### Nhật ký lab AWS cá nhân (học độc lập):

**Sự kiện — AWS re:Invent 2025 Recap (Track AI/ML)**
* Tham gia track AI/ML của sự kiện re:Invent recap tại tầng 26, văn phòng AWS Việt Nam, Toà nhà Bitexco.
* Đây là sự kiện đầu tiên trong kỳ thực tập. Tìm hiểu các dịch vụ AI/ML mới nhất của AWS và xu hướng công nghệ liên quan đến hướng phát triển dự án sau này.

**Lab 130 — Amazon CloudFront (CDN)**
* Tìm hiểu CloudFront là dịch vụ CDN của AWS — phân phối cả nội dung tĩnh và động qua mạng lưới edge server toàn cầu (cache gần người dùng hơn).
* **Hai loại origin**:
  * **S3 Origin**: Upload file tĩnh lên S3. Mặc định object là private — CloudFront truy cập qua OAI. Khuyến khích cho nội dung tĩnh: 11 năm độ sẵn sàng, auto-scaling, không cần bảo trì.
  * **EC2 Origin**: Cấu hình EC2 để phục vụ nội dung theo port/path. Gặp và sửa lỗi Node.js/Express: script user-data cài `node_modules` vào thư mục root thay vì thư mục app, khiến Express không tìm thấy. Cách sửa: `sudo -i`, di chuyển `app.js` vào folder đúng, cài lại Express, khởi động lại PM2.
* **CloudFront Distribution**: Tạo ra một distribution URL. Distribution điều hướng request đến origin đúng dựa trên path (cache behaviors).
  * **Default Root Object**: Phục vụ khi truy cập root URL (ví dụ `/` → `index.html`).
  * **Cache Behaviors**: Như `/api/*` → EC2, `/images/*` → S3, mặc định `*` → S3. Path được giữ nguyên khi chuyển tiếp đến origin.
* **Distribution Invalidations**: Nếu nội dung đã cache bị cập nhật nhưng URL không đổi, phải gửi invalidation request để xóa cache cũ và lấy phên bản mới từ origin.
* **Lưu ý**: `Origin` trong CloudFront = URL nguồn (S3 object URL hoặc public IP EC2). Distribution domain name là URL người dùng truy cập.

**Lab 81 — AWS Cognito (SAM Workshop)**
* Hoàn thành workshop Cognito triển khai luồng xác thực đầy đủ (sign-in, sign-up, xác minh email, đặt lại mật khẩu) sử dụng AWS SAM.
* **Lỗi `sam build`**: Fail do Python 11 chưa được cài. Cách sửa: chạy với cờ `--use-container` để SAM dùng Docker container có runtime đúng — yêu cầu Docker Engine đang chạy.
* **`sam deploy`**: Cần nhập tham số khi chạy. Phải đổi tên tất cả S3 bucket vì AWS không cho tên bucket trùng toàn cầu.
* **Kiểm tra password policy Cognito**:
  ```
  aws cognito-idp describe-user-pool --user-pool-id <userpool-id> \
    --region us-east-1 --query 'UserPool.Policies.PasswordPolicy'
  ```
  Hữu ích khi kiểm tra tại sao mật khẩu test bị từ chối lúc đăng ký.
* **Khuyến nghị**: Workshop chủ yếu là copy-paste code template để deploy. Để hiểu sâu, nên tự cấu hình từng Cognito resource qua console để thấy cách user pool, app client và hosted UI kết nối với nhau.

* Tham gia sự kiện đầu tiên trong kỳ thực tập: recap AWS re:Invent tại văn phòng AWS Việt Nam, đồng thời tổng hợp insight AI/ML cho định hướng phát triển sau này.
* Hoàn thành lab CloudFront, thực hành cấu hình origin từ EC2 và S3, behavior routing, default root object.
* Xử lý lỗi thực tế khi phục vụ nội dung từ EC2 bằng user-data (cài Node.js/Express sai thư mục, cần chỉnh và restart PM2).
* Hoàn thành workshop Cognito và ghi nhận các lưu ý khi deploy (phụ thuộc runtime, SAM build với container, bucket name phải unique).
* Làm rõ thêm về invalidation, cache behavior và path-based routing qua trao đổi với Amazon Q.

### Kế hoạch tuần tiếp theo:

* **Backend**: Xây dựng module `UserWorkoutPlan` với clone kế hoạch từ system template, soft-delete, và logic kích hoạt.
* **Frontend**: Xây dựng `MyPlansScreen`, `CreatePlanScreen`, và `PlanEditScreen` (trình chỉnh sửa theo ngày).
