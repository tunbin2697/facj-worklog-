---
title: "Worklog Tuần 7"
date: 2026-02-23
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

### Mục tiêu tuần 7:

* **Backend**: Xây dựng module Media — entity `Image` với polymorphic association, tích hợp AWS S3.
* **Frontend**: Xây dựng `SessionDetailScreen`, `SessionCalendarScreen`, và `mediaService` với image caching.
* Hiển thị hình ảnh cho bài tập và kế hoạch tập luyện trong toàn ứng dụng.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --------- | ------------ | --------------- | -------------- |
| 2   | - Xây dựng entity **Image** (`module/media`) <br>&emsp; + `url (≤500)`, `isThumbnail`, `food (nullable)`, `workoutPlan (nullable)`, `exercise (nullable)` <br>&emsp; + Constraint `chk_image_exclusive`: chính xác 1 trong 3 FK có giá trị (polymorphic association) <br>&emsp; + Flyway **V3**: tạo bảng `image` với constraint | 24/02/2026 | 24/02/2026 | |
| 3   | - Xây dựng **ImageController** (`/api/images`) <br>&emsp; + `POST /` (register URL), `GET /{id}` <br>&emsp; + `GET /food/{foodId}`, `GET /workout-plan/{id}`, `GET /exercise/{id}` <br>&emsp; + `PUT /{id}`, `DELETE /{id}` <br> - Cấu hình **AWS S3** (`AwsS3Config.java`): `AmazonS3` bean, region `ap-southeast-1`, bucket từ env | 25/02/2026 | 25/02/2026 | <https://docs.aws.amazon.com/sdk-for-java/> |
| 4   | - Xây dựng **mediaService** (Frontend) <br>&emsp; + `getImageUrl(owner, id)` — gọi `GET /api/images/{owner}/{id}` <br>&emsp; + Cache URL trong bộ nhớ + deduplication in-flight <br>&emsp; + Bulk helpers: `getFoodImageUrlMap`, `getWorkoutPlanImageUrlMap`, `getExerciseImageUrlMap` | 26/02/2026 | 26/02/2026 | |
| 5   | - Xây dựng **SessionDetailScreen** (Frontend) <br>&emsp; + Tóm tắt buổi tập: nhóm bài tập theo `exerciseId` <br>&emsp; + Hiển thị set × rep × cân nặng cho từng bài <br>&emsp; + Format ngày giờ qua `utils/date.ts` | 27/02/2026 | 27/02/2026 | |
| 6   | - Xây dựng **SessionCalendarScreen** (Frontend) <br>&emsp; + Lịch tháng với chấm trên ngày có buổi tập <br>&emsp; + Di chuyển tháng (mũi tên trái/phải) <br>&emsp; + Nhấn ngày để hiển thị log buổi tập bên dưới <br>&emsp; + Nhãn tiếng Việt (Thứ 2–CN, Tháng 1–12) | 28/02/2026 | 28/02/2026 | |

### Kết quả đạt được tuần 7:

* **Backend — Module Media**:
  * Flyway V3 được apply với exclusive FK constraint — toàn vẹn dữ liệu polymorphic ở cấp DB.
  * `ImageController` đăng ký URL hình ảnh và trả về đúng theo entity sở hữu.
  * AWS S3 bean cấu hình local qua biến môi trường.
* **Frontend — Lịch sử buổi tập**:
  * `SessionDetailScreen` nhóm log bài tập đúng và hiển thị rõ ràng.
  * `SessionCalendarScreen` đánh dấu ngày tập; nhấn ngày hiển log chi tiết.
* **Frontend — Media Service**:
  * URL hình ảnh được cache trong bộ nhớ — không gọi API trung lặp.
  * Tile kế hoạch và danh sách bài tập hiển thị hình ảnh từ S3.

### Nhật ký lab AWS cá nhân (học độc lập):

**Lab 22 — Tối ưu chi phí EC2 với Lambda + EventBridge**

* Mục tiêu: tự động stop/start EC2 theo lịch để tránh chi phí chạy ngoài giờ làm việc.
* Tạo Lambda function (Python) gọi `ec2.stop_instances(InstanceIds=[...])` và `ec2.start_instances(...)`. IAM role gắn vào Lambda cần có `ec2:StopInstances` và `ec2:StartInstances` trên ARN instance đích.
* Tạo 2 quy tắc EventBridge: 1 quy tắc stop cuối ngày, 1 quy tắc start sáng sớm. Mỗi quy tắc target Lambda function.
* **Đặc điểm timing của EventBridge** (chi tiết quan trọng):
  * `rate(1 hour)` tính từ thời điểm tạo rule, KHÔNG từ đầu giờ. Tạo lúc 14:37 → chạy lúc 15:37, 16:37...
  * `cron(0 * * * ? *)` chạy đúng phút 0 mọi giờ, bất kể bạn tạo lúc nào — dùng khi cần lịch chính xác.
  * Lần chạy đầu tiên của `rate(...)`: khoảng 1 interval sau khi tạo rule.
  * Độ chính xác ~1 phút; không nên thiết kế phụ thuộc vào độ chính xác theo giây.

**Lab 27 — Tags và Resource Groups**

* Tags là các cặp key-value gắn vào tài nguyên AWS (ví dụ: `Environment: Production`, `Project: myFit`). Mỗi tài nguyên hỗ trợ tối đa 50 tags.
* Ứng dụng: phân bổ chi phí (Cost Explorer nhóm theo tag), kiểm soát truy cập (IAM điều kiện theo tag), tự động hóa (EventBridge/Lambda lọc theo tag), truy vấn compliance.
* **Resource Groups**: Tạo nhóm tài nguyên lógic bằng cách truy vấn tag. Cho phép thực hiện automation, patching, monitoring cho cả nhóm mà không cần liệt kê từng resource ID.
* **Tag Editor**: Tab Tags cũ trong EC2 console đã bị loại bỏ. Tag Editor (trong service Resource Groups & Tag Editor) là cách đúng để xem và sửa tag hàng loạt qua các service và region.

**Tự học — Kiến thức nền ECS**

* **Cluster**: Nhóm lógic chứa task và service. Có thể chạy cả EC2 và Fargate trong cùng cluster. Cluster không tạo chi phí; chi phí tính trên compute bên dưới.
* **Task Definition**: Blueprint mô tả cách chạy container — đường dẫn image Docker, CPU/memory, biến môi trường, port mapping, IAM task role, log driver. Có phiên bản: mỗi lần cập nhật tạo ra revision mới.
* **Task**: Một lần chạy của Task Definition. Tồn tại ngắn; khi dừng là mất. Dùng cho batch job hoặc script một lần.
* **Service**: Duy trì số lượng Task đang chạy theo desired count. Nếu Task crash, Service khởi động lại. Quản lý rolling deployment với `minimumHealthyPercent` / `maximumPercent`.
* **EC2 launch type vs Fargate**:
  * **EC2**: Bạn quản lý EC2 phía dưới. Kiểm soát nhiều hơn; hỗ trợ GPU; hiệu quả chi phí cho workload ổn định cao. Cần cài `ecs-agent` trên mỗi EC2.
  * **Fargate**: AWS quản lý compute. Chỉ cần khai báo CPU/memory mỗi task. Không cần vá OS hay scale instance. Phù hợp workload biến động hoặc team không muốn quản lý infrastructure.
* **Network mode `awsvpc`**: Mỗi Task được cấp riêng 1 ENI với IP riêng. Security Group gắn ở mức **task**, không phải EC2 instance — kiểm soát traffic chi tiết hơn cho từng task trong cùng cluster.
* **Kết hợp Load Balancer**: ALB phân phối traffic đến các task. Target Group phải dùng loại **`ip`** (không phải `instance`) cho Fargate vì mỗi task có IP riêng qua `awsvpc`. Path và ngưỡng health check phải khớp với endpoint thực tế của ứng dụng.

### Tóm tắt kiến thức AWS (rút ra từ nhật ký lab):

* Triển khai được mô hình điều khiển lịch chạy EC2 bằng EventBridge + Lambda và phân biệt đúng ngữ nghĩa thời gian của `cron` so với `rate`.
* Thiết lập thực hành tagging và Resource Groups làm nền tảng cho quản trị chi phí, điều kiện IAM và tự động hóa vận hành.
* Làm rõ các khối lõi của ECS (cluster, task definition, task, service) và cách chúng ảnh hưởng đến vòng đời triển khai.
* So sánh được EC2 launch type và Fargate theo tiêu chí mức kiểm soát hạ tầng và chi phí vận hành.
* Nắm yêu cầu mạng `awsvpc` và target type `ip` của ALB để định tuyến traffic ổn định ở mức task.

### Kế hoạch tuần tiếp theo:

* **Backend**: Xây dựng module Food & Nutrition — `Food`, `Meal`, `MealFood`, `DailyNutrition` với CRUD đầy đủ và tính toán dinh dưỡng.
* **Frontend**: Xây dựng `DietScreen` với quản lý bữa ăn, tìm kiếm thực phẩm, thêm thực phẩm vào bữa.
