---
title: "Week 10 Worklog"
date: 2026-03-16
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

### Week 10 Objectives:

* **Frontend**:
  * Build the `ChatScreen` integrating **AWS Bedrock (Claude 3.5 Haiku)** with a sliding-window memory, and `ProfileScreen` with user account management.
  * Implement robust **token refresh logic** via Axios interceptor queues for seamless UX during session expiration.
  * Build `HomeScreen` as the central dashboard, resolve all outstanding bugs, and polish the overall UX across the app.
* **Backend**:
  * Prepare for deployment: Docker Compose health checks, push image to **Amazon ECR**, define **ECS Fargate** task, enable **AWS WAF**.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Backend endpoint refinements <br>&emsp; + Add `@Valid` annotations and custom constraint validators to all request DTOs <br>&emsp; + Standardize paginated responses: `PageResponse<T>` with `page`, `size`, `totalPages`, `totalElements` <br>&emsp; + Add `GET /api/sessions/user/{userId}?startDate=&endDate=` date-range filter for session history | 03/16/2026 | 03/16/2026 | |
| 3   | - Write **unit tests** (Spring Boot Test + JUnit 5 + Mockito) <br>&emsp; + `UserWorkoutPlanServiceTest`: clone method, activate logic, IDOR prevention <br>&emsp; + `HealthCalculationServiceTest`: BMI/BMR/TDEE formulas for various inputs <br>&emsp; + `UserWorkoutSessionServiceTest`: active session query, deactivate behavior | 03/17/2026 | 03/17/2026 | |
| 4   | - Build **chatService** (Frontend) <br>&emsp; + Direct AWS Bedrock Runtime API call (no Lambda proxy) <br>&emsp; + Model: `anthropic.claude-3-5-haiku-20241022-v1:0` <br>&emsp; + Vietnamese system prompt: fitness coach persona <br>&emsp; + Send last 12 conversation turns as context (sliding window memory) | 03/18/2026 | 03/18/2026 | <https://docs.aws.amazon.com/bedrock/> |
| 5   | - Build **ChatScreen** (Frontend) <br>&emsp; + Full-screen chat UI with message bubble list (user / bot) <br>&emsp; + Animated "typing" indicator (3 bouncing dots) while waiting for response <br>&emsp; + 4 quick-option chips: "Suggest exercises", "Today’s menu", "Calorie goal", "Weight loss advice" <br>&emsp; + Vietnamese initial greeting from the fitness bot <br>&emsp; + Animated keyboard avoidance <br>&emsp; + `notifyAlert` error handling via global alert proxy | 03/19/2026 | 03/19/2026 | |
| 6   | - Build **ProfileScreen** (Frontend) <br>&emsp; + Display avatar (initial-letter fallback), name, email, username, birthdate, gender <br>&emsp; + Edit modal: update birthdate (YYYY-MM-DD) and gender via `updateUserProfile` API + `dispatch(updateUserProfile)` <br>&emsp; + Logout: `signOut` (Cognito revoke) + `dispatch(logout)` + clear secure storage <br>&emsp; + Delete account: `deleteUserProfile` + `signOut` — both gated by `ConfirmModal` | 03/20/2026 | 03/20/2026 | |
| 7   | - Build **HomeScreen** (Frontend) — 5 parallel data fetches on mount <br>&emsp; + Today’s meals: sum MealFood calories → daily calorie progress bar vs. 2500 kcal target <br>&emsp; + Latest `HealthCalculation` → show BMI <br>&emsp; + Latest `BodyMetric` → show current height/weight <br>&emsp; + Active workout plan name → quick link to PlanDetail <br>&emsp; + This-week session count → weekly progress vs. 4 sessions target | 03/21/2026 | 03/21/2026 | |
| 7   | - Backend deployment preparation <br>&emsp; + Refine Docker Compose with `postgres` health checks and `Spring Actuator` liveness/readiness probes <br>&emsp; + CI/CD: Push immutable backend image to **Amazon ECR** <br>&emsp; + Define **ECS Fargate** task definition mapped to **ALB** for serverless runtime <br>&emsp; + Protect public endpoints with **AWS WAF** | 03/21/2026 | 03/21/2026 | |
| 8   | - Comprehensive **bug fix** session across key Frontend screens <br>&emsp; + Fix `WorkoutSessionScreen`: edge case when all exercises completed before timer finishes <br>&emsp; + Fix `DietScreen`: ensure `ensureDailyMeals` not called on every render — move to `useEffect` with empty deps <br>&emsp; + Fix `HealthDashboardScreen`: loading state shown during `calculateMetrics` call | 03/22/2026 | 03/22/2026 | |

### Week 10 Achievements:

* **Backend**:
  * All request DTOs now have `@Valid` constraints — invalid inputs return structured `ApiResponse` field errors.
  * `PageResponse<T>` standardizes all paginated endpoints consistently.
  * Date-range session filter (`?startDate=&endDate=`) working with `@DateTimeFormat` parsing.
  * Unit tests pass for `UserWorkoutPlanService` clone, activate, and IDOR prevention scenarios.
  * BMI/BMR/TDEE formulas verified with edge case inputs (min/max allowed ranges).
  * Health check on PostgreSQL service ensures the API container waits for DB to be fully ready.
  * `GET /actuator/health` returns `{status: UP}` with liveness/readiness sub-probes.
  * `.env.example` fully documents all 10+ required environment variables with descriptions.
* **Frontend**:
  * `chatService.sendChatToBedrock` calls AWS Bedrock Runtime directly using credentials from `.env`.
  * Sliding window of 12 turns maintains conversation context economically.
  * Quick-option chips provide instant first interaction without typing.
  * Typing indicator creates natural chat feel; keyboard avoidance works on both iOS and Android.
  * Profile data loaded from Redux `authSlice` — no extra API call needed on screen mount.
  * Edit modal updates local state optimistically and confirms via API.
  * Logout and delete account flows both require confirmation — no accidental data loss.
  * 5 parallel `Promise.all` API calls complete in under 1.5s on localhost.
  * Daily calorie + weekly session progress indicators give users clear at-a-glance goals.
  * BMI and body metric snapshot visible on home without navigating away.
  * Workout session completion edge case resolved — app no longer freezes on final set.
  * `ensureDailyMeals` called only once on first mount — eliminated 4 redundant API calls per render.
  * Token refresh queue prevents logged-out flash when multiple concurrent requests get 401.
  * `NotificationBox` replaces native alerts — consistent in-app notification style.
  * All loading states and error messages standardized across the application.
  * Vietnamese labels complete and consistent throughout the UI.

### Next Week Plan:

* **Backend**:
  * Final API review, Docker Compose refinement with health checks, environment variable documentation.
  * Write project documentation (README, API reference, architecture diagram).
* **Frontend**:
  * Build `HomeScreen` dashboard with parallel data fetching, resolve remaining bugs, and polish overall UX.
  * Run full end-to-end integration test of the complete application (all features, all screens).
  * Prepare final demo and code cleanup for project handoff.