---
title: "Worklog Tuần 9"
date: 2026-03-09
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

### Mục tiêu tuần 9:

* **Backend**: Xây dựng module User Metric — `BodyMetric` và `HealthCalculation` với BMI/BMR/TDEE.
* **Frontend**: Xây dựng `HealthDashboardScreen`, `BodyMetricListScreen`, `BodyMetricFormScreen`, và các chart component sức khỏe.
* Cung cấp cho user thông tin rõ ràng về sức khỏe và mục tiêu calo.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --------- | ------------ | --------------- | -------------- |
| 2   | - Xây dựng entity **BodyMetric** (bảng `body_metric`) <br>&emsp; + `user`, `heightCm (min=50)`, `weightKg (min=20)`, `age (min=10)`, `gender (enum)`, `activityLevel (enum)` <br>&emsp; + `BodyMetricController`: tạo, lấy theo user, lấy mới nhất, get/update/delete | 10/03/2026 | 10/03/2026 | |
| 3   | - Xây dựng entity **HealthCalculation** + lôgic tính toán <br>&emsp; + BMI = w / (h/100)² <br>&emsp; + BMR (Mifflin-St Jeor): Nam = 10×w + 6.25×h - 5×age + 5; Nữ = Nam - 161 <br>&emsp; + TDEE = BMR × hệ số hoạt động (1.2 – 1.9) <br> - `HealthMetricsController` (`/api/metrics`): tính toán & lưu, lấy lịch sử, lấy mới nhất | 11/03/2026 | 11/03/2026 | |
| 4   | - Xây dựng **HealthDashboardScreen** (Frontend) <br>&emsp; + `WheelPicker` nhập chiều cao (cm) và cân nặng (kg) <br>&emsp; + Dropdown ActivityLevel và GoalType <br>&emsp; + Submit: `createBodyMetric` + `calculateMetrics` → hiển `HealthResultCard` <br>&emsp; + Redirect Profile nếu thiếu giới tính/ngày sinh | 12/03/2026 | 12/03/2026 | |
| 5   | - Xây dựng các **health chart components** (`src/components/health/`) <br>&emsp; + `BMITrendChart`: biểu đồ BMI theo thời gian, lọc 7d/30d/90d/all + màu theo vùng BMI <br>&emsp; + `WeightChart`: cân nặng + moving average tùy chọn + khoảng cách đến cân nặng mục tiêu <br>&emsp; + `CalorieEnergyCharts`: BMR + TDEE dual-line <br>&emsp; + `MacrosDisplay`: 3 progress bar protein/carbs/fat | 13/03/2026 | 13/03/2026 | |
| 6   | - Xây dựng **BodyMetricListScreen** và **BodyMetricFormScreen** (Frontend) <br>&emsp; + List: hiển thị lịch sử chỉ số, `WeightChart` ở trên cùng, sửa/xóa <br>&emsp; + Form: tạo hoặc chỉnh sửa body metric, lấy gender + age từ `authSlice` | 14/03/2026 | 14/03/2026 | |

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

* **Backend**: Hoàn thiện pagination, cải thiện validation endpoint, viết unit test.
* **Frontend**: Xây dựng `ChatScreen` với AWS Bedrock AI và `ProfileScreen` quản lý hồ sơ.
