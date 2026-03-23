---
title: "Week 5 Worklog"
date: 2026-02-02
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

### Week 5 Objectives:

* **Backend**: Build the `UserWorkoutPlan` module — personal plans with cloning from system templates, soft-delete, and one-active-plan enforcement.
* **Frontend**: Build the plan management screens — `MyPlansScreen`, `CreatePlanScreen`, and `PlanEditScreen` with day-tabbed exercise editing.
* Allow users to fully own their personal workout schedule with flexibility to create, clone, and customize plans.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Build **UserWorkoutPlan** entity <br>&emsp; + Fields: `user (@ManyToOne)`, `name (≤150)`, `description`, `goalTypeId (UUID)`, `isActive (default true)`, `isDeleted (default false)` <br>&emsp; + Soft-delete via `@SQLRestriction("is_deleted = false")` — deleted plans invisible to all Hibernate queries <br>&emsp; + Write Flyway **V1** migration: `user_workout_plan`, `user_workout_plan_exercises` tables | 02/03/2026 | 02/03/2026 | |
| 2   | - Write Flyway **V2** migration: add `is_deleted BOOLEAN DEFAULT FALSE` to `user_workout_plans` | 02/03/2026 | 02/03/2026 | |
| 3   | - Build **UserWorkoutPlanExercise** entity <br>&emsp; + Same scheduling fields as system: `dayOfWeek`, `sets`, `reps`, `restSeconds`, `dayIndex`, `weekIndex`, `orderIndex` <br>&emsp; + References `Exercise` (system entity), `UserWorkoutPlan` | 02/04/2026 | 02/04/2026 | |
| 3   | - Implement **UserWorkoutPlanService** key business logic <br>&emsp; + `userId` always extracted from `Jwt.getSubject()` → never from request body (IDOR prevention) <br>&emsp; + **Clone**: deep-copy all `WorkoutPlanExercise` entries into `UserWorkoutPlanExercise` — no FK to source plan retained <br>&emsp; + **Activate**: set `isActive=true` on target plan, set `isActive=false` on all other user plans (one-active rule) | 02/04/2026 | 02/04/2026 | |
| 4   | - Build **UserWorkoutPlanController** (`/api/user-workout-plans`) <br>&emsp; + `POST /me` — create new plan <br>&emsp; + `POST /me/clone/{systemPlanId}` — clone system template <br>&emsp; + `GET /me` (summary list), `GET /me/active`, `GET /{id}` <br>&emsp; + `PUT /{id}` (update metadata), `PUT /{id}/activate`, `DELETE /{id}` (soft) <br>&emsp; + `POST /{planId}/exercises`, `GET /{planId}/exercises`, `PUT /{planId}/exercises/{id}`, `DELETE /{planId}/exercises/{id}` | 02/05/2026 | 02/05/2026 | |
| 5   | - Build **MyPlansScreen** (Frontend) <br>&emsp; + Lists all user plans with active indicator badge <br>&emsp; + Activate/deactivate toggle; soft-delete with `ConfirmModal` <br>&emsp; + Navigate to `CreatePlanScreen` or `PlanEditScreen` | 02/06/2026 | 02/06/2026 | |
| 5   | - Build **CreatePlanScreen** (Frontend) <br>&emsp; + Form: plan name, description, goal type dropdown (fetched from `GET /api/goal-types`) <br>&emsp; + On submit: `createMyPlan` then navigate to `PlanEditScreen` | 02/06/2026 | 02/06/2026 | |
| 6   | - Build **PlanEditScreen** (Frontend) <br>&emsp; + Day-of-week tab bar (Mon-Sun) to switch exercise view per day <br>&emsp; + List exercises for selected day with reorder (up/down arrows), delete button <br>&emsp; + Navigate to `PlanExercisePicker` to add exercises for a given day <br>&emsp; + All changes call `addExerciseToPlan`, `updatePlanExercise`, `removePlanExercise` APIs | 02/07/2026 | 02/07/2026 | |

### Week 5 Achievements:

* **Backend — UserWorkoutPlan module**:
  * Flyway V1 + V2 migrations applied cleanly alongside Hibernate `ddl-auto=create-drop`.
  * Soft-delete pattern with `@SQLRestriction` works — deleted plans never appear in queries.
  * Clone endpoint creates a fully independent copy — verified by checking no FK pointer to source exists.
  * One-active-plan rule enforced at service layer — activating plan X correctly deactivates all others for that user.
  * `userId` always taken from the validated JWT `sub` claim — zero risk of IDOR attacks.
* **Frontend — Plan Management**:
  * `MyPlansScreen` correctly shows active/inactive state; delete prompts confirmation modal.
  * `CreatePlanScreen` form validates name/description before submitting.
  * `PlanEditScreen` day-tab architecture allows intuitive per-day exercise management.
  * Reorder and remove operations reflect immediately in UI after API calls.
  * `uiSlice` (`planEditorDay`, `plansReloadKey`) keeps plan editor state in sync across navigator.

### AWS Knowledge Learned:

* Learned core Amazon RDS concepts for PostgreSQL production usage: managed backup, maintenance windows, parameter groups, and service limitations.
* Understood database isolation through private subnets and security groups that only permit backend services to connect.
* Studied snapshot and point-in-time recovery concepts to protect user-owned workout data from operator error or faulty releases.
* Reinforced migration discipline by treating Flyway scripts as deterministic deployment artifacts that must behave safely across environments.
* Learned why cloud database connections are a finite resource and why application-side connection pooling requires deliberate tuning.
* Understood the future path toward read scaling through read replicas when reporting or analytics traffic increases.
* Connected data retention and recovery strategy to product concerns such as auditability, reversibility, and long-term user trust.

In summary, week 5 linked application data design to AWS-managed relational database practices and recovery planning.

### My Personal AWS Lab Notes (Individual Learning):

**Follow-up Review — CloudFront Distribution Flow (Deep Dive from Lab 130)**

During this week I documented and consolidated the CloudFront knowledge gained from Lab 130 (Week 4) into a reusable mental model:

* **Default Root Object behavior**: When a user visits the distribution root (e.g., `https://d2b5rcxzmgnvyl.cloudfront.net/`), CloudFront looks for the Default Root Object (`index.html`), fetches it from the S3 origin, and serves it to the user.
* **Path-based Cache Behavior routing**:
  * `GET /api` → matches the `/api/*` cache behavior → routes to EC2 origin → calls `origin-server/api`.
  * `GET /images/logo.png` → matches `/images/*` → routes to S3 origin.
  * `GET /about.html` → no specific behavior matches → uses default behavior → S3 origin.
  * Path is always preserved when forwarded to the origin.
* **Invalidation vs versioning**: When a cached resource is updated but the URL stays the same, submit a CloudFront invalidation to discard the cached version. Alternatively, use URL versioning (e.g., `app.v2.js`) to force cache bypass without invalidation.
* **S3 vs EC2 origin comparison**: S3 is preferred for static content (higher availability, auto-scaling, no maintenance). EC2 is used when dynamic content or custom application logic is needed at the origin.
* **Why this architecture is powerful**:
  1. Single domain for all content types.
  2. Optimal routing: static files from S3, dynamic content from EC2.
  3. Each content type cached with appropriate TTL.
  4. CloudFront handles global distribution and edge caching.
  5. Different security policies can be applied per cache behavior.
* Used Amazon Q to ask follow-up questions about edge cases (e.g., how path matching works when patterns overlap) and converted the answers into the above architecture notes.

### Next Week Plan:

* **Backend**: Build the `UserWorkoutSession` and `WorkoutLog` modules for tracking live workout activity.
* **Frontend**: Build `PlanDetailScreen` (active plan dashboard with day selector) and `WorkoutSessionScreen` (live workout screen with Redux session state).
