---
title: "Week 3 Worklog"
date: 2026-01-19
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

### Week 3 Objectives:

* **Backend**: Build the application-wide common layer — exception handling, CORS, and the `GoalType` module.
* **Frontend**: Scaffold the complete navigation hierarchy and implement the multi-step Onboarding flow.
* Ensure end-to-end flow from login → onboarding → main app works before adding deeper features.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Implement **GlobalExceptionHandler** (`@RestControllerAdvice`) <br>&emsp; + Handle `MethodArgumentNotValidException` → field-level validation errors <br>&emsp; + Handle `EntityNotFoundException`, custom business exceptions <br>&emsp; + All errors returned in `ApiResponse` envelope with appropriate HTTP status | 01/20/2026 | 01/20/2026 | |
| 2   | - Configure **CorsConfig** globally <br>&emsp; + Allow origins for local dev and production frontend URLs <br>&emsp; + Allow headers: `Authorization`, `Content-Type` <br>&emsp; + Allow all HTTP methods | 01/20/2026 | 01/20/2026 | |
| 3   | - Build **GoalType** module <br>&emsp; + Entity: `name (UNIQUE)`, `description` <br>&emsp; + Repository, Service, Controller <br>&emsp; + Endpoints (all **public**): `POST /api/goal-types`, `GET /api/goal-types`, `GET /api/goal-types/{id}`, `GET /api/goal-types/by-name/{name}` | 01/21/2026 | 01/21/2026 | |
| 4   | - Build **Frontend** `RootNavigator` <br>&emsp; + Reads Redux `isAuthenticated` + `hasCompletedOnboarding` from `authSlice` <br>&emsp; + Routes to `AuthStack` (unauthenticated) / `OnboardingStack` (pending) / `MainTabs` (ready) <br> - Build **AuthStack**: `WelcomeScreen` + `LoginScreen` <br> - Build **MainTabs** with `CustomTabBar` <br>&emsp; + 4 bottom tabs: Home, Workout, Diet, Health <br>&emsp; + Center floating Chat button splitting left/right tabs | 01/22/2026 | 01/22/2026 | <https://reactnavigation.org/> |
| 5   | - Build **OnboardingStack** (5-step wizard) <br>&emsp; + Step 1: Gender + Date-of-birth (day/month/year sliders) + Height + Weight <br>&emsp; + Step 2: Activity level + Job type <br>&emsp; + Step 3: Main fitness goal + Target weight + Target body areas <br>&emsp; + Step 4: Diet preferences + Food allergies + Meals per day + Water intake <br>&emsp; + Step 5: Experience level + Workout location + Frequency + Session duration | 01/23/2026 | 01/23/2026 | |
| 6   | - Add **CaloriesScreen** and **TrainingScreen** to Onboarding preview <br>&emsp; + CaloriesScreen: animated calorie management demo UI <br>&emsp; + TrainingScreen: weekly workout plan by day preview <br> - Wire onboarding completion: `dispatch(completeOnboarding())` → sync user profile to backend via `POST /user/sync` | 01/24/2026 | 01/24/2026 | |

### Week 3 Achievements:

* **Backend — Common Layer**:
  * `GlobalExceptionHandler` catches all standard and custom exceptions; returns consistent `ApiResponse` to clients.
  * CORS configured globally — frontend running on `localhost:8081` can communicate with the API on `localhost:8080`.
* **Backend — GoalType module**:
  * `GoalType` entity persisted to PostgreSQL; supports types like **Weight Loss**, **Muscle Gain**, **Maintenance**.
  * All 4 public endpoints operational: create, list all, get by ID, get by name.
  * GoalTypes serve as the backbone for linking workout plans to user fitness goals.
* **Frontend — Navigation**:
  * `RootNavigator` correctly redirects based on auth + onboarding state — no logic in individual screens.
  * `MainTabs` renders with `CustomTabBar`; tab bar splits left (Home, Workout) and right (Diet, Health) around a center Chat button.
  * All stacks registered: `AuthStack`, `OnboardingStack`, `WorkoutStack`, `DietStack`, `HealthStack`.
* **Frontend — Onboarding**:
  * Full 5-step wizard implemented with slide animations between steps.
  * User data collected (gender, DOB, height, weight, goals, diet prefs, workout prefs) ready to be stored in profile.
  * Onboarding completion dispatches `completeOnboarding()` and calls the backend sync endpoint.

### My Personal AWS Lab Notes (Individual Learning):

**Lab 14 — Import On-Premise VM to AWS (https://000014.awsstudygroup.com/)**
* Used **VMware Workstation** to create a virtual machine using **Ubuntu 24 LTS Server** (live server version was chosen — lighter, no GUI, better for SSH-based EC2 usage).
* Exported the VM to `.vmdk` format and uploaded it to an S3 bucket (`tunbin-bucket-vm-import-2026`).
* Important naming issue: the workshop uses the bucket name `import-bucket-2021` which was already taken — had to use a custom name and replace all occurrences in the commands.
* Ran the AWS CLI command to import the VM image:
  ```
  aws ec2 import-image --description "VM Image" --disk-containers \
    Format=vhdx,UserBucket="{S3Bucket=tunbin-bucket-vm-import-2026,S3Key=Ubuntu.vmdk}"
  ```
  Key lesson: `S3Key` must match the **exact filename** of the `.vmdk` file uploaded to S3 (not `.vhdx` as the workshop shows).
* Monitored the import task with:
  ```
  aws ec2 describe-import-image-tasks --import-task-ids import-ami-bb7...
  ```
  Import takes a long time — need to be patient and keep checking status.
* **Critical warnings**:
  * Do NOT use UEFI boot for the VM — AWS EC2 only supports BIOS boot. UEFI will cause the error `ClientError: EFI partition detected`.
  * Check that the VM kernel version is supported by AWS before importing.
* **S3 ACL for EC2 export**: The EC2 export API (legacy pre-IAM) requires bucket ACL permissions, not just IAM policies. Had to enable ACLs on the bucket and add a **Canonical ID** grantee with Write + Read Bucket ACL permissions. S3 bucket owner enforced mode must be turned off to use ACLs. Note: the Canonical ID for All Other Regions was used (not GovCloud US).
* **AMI concept**: Learned that AMIs (Amazon Machine Images) are saved templates used to launch EC2 instances. The import-image process creates an AMI from the uploaded disk image.
* **Key Pairs**: Used to SSH into EC2 instances. Supports RSA and ED25519 types (similar to SSH key pairs). Key pairs are NOT re-downloadable after creation — losing them means losing SSH access.

### AWS Knowledge Summary (Concluded from Lab Notes):

* Learned VM import prerequisites clearly: BIOS boot support, compatible kernel, and correct source image format handling.
* Reinforced operational precision with globally unique S3 bucket naming and exact object-key matching in import commands.
* Understood `import-image` as a long-running asynchronous workflow that requires status polling and patient verification.
* Identified legacy ACL dependencies in EC2 import/export flows and how they differ from modern bucket-owner-enforced patterns.
* Connected AMI creation and key-pair lifecycle practices to reusable EC2 provisioning and access strategy.

### Next Week Plan:

* **Backend**: Build the System Workout module — `MuscleGroup`, `Exercise`, `WorkoutPlan`, `WorkoutPlanExercise` entities with admin CRUD and public read endpoints.
* **Frontend**: Implement the `SuggestedPlanScreen` (3-step plan selection wizard) and `PlanExercisePicker`.
