---
title: "Week 9 Worklog"
date: 2026-03-09
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

### Week 9 Objectives:

* **Backend**: Build the User Metric module — `BodyMetric` for recording physical measurements and `HealthCalculation` for computing BMI, BMR, and TDEE.
* **Frontend**: Build `HealthDashboardScreen` with goal input + calculation, `BodyMetricListScreen`, `BodyMetricFormScreen`, and all health visualization chart components.
* Give users clear, actionable insight into their physical health and calorie targets.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Build **BodyMetric** entity (table `body_metric`) <br>&emsp; + Fields: `user (@ManyToOne)`, `heightCm (Float, min=50)`, `weightKg (Float, min=20)`, `age (Integer, min=10)`, `gender (Gender enum)`, `activityLevel (ActivityLevel enum)` <br>&emsp; + `BodyMetricController` (`/api/body-metrics`): create, get by user (newest first), get latest, get/update/delete by ID | 03/09/2026 | 03/09/2026 | |
| 3   | - Build **HealthCalculation** entity (table `health_calculation`) <br>&emsp; + Fields: `user`, `bodyMetric (optional snapshot FK)`, `bmi`, `bmr`, `tdee`, `goalType (GoalTypes enum)` <br>&emsp; + Calculation formulas: <br>&emsp;&emsp; BMI = weight / (height in m)² <br>&emsp;&emsp; BMR (Mifflin-St Jeor): Men = 10×w + 6.25×h - 5×age + 5; Women = −5 <br>&emsp;&emsp; TDEE = BMR × activity multiplier | 03/10/2026 | 03/10/2026 | |
| 3   | - Build **HealthMetricsController** (`/api/metrics`) <br>&emsp; + `POST /calculate` — compute & persist BMI/BMR/TDEE from `CalculateMetricsRequest` <br>&emsp; + `GET /user/{userId}` (full history), `GET /user/{userId}/latest`, `GET /{id}` | 03/10/2026 | 03/10/2026 | |
| 4   | - Build **HealthDashboardScreen** (Frontend) <br>&emsp; + `WheelPicker` for height (cm) and weight (kg) selection <br>&emsp; + `ActivityLevel` dropdown picker <br>&emsp; + Goal type selector: Cutting / Bulking / Maintain / UP_Power <br>&emsp; + On submit: `createBodyMetric` + `calculateMetrics` → display `HealthResultCard` (BMI, BMR, TDEE, Macros) <br>&emsp; + Redirect to Profile if gender/birthdate missing | 03/11/2026 | 03/11/2026 | |
| 5   | - Build health **chart components** (`src/components/health/`) <br>&emsp; + `BMITrendChart`: line chart with time range filter (7d/30d/90d/all) + color-coded BMI zones <br>&emsp; + `WeightChart`: line chart + optional 7-day moving average + distance to goal weight <br>&emsp; + `CalorieEnergyCharts`: dual-line BMR + TDEE with mode toggle <br>&emsp; + `MacrosDisplay`: 3 progress bars (protein/carbs/fat) with grams + % labels <br>&emsp; + `HealthResultCard`: summary card aggregating all computed values | 03/12/2026 | 03/12/2026 | |
| 6   | - Build **BodyMetricListScreen** (Frontend) <br>&emsp; + Lists all body metric history with formatted dates <br>&emsp; + `WeightChart` displayed at top of list <br>&emsp; + Edit (navigate to `BodyMetricFormScreen`) and delete with `ConfirmModal` <br> - Build **BodyMetricFormScreen** <br>&emsp; + Create or edit: height, weight, activity level, goal type <br>&emsp; + Derives gender + age from `authSlice` user state | 03/13/2026 | 03/13/2026 | |
| 7   | - **Backend endpoint refinement** phase 1 <br>&emsp; + Add `@Valid` annotations and custom constraint validators to all request DTOs <br>&emsp; + Standardize pagination response: `PageResponse<T>` with `page`, `size`, `totalPages`, `totalElements` <br>&emsp; + Add time-range filter `GET /api/sessions/user/{userId}?startDate=&endDate=` for session history | 03/14/2026 | 03/14/2026 | |
| 8   | - Write **unit tests** (Spring Boot Test + JUnit 5 + Mockito) <br>&emsp; + `UserWorkoutPlanServiceTest`: clone method, activation logic, IDOR prevention <br>&emsp; + `HealthCalculationServiceTest`: BMI/BMR/TDEE formulas with edge case inputs <br>&emsp; + `UserWorkoutSessionServiceTest`: active session queries, deactivation behavior | 03/15/2026 | 03/15/2026 | |

### Week 9 Achievements:

* **Backend — User Metric module**:
  * `BodyMetric` records persisted with proper validation (height ≥ 50 cm, weight ≥ 20 kg, age ≥ 10).
  * BMR computed correctly using Mifflin-St Jeor equation; TDEE applies activity multipliers (1.2 – 1.9).
  * `POST /api/metrics/calculate` returns `HealthCalculationResponse` with BMI, BMR, TDEE, and derived macros (protein/carbs/fat grams for goal type).
  * History endpoints return records sorted by `createdAt DESC`.
* **Frontend — Health Dashboard**:
  * `HealthDashboardScreen` wheel pickers provide smooth UX for entering height/weight.
  * Results display immediately in `HealthResultCard` after API response.
  * `BMITrendChart` color-codes data points: underweight (blue), normal (green), overweight (yellow), obese (red).
  * `WeightChart` shows moving average trend line when user has ≥ 7 data points.
  * `CalorieEnergyCharts` allows toggling between BMR-only, TDEE-only, and combined view.
  * `BodyMetricListScreen` shows full measurement history with inline edit/delete.

### Next Week Plan:

* **Backend**: Deploy to AWS (Docker → ECR → ECS Fargate behind ALB), enable AWS WAF rate limiting and configuration review.
* **Frontend**: Build `ChatScreen` with AWS Bedrock AI chat integration and `ProfileScreen` with user profile edit and account management.
