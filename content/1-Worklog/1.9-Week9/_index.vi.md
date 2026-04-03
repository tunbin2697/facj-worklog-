---
title: "Worklog Tuần 9"
date: 2026-03-09
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

### Mục tiêu Tuần 9:

* **Backend**: Xây dựng module User Metric — `BodyMetric` và `HealthCalculation` với BMI/BMR/TDEE.
* **Frontend**: Xây dựng `HealthDashboardScreen`, `BodyMetricListScreen`, `BodyMetricFormScreen`, và các chart component sức khỏe.
* Cung cấp cho user thông tin rõ ràng về sức khỏe và mục tiêu calo.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --------- | ------------ | --------------- | -------------- |
| 2   | - Xây dựng entity **BodyMetric** (bảng `body_metric`) <br>&emsp; + Các trường: `user (@ManyToOne)`, `heightCm (Float, min=50)`, `weightKg (Float, min=20)`, `age (Integer, min=10)`, `gender (Gender enum)`, `activityLevel (ActivityLevel enum)` <br>&emsp; + `BodyMetricController` (`/api/body-metrics`): tạo mới, lấy theo user (mới nhất trước), lấy mới nhất, get/update/delete theo ID | 03/09/2026 | 03/09/2026 | |
| 3   | - Xây dựng entity **HealthCalculation** (bảng `health_calculation`) <br>&emsp; + Các trường: `user`, `bodyMetric (snapshot FK tùy chọn)`, `bmi`, `bmr`, `tdee`, `goalType (GoalTypes enum)` <br>&emsp; + Công thức tính toán: <br>&emsp;&emsp; BMI = cân nặng / (chiều cao tính bằng m)² <br>&emsp;&emsp; BMR (Mifflin-St Jeor): Nam = 10×w + 6.25×h - 5×age + 5; Nữ = −5 <br>&emsp;&emsp; TDEE = BMR × hệ số hoạt động | 03/10/2026 | 03/10/2026 | |
| 3   | - Xây dựng **HealthMetricsController** (`/api/metrics`) <br>&emsp; + `POST /calculate` — tính toán & lưu BMI/BMR/TDEE từ `CalculateMetricsRequest` <br>&emsp; + `GET /user/{userId}` (toàn bộ lịch sử), `GET /user/{userId}/latest`, `GET /{id}` | 03/10/2026 | 03/10/2026 | |
| 4   | - Xây dựng **HealthDashboardScreen** (Frontend) <br>&emsp; + `WheelPicker` chọn chiều cao (cm) và cân nặng (kg) <br>&emsp; + Dropdown `ActivityLevel` <br>&emsp; + Chọn loại mục tiêu: Cutting / Bulking / Maintain / UP_Power <br>&emsp; + Khi submit: `createBodyMetric` + `calculateMetrics` → hiển thị `HealthResultCard` (BMI, BMR, TDEE, Macros) <br>&emsp; + Chuyển hướng đến Profile nếu thiếu giới tính/ngày sinh | 03/11/2026 | 03/11/2026 | |
| 5   | - Xây dựng các **health chart components** (`src/components/health/`) <br>&emsp; + `BMITrendChart`: biểu đồ đường với bộ lọc khoảng thời gian (7d/30d/90d/all) + màu sắc theo vùng BMI <br>&emsp; + `WeightChart`: biểu đồ đường + moving average 7 ngày tùy chọn + khoảng cách đến cân nặng mục tiêu <br>&emsp; + `CalorieEnergyCharts`: BMR + TDEE dual-line với chế độ chuyển đổi <br>&emsp; + `MacrosDisplay`: 3 progress bar (protein/carbs/fat) với nhãn gam + % <br>&emsp; + `HealthResultCard`: thẻ tóm tắt tổng hợp tất cả các giá trị đã tính | 03/12/2026 | 03/12/2026 | |
| 6   | - Xây dựng **BodyMetricListScreen** (Frontend) <br>&emsp; + Liệt kê toàn bộ lịch sử chỉ số cơ thể với ngày tháng định dạng đẹp <br>&emsp; + `WeightChart` hiển thị ở đầu danh sách <br>&emsp; + Chỉnh sửa (điều hướng đến `BodyMetricFormScreen`) và xóa với `ConfirmModal` <br> - Xây dựng **BodyMetricFormScreen** <br>&emsp; + Tạo mới hoặc chỉnh sửa: chiều cao, cân nặng, activity level, goal type <br>&emsp; + Lấy giới tính + tuổi từ trạng thái user trong `authSlice` | 03/13/2026 | 03/13/2026 | |
| 7   | - **Tinh chỉnh Backend endpoint** giai đoạn 1 <br>&emsp; + Thêm annotation `@Valid` và custom constraint validator vào tất cả request DTO <br>&emsp; + Chuẩn hóa phản hồi phân trang: `PageResponse<T>` với `page`, `size`, `totalPages`, `totalElements` <br>&emsp; + Thêm bộ lọc khoảng thời gian `GET /api/sessions/user/{userId}?startDate=&endDate=` cho session history | 03/14/2026 | 03/14/2026 | |
| 8   | - Viết **unit test** (Spring Boot Test + JUnit 5 + Mockito) <br>&emsp; + `UserWorkoutPlanServiceTest`: clone method, activation logic, IDOR prevention <br>&emsp; + `HealthCalculationServiceTest`: công thức BMI/BMR/TDEE với các input edge case <br>&emsp; + `UserWorkoutSessionServiceTest`: active session queries, deactivation behavior | 03/15/2026 | 03/15/2026 | |

### Kết quả đạt được tuần 9:

* **Backend — Module User Metric**:
  * `BodyMetric` lưu thành công với validation đầy đủ.
  * BMR tính đúng theo Mifflin-St Jeor; TDEE áp dụng đúng hệ số hoạt động.
  * `POST /api/metrics/calculate` trả về BMI, BMR, TDEE và macro gợi ý theo goal.
* **Frontend — Sức khỏe**:
  * `HealthDashboardScreen` wheel picker UX mượt mà; kết quả hiển ngay sau API.
  * `BMITrendChart` màu sắc phân vùng BMI rõ ràng.
  * `WeightChart` hiển moving average khi có ≥7 điểm dữ liệu.
  * `BodyMetricListScreen` lưu lịch sử đo lường đầy đủ.

### Kế hoạch tuần tiếp theo:

* **Backend**: Triển khai lên AWS (Docker → ECR → ECS Fargate behind ALB), kích hoạt AWS WAF rate limiting và rà soát cấu hình.
* **Frontend**: Xây dựng `ChatScreen` với AWS Bedrock AI và `ProfileScreen` quản lý hồ sơ.
