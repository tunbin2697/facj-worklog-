---
title: "Week 1 Worklog"
date: 2026-01-05
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---

### Week 1 Objectives:

* Kick off the **myFit** project — a full-stack fitness management application.
* Initialize project repositories for both Backend (Spring Boot) and Frontend (React Native + Expo).
* Set up the local development environment: Java 17, PostgreSQL via Docker, Node.js, Expo CLI.
* Agree on overall system architecture, module breakdown, and technology stack with the team.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Project kickoff: define scope, features, and MVP requirements <br>&emsp; + Core features: workout plans, nutrition tracking, body metrics, session logging <br>&emsp; + Auth via AWS Cognito <br>&emsp; + Admin panel for exercise & plan management | 01/06/2026 | 01/06/2026 | |
| 3   | - Initialize **Backend** project with Spring Boot 3 + Maven <br>&emsp; + Scaffold with `spring-boot-starter-web`, `spring-data-jpa`, `spring-security` <br>&emsp; + Configure `pom.xml`: Flyway, Lombok, jjwt 0.11.5, AWS SDK v1 <br>&emsp; + Establish package structure: `common/`, `config/`, `module/` | 01/07/2026 | 01/07/2026 | <https://start.spring.io/> |
| 4   | - Set up **PostgreSQL** locally with Docker Compose <br>&emsp; + Write `docker-compose.yml` with `postgres:15` service <br>&emsp; + Configure `application.properties`: datasource, JPA `ddl-auto=create-drop`, Flyway <br>&emsp; + Create `.env` / `.env.example` pattern for secrets <br> - Define `EntityBase` `@MappedSuperclass`: `id (UUID)`, `createdAt`, `updatedAt` | 01/08/2026 | 01/08/2026 | <https://docs.docker.com/compose/> |
| 4   | - Initialize **Frontend** project: React Native + Expo ~54 with TypeScript ~5.9 <br>&emsp; + Scaffold with `npx create-expo-app --template` <br>&emsp; + Configure `tsconfig.json`, `babel.config.js`, `metro.config.js` <br>&emsp; + Install and configure NativeWind v4 + `tailwind.config.js` | 01/08/2026 | 01/08/2026 | <https://docs.expo.dev/> |
| 5   | - Design system **entity-relationship diagram** <br>&emsp; + Entities: UserProfile, Food, Meal, Exercise, WorkoutPlan, BodyMetric, Session, Image… <br>&emsp; + Agree on relationships and cardinalities <br> - Create uniform **ApiResponse\<T\>** envelope: `code`, `message`, `result`, `timestamp`, `path` | 01/09/2026 | 01/09/2026 | |
| 6   | - Set up **Redux Toolkit** store on Frontend <br>&emsp; + Install `@reduxjs/toolkit`, `react-redux` <br>&emsp; + Wire `store/index.ts` and `app/providers.tsx` into `App.tsx` <br> - Configure **Axios** client: base URL from `EXPO_PUBLIC_BACKEND_API_URL` <br> - Configure **TanStack React Query** v5 `QueryClient` | 01/10/2026 | 01/10/2026 | <https://redux-toolkit.js.org/> |

### Week 1 Achievements:

* Successfully bootstrapped both backend and frontend project skeletons running locally.
* **Backend (Spring Boot)**:
  * Project starts and connects to PostgreSQL via Docker Compose in one command (`docker-compose up -d`).
  * `EntityBase` with UUID primary key and audit timestamps ready for all entities.
  * `ApiResponse<T>` response envelope standardized across all future endpoints.
  * Maven build passes with zero compile errors.
* **Frontend (React Native + Expo)**:
  * App renders on Android emulator via `npx expo start`.
  * NativeWind v4 configured — TailwindCSS utility classes work in RN components.
  * Redux Toolkit store and React Query `QueryClient` wired via `providers.tsx`.
  * Axios client reads base URL from `.env` (`EXPO_PUBLIC_BACKEND_API_URL=http://localhost:8080`).
* Docker Compose environment reproducible across team machines.
* `.env` secret management pattern established — no hardcoded credentials in source.

### AWS Knowledge Learned:

* Learned AWS account bootstrap in a production-minded way: MFA enforcement, admin separation, and least-privilege IAM design for both engineers and CI.
* Understood how to split identities by purpose: human access, deployment role, and runtime application role to reduce blast radius.
* Practiced AWS CLI profile strategy for `dev` and `staging`, combined with fixed region selection to avoid accidental cross-environment actions.
* Learned how the AWS credential provider chain works, and why environment-sourced credentials must never be committed into the repository.
* Applied tagging standards such as `Project`, `Environment`, `Owner`, and `CostCenter` to support cost tracking and future operations.
* Understood the AWS Shared Responsibility Model with concrete mapping to the project: application logic, IAM policy, and secret hygiene still belong to the team.
* Established a cloud-ready configuration mindset early by keeping all sensitive values outside source code and preparing for a future move to Secrets Manager or SSM.

In summary, week 1 built the foundational AWS operating mindset needed before any service-specific implementation started.

### My Personal AWS Lab Notes (Individual Learning):

**Lab 000001 — AWS Account Setup and IAM Bootstrap**
* Created a new AWS account and immediately set up MFA on the root user to prevent unauthorized access.
* Created an IAM user group (e.g., `admin-group`) with `AdministratorAccess` policy, then created an IAM user and added it to the group for daily work — the root account is never used for routine tasks.
* Learned: root user should only be used for tasks that specifically require it (billing, support plan changes, account closure). All other work should be done via IAM users or roles.

**Lab 000007 — AWS Budgets**
* Created four types of budget alerts: **cost budget** (alerts when spending exceeds a fixed dollar threshold), **usage budget** (alerts on specific service usage), **reservation budget** (tracks Reserved Instance utilization), and **Saving Plans budget** (tracks Saving Plan coverage).
* Learned: budgets do not stop spending — they only alert. However, they are essential for catching runaway costs early and are recommended as a first-day setup for any account.

**Lab 000009 — AWS Support Plans**
* Explored the AWS Support Center to understand available support tiers (Basic, Developer, Business, Enterprise).
* Learned: Basic support is free and includes documentation, whitepapers, and Trusted Advisor core checks. Paid tiers add response time guarantees, Trusted Advisor full checks, and a TAM (Technical Account Manager) at Enterprise level.

**Module 01-04 to 01-07 — AWS Global Infrastructure and Account Concepts**
* **Availability Zones (AZs)**: Each AZ is one or more physical datacenters. AZs provide fault isolation — if one AZ fails, others remain operational. AWS recommends deploying across at least 2 AZs. Exam tip: minimum of 2 AZs required for high availability answers.
* **AWS Regions**: Each region contains at least 3 AZs. There are 25+ regions globally, connected by AWS backbone network. Region selection depends on user geography, service availability per region, and cost (older regions tend to be cheaper).
* **Edge Locations**: AWS CDN network nodes used by CloudFront (CDN), WAF (Web Application Firewall), and Route 53 (DNS). Edge locations serve cached content closer to end users.
* **IAM vs Root user**: Root user = the original account email/password — never use for daily tasks. IAM users are sub-accounts with specific permissions. IAM groups simplify permission management across teams and reduce blast radius from compromised credentials.
* **Cost optimization levers**: Reserved Instances (commit to 1–3 year term for up to 72% savings), Savings Plans (flexible commitment), Spot Instances (up to 90% cheaper but can be interrupted at any time — not suitable for critical workloads). Additional levers: auto-scaling to avoid idle capacity, serverless (pay only when running), tagging for cost allocation, and Architecture Review via Well-Architected Framework.

### Next Week Plan:

* **Backend**: Integrate AWS Cognito — configure `SecurityConfig` with JWT resource server, write custom `OAuth2TokenValidator`, build `UserProfile` entity + `UserProfileController` with sync/CRUD endpoints.
* **Frontend**: Implement the full Authentication flow — `LoginScreen` with PKCE OAuth via `expo-auth-session`, token storage in `expo-secure-store`, `authSlice` Redux state.
