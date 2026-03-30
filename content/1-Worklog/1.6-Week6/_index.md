---
title: "Week 6 Worklog"
date: 2026-02-09
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

### Week 6 Objectives:

* **Backend**: Build the `UserWorkoutSession` and `WorkoutLog` modules to record actual workout activity in real time.
* **Frontend**: Build `PlanDetailScreen` (active plan with day selector and session start) and `WorkoutSessionScreen` (fully interactive live workout experience).
* Complete the core workout tracking loop: plan → session → log sets → finish.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Build **UserWorkoutSession** entity <br>&emsp; + Fields: `user (@ManyToOne)`, `userWorkoutPlan (@ManyToOne)`, `workoutDate (LocalDate)`, `isActive (default true)`, `weekIndex`, `dayIndex` <br>&emsp; + Cascade to `WorkoutLog` via `@OneToMany(cascade = ALL)` | 02/10/2026 | 02/10/2026 | |
| 3   | - Build **WorkoutLog** entity <br>&emsp; + Fields: `userWorkoutSession (@ManyToOne)`, `exercise (@ManyToOne)`, `setNumber`, `reps`, `weight (Float)`, `durationSeconds` | 02/11/2026 | 02/11/2026 | |
| 3   | - Build **UserWorkoutSessionController** (`/api/sessions`) <br>&emsp; + `POST /` — create session <br>&emsp; + `GET /{id}`, `GET /user/{userId}`, `GET /user/{userId}/by-date?date=` <br>&emsp; + `GET /user/{userId}/active` — fetch currently active session <br>&emsp; + `PATCH /{sessionId}/deactivate` — mark session completed <br>&emsp; + `POST /{sessionId}/logs` — log an exercise set | 02/11/2026 | 02/11/2026 | |
| 4   | - Build **PlanDetailScreen** (Frontend) <br>&emsp; + Display active plan name and description <br>&emsp; + Day-of-week selector (Mon–Sun) — shows exercises for selected day <br>&emsp; + "Start Workout" button: create session via `POST /api/sessions`, navigate to `WorkoutSessionScreen` <br>&emsp; + Show active session banner if session already in progress <br>&emsp; + Navigate to `SessionCalendar` for history | 02/12/2026 | 02/12/2026 | |
| 5   | - Build **workoutSessionSlice** (Redux) <br>&emsp; + State: `sessionId`, `planId`, `exercises[]`, `currentExIndex`, `currentSet`, `completedSets[]`, `phase (workout/rest/done)`, `restSeconds`, `isSavingLog` <br>&emsp; + Actions: `initializeSession`, `restoreSessionState`, `logSetStart/Success/Failure`, `finishRest`, `skipExercise`, `skipSet`, `resetSession` <br>&emsp; + Persist session to `AsyncStorage` on every set — restore on app reload | 02/13/2026 | 02/13/2026 | |
| 6   | - Build **WorkoutSessionScreen** (Frontend) <br>&emsp; + `ActiveExerciseCard`: shows exercise name, set progress, reps target <br>&emsp; + `LogSetSheet`: input actual reps + weight → `addWorkoutLog` API call <br>&emsp; + `RestTimer`: countdown timer with auto-advance to next exercise/set after rest <br>&emsp; + Finish: `deactivateSession` → `resetSession` → navigate to `WorkoutSuccessScreen` <br> - Build **WorkoutSuccessScreen** <br>&emsp; + Trophy screen with exercise summary (exercises done, sets, total reps) <br>&emsp; + Blocks hardware back button → force navigate to Home | 02/14/2026 | 02/14/2026 | |

### Week 6 Achievements:

* **Backend — Session module**:
  * `UserWorkoutSession` + `WorkoutLog` entities persisted correctly with cascade DELETE.
  * `POST /api/sessions` creates a session linked to a plan and user; `PATCH /{id}/deactivate` marks it done.
  * `POST /api/sessions/{id}/logs` records individual set logs (exercise, set number, reps, weight).
  * `GET /user/{userId}/active` correctly returns the in-progress session or null.
  * Date-filtered query `GET /by-date?date=` working for session history retrieval.
* **Frontend — Live Workout**:
  * `PlanDetailScreen` loads active plan; day selector filters exercises by `dayOfWeek`.
  * Session state fully managed in Redux `workoutSessionSlice` — persisted to AsyncStorage for crash recovery.
  * `WorkoutSessionScreen` guides user through all exercises/sets with automatic rest timer.
  * Each set logged to backend via `addWorkoutLog` API call before advancing.
  * `WorkoutSuccessScreen` shows achieved stats and prevents accidental back navigation.
  * Complete workout loop tested end-to-end: plan → start session → log sets → rest timer → finish → success.

### My Personal AWS Lab Notes (Individual Learning):

**Self-study — AWS Cognito Authentication Flow (End-to-End)**

This week I documented the complete Cognito OAuth2 auth flow to support the team’s Cognito integration work:

* **STEP 1 — User Login**: Frontend redirects the user to the Cognito Hosted UI:
  ```
  GET /oauth2/authorize?client_id=...&response_type=code&scope=openid+profile+email&redirect_uri=...
  ```
  Cognito shows the login page and verifies username/password directly (the backend never sees the password).

* **STEP 2 — Authorization Code returned**: After successful login, Cognito redirects back to the app:
  ```
  https://yourapp.com/callback?code=AUTH_CODE_123
  ```
  This code is short-lived (~1 minute) and is NOT the token yet.

* **STEP 3 — Exchange Code for Tokens**: Frontend calls Cognito:
  ```
  POST /oauth2/token
  grant_type=authorization_code&code=AUTH_CODE_123&client_id=...&redirect_uri=...
  ```
  Cognito responds with `access_token`, `id_token`, `refresh_token`, and `expires_in`.

* **Token types and roles**:
  * **access_token**: Sent as `Authorization: Bearer` header to the backend. Backend verifies this token.
  * **id_token**: Contains user identity info (`sub`, `email`, `name`). Used by the frontend to know who the user is. NOT sent to the backend for authorization.
  * **refresh_token**: Used to get new access tokens when they expire (without asking the user to log in again).

* **How the backend verifies Cognito tokens (RS256 / JWKS)**:
  * Cognito signs tokens using a **private key**. Only Cognito has the private key.
  * Cognito exposes matching **public keys** at: `https://cognito-idp.<region>.amazonaws.com/<userPoolId>/.well-known/jwks.json`
  * Spring Boot automatically downloads the public key and verifies signatures on every request.
  * Spring Security configuration: `spring.security.oauth2.resourceserver.jwt.issuer-uri=https://cognito-idp.<region>.amazonaws.com/<userPoolId>`
  * Spring checks: signature validity, expiration, issuer match, audience match.

* **Why asymmetric signing (RS256) is safer than symmetric (HS256)**:
  * With HS256, every service that verifies tokens must share the same secret. If one service leaks it, attackers can forge tokens.
  * With RS256, only Cognito holds the private key. Backend services only have the public key and CANNOT generate tokens even if compromised.

* **Limitations and mitigations**:
  * JWT is stateless — revoking an access token mid-session is not instant. If a user logs out or an account is disabled, the access token still works until it expires (typically 1 hour). Mitigation: use short-lived access tokens and revoke refresh tokens at logout via `POST /oauth2/revoke`.
  * Stolen access tokens are valid until expiry. Mitigation: HTTPS only, short expiration, HttpOnly cookies on web, XSS protection.

### AWS Knowledge Summary (Concluded from Lab Notes):

* Consolidated the Cognito OAuth2 authorization-code flow with PKCE into a clear end-to-end model for mobile/web clients.
* Separated token responsibilities correctly: Access Token for API authorization, ID Token for identity display, Refresh Token for session continuity.
* Understood RS256 trust boundaries where Cognito signs with private keys and services verify with JWKS public keys.
* Identified JWT revocation limits in stateless systems and practical mitigations with short access-token TTL and refresh-token revocation.
* Reinforced secure token handling practices across transport and storage to reduce token-theft risk.

### Next Week Plan:

* **Backend**: Build the Media module — `Image` entity, S3 integration, and `ImageController` for associating images with exercises, foods, and workout plans.
* **Frontend**: Build `SessionDetailScreen` (past workout recap) and `SessionCalendarScreen` (monthly calendar with session dots).
