---
title: "Week 4 Worklog"
date: 2026-01-26
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

### Week 4 Objectives:

* **Backend**: Build the System Workout module — the master exercise and workout plan data managed by admins.
* **Frontend**: Build core workout browsing screens — suggested plan wizard and exercise picker.
* Establish the relationship between `GoalType` ↔ `WorkoutPlan` ↔ `Exercise` for plan recommendations.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Build **MuscleGroup** entity & admin CRUD <br>&emsp; + Entity fields: `name (UNIQUE, ≤100 chars)`, `description (≤500 chars)` <br>&emsp; + `AdminMuscleGroupController` (`/api/admin/muscle-groups`) with `@PreAuthorize("hasRole('ADMIN')")` <br>&emsp; + CRUD: `POST`, `GET /`, `GET /{id}`, `PUT /{id}`, `DELETE /{id}` | 01/27/2026 | 01/27/2026 | |
| 3   | - Build **Exercise** entity & admin CRUD <br>&emsp; + Entity: `name (≤150)`, `description (≤500)`, `equipment`, `muscleGroup (@ManyToOne)` <br>&emsp; + `AdminExerciseController` (`/api/admin/exercises`): full CRUD + filter by muscle group <br>&emsp; + Public: `GET /api/workouts/exercises`, `GET /api/workouts/exercises/{id}`, `GET /api/workouts/exercises/by-muscle-group/{id}`, `POST /api/workouts/exercises/custom` | 01/28/2026 | 01/28/2026 | |
| 4   | - Build **WorkoutPlan** & **WorkoutPlanExercise** entities <br>&emsp; + `WorkoutPlan`: `name`, `description`, `goalType (@ManyToOne)`, `difficultyLevel`, `estimatedDurationMinutes`, `isSystemPlan` <br>&emsp; + `WorkoutPlanExercise`: `dayOfWeek (1-7)`, `sets`, `reps`, `restSeconds`, `dayIndex`, `weekIndex`, `orderIndex` <br>&emsp; + `AdminWorkoutPlanController` with full CRUD + filter by goal type | 01/29/2026 | 01/29/2026 | |
| 4   | - Expose **public workout endpoints** via `WorkoutController` (`/api/workouts`) <br>&emsp; + `GET /muscle-groups`, `GET /muscle-groups/{id}` <br>&emsp; + `GET /exercises`, `GET /exercises/{id}`, `GET /exercises/by-muscle-group/{id}` <br>&emsp; + `GET /plans`, `GET /plans/{id}`, `GET /plans/by-goal-type/{id}` | 01/29/2026 | 01/29/2026 | |
| 5   | - Build **SuggestedPlanScreen** (Frontend) — 3-step wizard <br>&emsp; + Step 1: Select fitness goal type (fetches from `GET /api/goal-types`) <br>&emsp; + Step 2: Browse system workout plan tiles with images and difficulty level <br>&emsp; + Step 3: View full plan detail with exercises grouped by day → clone via `cloneFromSystemPlan` | 01/30/2026 | 01/30/2026 | |
| 6   | - Build **PlanExercisePicker** screen (Frontend) <br>&emsp; + List all system exercises with images and muscle group labels <br>&emsp; + Search/filter by name <br>&emsp; + On select: call `addExerciseToPlan(planId, dayOfWeek, exerciseId)` <br> - Seed initial exercise and muscle group data into the local database via `DatabaseSeeder` | 01/31/2026 | 01/31/2026 | |

### Week 4 Achievements:

* **Backend — System Workout**:
  * `MuscleGroup` entity + admin CRUD fully operational; seeded with common muscle groups (Chest, Back, Legs, Shoulders, Arms, Core).
  * `Exercise` entity + admin CRUD + public read endpoints working.
  * `WorkoutPlan` with `WorkoutPlanExercise` (day-of-week scheduling, multi-week support via `weekIndex`) implemented.
  * All admin endpoints protected by `ROLE_ADMIN`; public read endpoints accessible without auth.
  * `GET /api/workouts/plans/by-goal-type/{id}` correctly filters system plans by goal type.
* **Frontend — Workout Browsing**:
  * `SuggestedPlanScreen` guides users through goal → plan selection in 3 clear steps.
  * Plan tiles display name, difficulty level, estimated duration, and goal type.
  * `PlanExercisePicker` lists all exercises with muscle group context; exercise selection adds to user plan.
* `DatabaseSeeder` populates initial muscle group + exercise data on app start for local dev.

### AWS Knowledge Learned:

* Learned to design media architecture with Amazon S3 for binary objects and PostgreSQL for metadata, keeping each storage system in the role it handles best.
* Designed object key naming conventions such as `workouts/`, `exercises/`, and `foods/` to simplify organization, cleanup, and lifecycle policy targeting.
* Understood private-by-default bucket access and why broad public ACL usage should be avoided for application assets.
* Studied server-side encryption options, especially SSE-S3 and SSE-KMS, and when KMS-backed control is worth the extra complexity.
* Learned the value of S3 versioning for protection against accidental overwrite or deletion of important media files.
* Understood storage and transfer cost tradeoffs for image-heavy applications, especially why optimization of size and format matters.
* Prepared the storage model so CloudFront can later sit in front of S3 without forcing business logic changes in the app.

In summary, week 4 translated AWS storage knowledge into a maintainable media architecture for exercises and plans.

### My Personal AWS Lab Notes (Individual Learning):

**Event — AWS re:Invent 2025 Recap (AI/ML Track)**
* Participated in the AI/ML track of the re:Invent recap event at floor 26, AWS Vietnam Office, Bitexco Tower.
* This was my first internship event. Learned about the latest AWS AI/ML service announcements and industry trends relevant to future project direction.

**Lab 130 — Amazon CloudFront (CDN)**
* Learned that CloudFront is AWS’s CDN service for delivering both static and dynamic content via a global network of edge servers (cache nodes closer to users).
* **Two origin types**:
  * **S3 Origin**: Upload static files to S3. By default objects are private — CloudFront accesses them via OAI (Origin Access Identity). Recommended for static content: 11 nines of availability, auto-scaling, no maintenance.
  * **EC2 Origin**: Configure EC2 to serve content on a port/path. Encountered and fixed a Node.js/Express issue: the user-data script installed `node_modules` in the root directory (not the app folder), so Express was not found. Fix: `sudo -i`, move `app.js` to a proper folder, reinstall Express, and restart PM2.
* **CloudFront Distribution**: The core feature that creates a distribution URL. The distribution routes incoming requests to the correct origin based on path matching (cache behaviors).
  * **Default Root Object**: Served when visiting the distribution root URL (e.g., `/` → `index.html`).
  * **Cache Behaviors**: Path patterns like `/api/*` → EC2 origin, `/images/*` → S3 origin, default `*` → S3. Path is preserved when forwarded to origin.
* **Distribution Invalidations**: When cached content is updated but the URL cannot change, you must submit an invalidation to force CloudFront to purge the old cached version and fetch fresh content from the origin.
* **Key insight**: `Origin` in CloudFront = the source URL (S3 object URL or EC2 public IP). The distribution domain name is what users access.

**Lab 81 — AWS Cognito (SAM Workshop)**
* Completed the Cognito workshop which deploys a full auth flow (sign-in, sign-up, email verification, password reset) using AWS SAM.
* **`sam build` issue**: The command failed because Python 11 was not installed locally. Fix: run with `--use-container` flag so SAM uses a Docker container with the correct runtime — requires Docker Engine to be running.
* **`sam deploy`**: Requires inputting deploy parameters interactively. Had to change all S3 bucket names because AWS does not allow duplicate bucket names globally.
* **Verify Cognito password policy**:
  ```
  aws cognito-idp describe-user-pool --user-pool-id <userpool-id> \
    --region us-east-1 --query 'UserPool.Policies.PasswordPolicy'
  ```
  Useful to check why a test user’s password is rejected during sign-up.
* **Recommendation**: The workshop is mostly copy-paste code-template deployment. For deeper understanding, manually configure each Cognito resource through the console to see how user pools, app clients, and hosted UI connect.

### Next Week Plan:

* **Backend**: Build the `UserWorkoutPlan` module with plan cloning from system templates, soft-delete, and activate/deactivate logic.
* **Frontend**: Build `MyPlansScreen`, `CreatePlanScreen`, and `PlanEditScreen` (day-tabbed exercise editor).
