---
title: "Week 8 Worklog"
date: 2026-03-02
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

### Week 8 Objectives:

* **Backend**: Build the complete Food & Nutrition module — `Food`, `Meal`, `MealFood`, `DailyNutrition` with auto-calculated macro nutrients.
* **Frontend**: Build the `DietScreen` with today’s 4-meal layout, food search modal, and add-food-to-meal flow; plus `DietHistoryScreen`.
* Enable users to track daily calorie and macro intake across all meal types.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Build **Food** entity (table `food`) <br>&emsp; + Fields: `name`, `caloriesPer100g`, `proteinPer100g`, `carbsPer100g`, `fatsPer100g`, `unit` <br>&emsp; + `FoodController` (`/api/foods`): `POST /`, `GET /{id}`, `GET /` (paginated), `GET /search?keyword=`, `PUT /{id}` | 03/03/2026 | 03/03/2026 | |
| 3   | - Build **Meal** entity (table `meal`) <br>&emsp; + Fields: `userProfile (@ManyToOne)`, `date (LocalDateTime)`, `mealType (enum: BREAKFAST/LUNCH/SNACK/DINNER)`, `note` <br>&emsp; + `MealController` (`/api/meals`): create, get by ID, list (paginated), filter by date, filter by type | 03/04/2026 | 03/04/2026 | |
| 4   | - Build **MealFood** entity (table `meal_food`) — join table with computed macros <br>&emsp; + Fields: `meal (@ManyToOne)`, `food (@ManyToOne)`, `quantity (float grams)` <br>&emsp; + `calories`, `protein`, `carbs`, `fats` auto-calculated at insertion from Food’s per-100g values × (quantity/100) <br>&emsp; + `MealFoodController` (`/api/meal-foods`): add food to meal, list foods in meal, remove | 03/05/2026 | 03/05/2026 | |
| 4   | - Build **DailyNutrition** entity (table `daily_nutrition`) <br>&emsp; + Fields: `nutritionDate (LocalDate)`, `totalCalories`, `totalProtein`, `totalCarbs`, `totalFats` <br>&emsp; + `DailyNutritionController` (`/api/daily-nutrition`): `POST /calculate?date=` recomputes & saves daily totals; `GET /?date=` retrieves | 03/05/2026 | 03/05/2026 | |
| 5   | - Build **DietScreen** (Frontend) <br>&emsp; + Display today’s 4 meals (Breakfast/Lunch/Snack/Dinner) via `ensureDailyMeals` <br>&emsp; + Each meal: food items list, calorie count, progress bar vs. target <br>&emsp; + "Add food" modal: search by name (`searchFoods`), input quantity in grams, submit → `addFoodToMeal` <br>&emsp; + Total daily calorie progress bar at top <br>&emsp; + Pull-to-refresh | 03/06/2026 | 03/06/2026 | |
| 6   | - Build **DietHistoryScreen** (Frontend) <br>&emsp; + Monthly calendar view — tap a date to see that day’s meal breakdown <br>&emsp; + Per-meal food items with calorie totals <br> - Integrate `foodService`: `getMealsByUser`, `getMealFoodsByMealId`, `addFoodToMeal`, `deleteMealFood` into DietScreen <br> - Test full nutrition tracking loop: add food → view nutrient breakdown → track daily total | 03/07/2026 | 03/07/2026 | |

### Week 8 Achievements:

* **Backend — Food & Nutrition module**:
  * `Food` entity seeded with real food data from the `fitness_crawler` tool (over 100 food items in local DB).
  * `MealFood` correctly auto-calculates `calories`, `protein`, `carbs`, `fats` on insertion based on `quantity / 100 * per100gValue`.
  * `POST /api/daily-nutrition/calculate?date=` aggregates all `MealFood` entries for a date into a single `DailyNutrition` record.
  * Pagination on `GET /api/foods` works — `PageResponse<T>` wrapper handles `page`, `size`, `totalPages`, `totalElements`.
  * Keyword search on `GET /api/foods/search?keyword=` performs case-insensitive LIKE query.
* **Frontend — Diet tracking**:
  * `DietScreen` correctly calls `ensureDailyMeals` to guarantee 4 meal slots exist for today.
  * Food search modal shows paginated results with lazy loading.
  * Adding food: quantity input → backend calculates and stores macros → UI refreshes with updated totals.
  * `DietHistoryScreen` calendar correctly loads meal data for selected dates.
  * Daily calorie progress bar reflects `totalCalories / 2500` target accurately.

### Next Week Plan:

* **Backend**: Build the User Metric module — `BodyMetric` entity and `HealthCalculation` with BMI / BMR / TDEE computation logic.
* **Frontend**: Build `HealthDashboardScreen` with wheel pickers, `BodyMetricListScreen`, `BodyMetricFormScreen`, and all health chart components.
