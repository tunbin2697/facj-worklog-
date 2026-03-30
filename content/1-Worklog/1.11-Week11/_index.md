---
title: "Week 11 Worklog"
date: 2026-03-23
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

### Week 11 Objectives:

* Conduct full end-to-end integration testing of the entire myFit application (all features, all screens).
* Write comprehensive project documentation — README, API reference, architecture overview.
* Clean up code, remove debug artifacts, and prepare the project for handoff.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - **End-to-end integration testing** — Backend <br>&emsp; + Verify all API endpoints with valid + invalid inputs <br>&emsp; + Confirm Flyway V1/V2/V3 migrations run on fresh DB <br>&emsp; + Docker Compose cold start: `db` + `api` healthy under 30s <br>&emsp; + Review `application.properties` — confirm no dev-only values leak to production | 03/23/2026 | 03/23/2026 | |
| 3   | - **End-to-end integration testing** — Frontend (6 user journeys) <br>&emsp; + Journey 1: Register → Onboard → Home Dashboard <br>&emsp; + Journey 2: Create plan → Clone system plan → Set active plan <br>&emsp; + Journey 3: Start workout session → Log sets → Rest timer → Finish → Success screen <br>&emsp; + Journey 4: Add foods to 4 meals → Verify daily calorie total <br>&emsp; + Journey 5: Enter body metrics → BMI/BMR/TDEE calculated → Charts render <br>&emsp; + Journey 6: Chat with AI assistant → Bedrock responds in Vietnamese | 03/24/2026 | 03/24/2026 | |
| 4   | - Write **Backend README** (`myFit-api/README.md`) <br>&emsp; + Project overview & architecture diagram (API ↔ PostgreSQL ↔ Cognito ↔ S3) <br>&emsp; + Module documentation: Auth, Food, SystemWorkout, UserWorkoutPlan, Session, UserMetric, Media, GoalType <br>&emsp; + Setup guide: prerequisites, `.env` variables, Docker Compose commands <br>&emsp; + API endpoint reference table (all routes, methods, descriptions, auth requirements) | 03/25/2026 | 03/25/2026 | |
| 4   | - Update **Frontend** `guide.md` <br>&emsp; + Tech stack summary table <br>&emsp; + Navigation structure diagram (AuthStack / OnboardingStack / MainTabs) <br>&emsp; + Setup guide: `npm install`, `.env` variables, `npx expo start` <br>&emsp; + Screen inventory with feature descriptions <br>&emsp; + AWS Cognito PKCE + Bedrock setup notes | 03/25/2026 | 03/25/2026 | |
| 5   | - **Code cleanup** — Backend <br>&emsp; + Remove all `TODO`, `FIXME`, debug `System.out.println` statements <br>&emsp; + Ensure public non-trivial methods have Javadoc comments <br>&emsp; + Review security config for inadvertent public route exposure <br>&emsp; + Final build: `mvn clean package -DskipTests` → confirm JAR builds cleanly | 03/26/2026 | 03/26/2026 | |
| 6   | - **Code cleanup** — Frontend <br>&emsp; + Remove all `console.log` debug statements <br>&emsp; + Run `eslint` and fix remaining lint warnings <br>&emsp; + Remove unused imports <br>&emsp; + Final export: `npx expo export` → confirm zero TypeScript errors <br> - **Project retrospective**: document lessons learned, tech decisions in hindsight, potential future improvements | 03/27/2026 | 03/27/2026 | |

### Week 11 Achievements:

* **Integration Testing**:
  * All backend API endpoints pass manual testing with valid and invalid inputs.
  * Docker Compose cold start reliable — API healthy within 25 seconds of `docker-compose up`.
  * Flyway V1, V2, V3 migrations run cleanly on a fresh PostgreSQL database.
  * All 6 user journeys tested end-to-end without critical failures.
* **Documentation**:
  * `myFit-api/README.md` covers full setup guide, environment variable reference, and all endpoint descriptions.
  * Frontend `guide.md` updated with navigation diagram, screen inventory, and AWS service configuration.
  * Architecture overview documented: Spring Boot API ↔ PostgreSQL ↔ AWS Cognito ↔ AWS S3 ↔ React Native App ↔ AWS Bedrock.
* **Code Quality**:
  * Zero `console.log` or `System.out.println` remaining in production paths.
  * TypeScript build (`npx expo export`) passes with zero errors.
  * Maven `mvn clean package` builds final JAR cleanly.
* **Project Retrospective — Key Lessons Learned**:
  * **IDOR prevention** via JWT `sub` extraction is a critical security pattern that must be applied consistently throughout a user-scoped REST API.
  * **Soft delete** with `@SQLRestriction` is more user-friendly than hard delete for user-owned data — allows potential recovery.
  * **Stateless JWT** architecture eliminates server-side session complexity at the cost of token revocation complexity (addressed via forced logout + refresh queue).
  * **React Native + NativeWind** is a powerful combination — TailwindCSS-familiar syntax dramatically speeds up mobile UI development.
  * **Redux + React Query** separation of concerns works well: Redux manages auth/session state; React Query manages server cache and background refetching.

### AWS Knowledge Learned:

* Performed a Well-Architected style review using the five pillars: Security, Reliability, Performance Efficiency, Cost Optimization, and Operational Excellence.
* Documented reliability posture through dependency health checks, backup and restore planning, and realistic RPO/RTO expectations.
* Applied a FinOps mindset by reviewing right-sizing opportunities, lifecycle policies, budget alerts, and idle resource cleanup.
* Consolidated a practical security hardening checklist covering IAM review, token policies, encryption coverage, secret handling, and audit logs.
* Prepared cloud runbooks for deployment, rollback, incident response, and routine operational validation.
* Defined handover readiness criteria such as reproducible setup, complete environment documentation, and explicit ownership boundaries.
* Built a forward AWS roadmap including ECS plus ALB hardening, CloudFront tuning, better observability, and staged production rollout.

In summary, week 11 turned the AWS topics learned during the project into an operational review and handover plan.

### Next Week Plan:

* Final presentation to all stakeholders.
* Complete self-evaluation and feedback sections.
* Submit internship report.
* Celebrate project completion!
