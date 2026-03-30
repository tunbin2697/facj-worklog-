---
title: "Week 7 Worklog"
date: 2026-02-23
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

### Week 7 Objectives:

* **Backend**: Build the Media module — `Image` entity with polymorphic association (food / exercise / workout plan), AWS S3 integration.
* **Frontend**: Build `SessionDetailScreen` (past workout recap) and `SessionCalendarScreen` (monthly calendar view), plus the `mediaService` with image caching.
* Enable images to be displayed for exercises and workout plans throughout the app.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Build **Image** entity (`module/media`) <br>&emsp; + Fields: `url (≤500)`, `isThumbnail`, `food (@ManyToOne nullable)`, `workoutPlan (@ManyToOne nullable)`, `exercise (@ManyToOne nullable)` <br>&emsp; + DB check constraint `chk_image_exclusive`: exactly ONE of `food_id`, `workout_plan_id`, `exercise_id` is non-null (exclusive polymorphic FK) <br>&emsp; + Write Flyway **V3** migration: `image` table with exclusive FK constraint | 02/24/2026 | 02/24/2026 | |
| 3   | - Build **ImageController** (`/api/images`) <br>&emsp; + `POST /` — register image record (URL stored; file lives in S3) <br>&emsp; + `GET /{id}`, `GET /food/{foodId}`, `GET /workout-plan/{workoutPlanId}`, `GET /exercise/{exerciseId}` <br>&emsp; + `PUT /{id}`, `DELETE /{id}` | 02/25/2026 | 02/25/2026 | |
| 3   | - Configure **AWS S3** integration (`config/AwsS3Config.java`) <br>&emsp; + AWS SDK v1: `AmazonS3` bean configured with region `ap-southeast-1` <br>&emsp; + Bucket name from env `S3_BUCKET_NAME` (default `crawl.fitness`) <br>&emsp; + Upload utility method for media files | 02/25/2026 | 02/25/2026 | <https://docs.aws.amazon.com/sdk-for-java/> |
| 4   | - Build **mediaService** (Frontend) <br>&emsp; + `getImageUrl(owner, id)` — fetch image URL from `GET /api/images/{owner}/{id}` <br>&emsp; + In-memory URL cache + in-flight deduplication (prevents duplicate API calls for the same image) <br>&emsp; + Bulk helpers: `getFoodImageUrlMap(ids[])`, `getWorkoutPlanImageUrlMap(ids[])`, `getExerciseImageUrlMap(ids[])` | 02/26/2026 | 02/26/2026 | |
| 5   | - Build **SessionDetailScreen** (Frontend) <br>&emsp; + Past workout recap: exercises grouped by `exerciseId` <br>&emsp; + Shows sets × reps × weight per exercise <br>&emsp; + Formatted date/time display with `utils/date.ts` | 02/27/2026 | 02/27/2026 | |
| 6   | - Build **SessionCalendarScreen** (Frontend) <br>&emsp; + Monthly calendar view with dot indicators on days that have sessions <br>&emsp; + Month navigation (prev/next chevrons) <br>&emsp; + Click a date to show session logs below the calendar <br>&emsp; + Vietnamese day/month labels (Thứ 2–CN, Tháng 1–12) | 02/28/2026 | 02/28/2026 | |

### Week 7 Achievements:

* **Backend — Media module**:
  * Flyway V3 migration applied with exclusive FK constraint on `image` table — DB-level data integrity for polymorphic images.
  * `POST /api/images` registers image URL records linked to food/exercise/plan.
  * `GET /api/images/exercise/{id}` and similar endpoints return all images for a given entity.
  * AWS S3 `AmazonS3` bean configured locally (uses environment variables; real uploads tested with `generate_s3_json.py` tooling).
* **Frontend — Session History**:
  * `SessionDetailScreen` correctly groups workout logs by exercise and renders sets/reps/weight clearly.
  * `SessionCalendarScreen` marks training days with dots; tap to reveal session details inline.
  * Month navigation works; Vietnamese labels render correctly.
* **Frontend — Media Service**:
  * `mediaService` caches fetched image URLs in memory — no duplicate API calls for images already loaded.
  * In-flight deduplication ensures concurrent requests for the same image share a single promise.
  * Workout plan tiles and exercise list items now display associated images from S3.

### My Personal AWS Lab Notes (Individual Learning):

**Lab 22 — EC2 Cost Optimization with Lambda + EventBridge**

* The lab goal: automatically stop/start EC2 instances on a schedule to avoid running costs during off-hours.
* Created a Lambda function (Python) with `ec2.stop_instances(InstanceIds=[...])` and `ec2.start_instances(...)`. IAM role attached to Lambda must include `ec2:StopInstances` and `ec2:StartInstances` permissions on the target instance ARN.
* Created two EventBridge rules — one to stop instances at end of day, one to start them in the morning. Each rule targets the Lambda function.
* **EventBridge timing behavior** (important detail):
  * `rate(1 hour)` starts counting from the moment you create the rule, NOT from the top of the clock. If created at 2:37 PM it fires at 3:37 PM, 4:37 PM, etc.
  * `cron(0 * * * ? *)` fires at exactly minute 0 of every hour regardless of when the rule was created — use this for predictable scheduling.
  * First execution for a `rate(...)` rule: approximately 1 rule-interval after creation.
  * EventBridge has ~1-minute precision; avoid designs that require second-level accuracy.

**Lab 27 — Tags and Resource Groups**

* Tags are key-value metadata pairs attached to AWS resources (e.g., `Environment: Production`, `Project: myFit`). Each resource supports up to 50 tags.
* Tagging use cases: cost allocation (AWS Cost Explorer groups spending by tag), access control (IAM conditions on tag values), automation (EventBridge / Lambda filter by tag), compliance queries.
* **Resource Groups**: Create a logical group by querying resources that share a tag. Allows you to apply automation, patching, or monitoring to an entire group at once without manually listing resource IDs.
* **Tag Editor**: The old per-resource Tags tab inside the EC2 console was deprecated. Tag Editor (under Resource Groups & Tag Editor service) is now the correct way to view and bulk-edit tags across services and regions.

**Self-study — ECS Core Concepts**

* **Cluster**: A logical grouping of tasks and services. Can contain both EC2 instances and Fargate tasks simultaneously. The cluster itself has no cost; you pay for the compute underneath.
* **Task Definition**: A blueprint describing how to run a container — Docker image URI, CPU/memory, environment variables, port mappings, IAM task role, log driver. Versioned: each update creates a new revision.
* **Task**: A running instance of a Task Definition. Short-lived; when it stops it is gone. Used for batch jobs or one-off scripts.
* **Service**: Maintains a desired count of Tasks running at all times. If a Task crashes, the Service launches a replacement. Manages rolling deployments — new task definition revision rolls out gradually with configurable `minimumHealthyPercent` / `maximumPercent`.
* **EC2 launch type vs Fargate**:
  * **EC2**: You provision and manage the underlying EC2 instances. More control; can use GPU instances; cost-efficient for steady high-utilization workloads. Requires cluster agent (`ecs-agent`) on each EC2 node.
  * **Fargate**: AWS manages the underlying compute. You only define CPU/memory per task. No instances to patch or scale. Better for variable workloads or teams that don't want infrastructure management.
* **Networking — `awsvpc` mode**: Each Task gets its own Elastic Network Interface (ENI) with a private IP. Security Groups are attached at the **task level**, not the EC2 instance level. This enables fine-grained traffic control per task in the same cluster.
* **Load balancer integration**: ALB distributes traffic across running tasks. Target Group must use **`ip` target type** (not `instance`) for Fargate, because each task has its own IP via `awsvpc`. Health check path and thresholds must match the application's actual health endpoint.

### AWS Knowledge Summary (Concluded from Lab Notes):

* Implemented event-driven EC2 schedule control with EventBridge + Lambda, including correct use of `cron` versus `rate` timing semantics.
* Established tagging and resource-group practices as the foundation for cost allocation, IAM conditions, and operational automation.
* Clarified ECS building blocks (cluster, task definition, task, service) and how they map to deployment lifecycle decisions.
* Compared EC2 and Fargate launch models based on control versus operational overhead.
* Understood `awsvpc` networking and ALB `ip` target-type requirements for reliable task-level routing.

### Next Week Plan:

* **Backend**: Build the Food & Nutrition module — `Food`, `Meal`, `MealFood`, `DailyNutrition` entities with full CRUD and nutrition calculation.
* **Frontend**: Build `DietScreen` with meal management, food search, and add-food-to-meal flow.
