---
title: "Worklog Tuần 8"
date: 2026-03-02
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

### Mục tiêu tuần 8:

* **Backend**: Xây dựng module Food & Nutrition — `Food`, `Meal`, `MealFood`, `DailyNutrition` với tính toán macro tự động.
* **Frontend**: Xây dựng `DietScreen` với layout 4 bữa, tìm kiếm thực phẩm, modal thêm food; `DietHistoryScreen`.
* Cho phép user theo dõi lượng calo và macro hàng ngày.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --------- | ------------ | --------------- | -------------- |
| 2   | - Xây dựng entity **Food** (bảng `food`) <br>&emsp; + `name`, `caloriesPer100g`, `proteinPer100g`, `carbsPer100g`, `fatsPer100g`, `unit` <br>&emsp; + `FoodController`: CRUD + phân trang + tìm kiếm theo từ khóa | 03/03/2026 | 03/03/2026 | |
| 3   | - Xây dựng entity **Meal** (bảng `meal`) <br>&emsp; + `userProfile (@ManyToOne)`, `date (LocalDateTime)`, `mealType (BREAKFAST/LUNCH/SNACK/DINNER)`, `note` <br>&emsp; + `MealController`: tạo, lấy theo ID, lọc theo ngày, lọc theo loại bữa | 04/03/2026 | 04/03/2026 | |
| 4   | - Xây dựng entity **MealFood** (bảng `meal_food`) <br>&emsp; + `meal`, `food`, `quantity (gram)` <br>&emsp; + `calories`, `protein`, `carbs`, `fats` tự tính khi tạo: `quantity / 100 * per100gValue` <br>&emsp; + `MealFoodController`: thêm food vào bữa, liệt kê, xóa <br> - Xây dựng entity **DailyNutrition** + `DailyNutritionController`: tính tổng và lưu dinh dưỡng ngày | 05/03/2026 | 05/03/2026 | |
| 5   | - Xây dựng **DietScreen** (Frontend) <br>&emsp; + Hiển thị 4 bữa hôm nay qua `ensureDailyMeals` <br>&emsp; + Mỗi bữa: danh sách food, cột calo, progress bar <br>&emsp; + Modal "Thêm thực phẩm": tìm kiếm, nhập gram, submit → `addFoodToMeal` <br>&emsp; + Progress bar tổng calo ngày <br>&emsp; + Pull-to-refresh | 06/03/2026 | 06/03/2026 | |
| 6   | - Xây dựng **DietHistoryScreen** (Frontend) <br>&emsp; + Lịch tháng — nhấn ngày xem bữa ăn của ngày đó <br>&emsp; + Bày thực phẩm + tổng calo theo từng bữa <br> - Test toàn bộ luồng theo dõi dinh dưỡng | 07/03/2026 | 07/03/2026 | |

### Kết quả đạt được tuần 8:

* **Backend — Module Food & Nutrition**:
  * Entity `Food` được seed dữ liệu thực phẩm từ crawler (hơn 100 món ăn).
  * `MealFood` tự động tính macro khi insert.
  * Phân trang `GET /api/foods` hoạt động với `PageResponse<T>`.
  * Tìm kiếm case-insensitive LIKE query hoạt động.
* **Frontend — Theo dõi dinh dưỡng**:
  * `DietScreen` tạo đủ 4 bữa cho ngày hiện tại.
  * Modal search thực phẩm với kết quả phân trang.
  * Thêm food: backend tính macro → UI refresh số liệu.
  * `DietHistoryScreen` hiển thị lịch sử dinh dưỡng theo ngày chọn.

### Kế hoạch tuần tiếp theo:

* **Backend**: Xây dựng module User Metric — `BodyMetric` và `HealthCalculation` với logic tính BMI/BMR/TDEE.
* **Frontend**: Xây dựng `HealthDashboardScreen`, `BodyMetricListScreen`, `BodyMetricFormScreen`, và các chart sức khỏe.
