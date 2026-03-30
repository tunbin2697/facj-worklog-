---
title: "Worklog Tuần 3"
date: 2026-01-19
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

### Mục tiêu tuần 3:

* **Backend**: Xây dựng lớp cơ sở hạ tầng chung — xử lý exception, CORS, và module `GoalType`.
* **Frontend**: Dựng toàn bộ cấu trúc navigation và triển khai luồng Onboarding đa bước.
* Đảm bảo luồng từ đăng nhập → onboarding → ứng dụng chính hoạt động trước khi thêm tính năng sâu hơn.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --------- | ------------ | --------------- | -------------- |
| 2   | - Triển khai **GlobalExceptionHandler** (`@RestControllerAdvice`) <br>&emsp; + Xử lý `MethodArgumentNotValidException` → lỗi validation theo field <br>&emsp; + Xử lý `EntityNotFoundException`, các business exception tùy chỉnh <br>&emsp; + Tất cả lỗi trả về qua `ApiResponse` envelope | 20/01/2026 | 20/01/2026 | |
| 2   | - Cấu hình **CorsConfig** toàn cục <br>&emsp; + Cho phép origin local dev và production frontend <br>&emsp; + Allow headers: `Authorization`, `Content-Type` <br>&emsp; + Cho phép tất cả HTTP methods | 20/01/2026 | 20/01/2026 | |
| 3   | - Xây dựng module **GoalType** <br>&emsp; + Entity: `name (UNIQUE)`, `description` <br>&emsp; + Repository, Service, Controller <br>&emsp; + Endpoints (tất cả **public**): `POST /api/goal-types`, `GET /api/goal-types`, `GET /api/goal-types/{id}`, `GET /api/goal-types/by-name/{name}` | 21/01/2026 | 21/01/2026 | |
| 4   | - Xây dựng **RootNavigator** cho Frontend <br>&emsp; + Đọc Redux `isAuthenticated` + `hasCompletedOnboarding` từ `authSlice` <br>&emsp; + Điều hướng đến `AuthStack` / `OnboardingStack` / `MainTabs` <br> - Xây dựng **AuthStack**: `WelcomeScreen` + `LoginScreen` <br> - Xây dựng **MainTabs** với `CustomTabBar` <br>&emsp; + 4 tab: Trang chủ, Tập luyện, Dinh dưỡng, Sức khỏe <br>&emsp; + Nút Chat nổi trung tâm chia đôi tab trái/phải | 22/01/2026 | 22/01/2026 | <https://reactnavigation.org/> |
| 5   | - Xây dựng **OnboardingStack** (5 bước) <br>&emsp; + Bước 1: Giới tính + Ngày sinh + Chiều cao + Cân nặng <br>&emsp; + Bước 2: Mức hoạt động + Loại công việc <br>&emsp; + Bước 3: Mục tiêu tập luyện + Cân nặng mục tiêu + Vùng cơ thể cần cải thiện <br>&emsp; + Bước 4: Sở thích ăn uống + Dị ứng + Số bữa/ngày + Lượng nước <br>&emsp; + Bước 5: Kinh nghiệm + Địa điểm tập + Tần suất + Thời gian/buổi | 23/01/2026 | 23/01/2026 | |
| 6   | - Thêm **CaloriesScreen** và **TrainingScreen** vào onboarding preview <br> - Kết nối hoàn thành onboarding: `dispatch(completeOnboarding())` → sync user profile qua `POST /user/sync` | 24/01/2026 | 24/01/2026 | |

### Kết quả đạt được tuần 3:

* **Backend — Common Layer**:
  * `GlobalExceptionHandler` bắt tất cả exception; trả về `ApiResponse` nhất quán cho client.
  * CORS cấu hình toàn cục — frontend chạy trên `localhost:8081` giao tiếp API trên `localhost:8080`.
* **Backend — Module GoalType**:
  * Entity `GoalType` lưu thành công; hỗ trợ các loại: **Giảm mỡ**, **Tăng cơ**, **Duy trì cân nặng**.
  * Tất cả 4 public endpoint hoạt động: tạo, liệt kê, lấy theo ID, lấy theo tên.
  * GoalType là nền tảng để liên kết workout plans với mục tiêu thể dục.
* **Frontend — Navigation**:
  * `RootNavigator` điều hướng đúng theo trạng thái auth + onboarding.
  * `MainTabs` hiển thị `CustomTabBar` với nút Chat trung tâm nổi bật.
  * Tất cả stacks được đăng ký: `AuthStack`, `OnboardingStack`, `WorkoutStack`, `DietStack`, `HealthStack`.
* **Frontend — Onboarding**:
  * Wizard 5 bước hoàn chỉnh với hiệu ứng slide animation.
  * Dữ liệu user được thu thập đầy đủ (giới tính, ngày sinh, chiều cao, cân nặng, mục tiêu, sở thích)
  * Hoàn thành onboarding dispatch `completeOnboarding()` và gọi API sync.

### Nhật ký lab AWS cá nhân (học độc lập):

**Lab 14 — Import máy ảo On-Premise vào AWS (https://000014.awsstudygroup.com/)**
* Sử dụng **VMware Workstation** tạo máy ảo với **Ubuntu 24 LTS Server** (chọn phiên bản live server — nhẹ hơn, không có GUI, phù hợp truy cập SSH trên EC2 sau này).
* Xuất VM sang định dạng `.vmdk` và tải lên S3 bucket (`tunbin-bucket-vm-import-2026`).
* Lưu ý về đặt tên: workshop dùng tên bucket `import-bucket-2021` đã bị chiếm — phải tạo tên riêng và thay thế toàn bộ trong lệnh.
* Chạy lệnh AWS CLI để import VM:
  ```
  aws ec2 import-image --description "VM Image" --disk-containers \
    Format=vhdx,UserBucket="{S3Bucket=tunbin-bucket-vm-import-2026,S3Key=Ubuntu.vmdk}"
  ```
  **Học được**: `S3Key` phải khớp đúng **tên file** `.vmdk` được upload lên S3 (không phải `.vhdx` như workshop hiển thị).
* Theo dõi tiến trình import:
  ```
  aws ec2 describe-import-image-tasks --import-task-ids import-ami-bb7...
  ```
  Import tốn rất nhiều thời gian — cần kiên nhẫn kiểm tra trạng thái nhiều lần.
* **Cảnh báo quan trọng**:
  * Không dùng UEFI boot cho VM — EC2 chỉ hỗ trợ BIOS boot. UEFI gây lỗi `ClientError: EFI partition detected`.
  * Kiểm tra phiên bản kernel có được AWS hỗ trợ trước khi import.
* **S3 ACL cho EC2 export**: API EC2 export (legacy trước thời đám IAM) yêu cầu ACL permission trên bucket, không chỉ IAM policy. Phải bật ACL trên bucket và thêm **Canonical ID** grantee với quyền Write + Read Bucket ACL. Chế độ bucket owner enforced phải tắt. Lưu ý: dùng Canonical ID cho All Other Regions (không phải GovCloud US).
* **AMI**: AMI (Amazon Machine Image) là template lưu sẵn để khởi động EC2 instance. Quá trình import-image tạo ra 1 AMI từ disk image đã upload.
* **Key Pairs**: Dùng để SSH vào EC2. Hỗ trợ kiểu RSA và ED25519 (giống SSH key). Key không tải lại được sau khi tạo — mất key là mất quyền SSH.

* Hoàn thành lab 14 về quy trình import/export máy ảo và xác thực các bước chuyển VM on-prem lên AMI trên AWS.
* Ghi chú troubleshooting thực tế: trùng tên bucket, chọn đúng object key khi chạy lệnh import-image, và xử lý role/policy bị thiếu.
* Nắm các ràng buộc legacy của EC2 import/export, đặc biệt là yêu cầu ACL và khác biệt với bucket owner enforced hiện đại.
* Bổ sung cảnh báo kỹ thuật: tránh UEFI cho image import, kiểm tra tương thích kernel, và chủ động chờ thời gian xử lý dài.
* Củng cố tư duy về AMI, key pair, và vòng đời image làm nền tảng tái sử dụng cho các môi trường EC2.

### Tóm tắt kiến thức AWS (rút ra từ nhật ký lab):

* Nắm rõ các điều kiện tiên quyết khi import VM lên AWS: BIOS boot, kernel tương thích và xử lý đúng định dạng image.
* Củng cố tính chính xác vận hành với bucket S3 unique toàn cục và object key phải khớp tuyệt đối trong lệnh import.
* Hiểu `import-image` là quy trình bất đồng bộ, thời gian dài và bắt buộc theo dõi trạng thái định kỳ.
* Nhận diện các phụ thuộc ACL mang tính legacy trong luồng EC2 import/export và sự khác biệt với mô hình bucket hiện đại.
* Liên kết kiến thức AMI và vòng đời key pair với chiến lược provision EC2 có thể tái sử dụng.

### Kế hoạch tuần tiếp theo:

* **Backend**: Xây dựng module System Workout — `MuscleGroup`, `Exercise`, `WorkoutPlan`, `WorkoutPlanExercise` với admin CRUD và public read endpoints.
* **Frontend**: Triển khai `SuggestedPlanScreen` (wizard 3 bước chọn kế hoạch) và `PlanExercisePicker`.
