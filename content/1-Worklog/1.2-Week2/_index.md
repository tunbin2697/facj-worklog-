---
title: "Week 2 Worklog"
date: 2026-01-12
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

### Week 2 Objectives:

* **Backend**: Integrate AWS Cognito authentication into Spring Security. Build the `UserProfile` module.
* **Frontend**: Implement the complete authentication flow — from the Login screen through token storage and state management.
* Establish secure token handling patterns that will be reused across the entire application.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | ---- | ---------- | --------------- | ------------------ |
| 2   | - Study AWS Cognito User Pools concepts <br>&emsp; + User Pool configuration: password policies, app clients, PKCE <br>&emsp; + ID Token vs Access Token — difference and proper usage <br>&emsp; + Cognito JWT claims: `sub`, `cognito:groups`, `token_use` | 01/13/2026 | 01/13/2026 | <https://docs.aws.amazon.com/cognito/> |
| 3   | - Implement **Spring Security** JWT configuration <br>&emsp; + Add `spring-security-oauth2-resource-server` dependency <br>&emsp; + Configure `SecurityConfig`: stateless sessions, CSRF disabled, CORS enabled <br>&emsp; + Set Cognito issuer-uri in `application.properties` <br>&emsp; + Write custom `OAuth2TokenValidator` — reject tokens where `token_use != "access"` | 01/14/2026 | 01/14/2026 | <https://docs.spring.io/spring-security/> |
| 3   | - Implement role extraction from JWT <br>&emsp; + Read `cognito:groups` claim → convert to Spring `ROLE_<GROUP>` authorities <br>&emsp; + Configure `@PreAuthorize("hasRole('ADMIN')")` for admin endpoints <br>&emsp; + Define authorization rules: public endpoints, authenticated, admin-only | 01/14/2026 | 01/14/2026 | |
| 4   | - Build **UserProfile** entity & repository <br>&emsp; + Fields: `cognitoId (UNIQUE)`, `email (UNIQUE)`, `username`, `name`, `gender`, `birthdate`, `phoneNumber`, `picture`, `emailVerified` <br>&emsp; + `UserProfileRepository` extends `JpaRepository` | 01/15/2026 | 01/15/2026 | |
| 4   | - Build **UserProfileService** & **UserProfileController** <br>&emsp; + `POST /user/sync` — upsert profile from Cognito claims (IDOR-safe: `cognitoSub` from JWT `sub`) <br>&emsp; + `GET /user/{id}`, `PUT /user/{id}`, `DELETE /user/{id}` | 01/15/2026 | 01/15/2026 | |
| 5   | - Build **Frontend** `LoginScreen` <br>&emsp; + Single "Sign in with AWS Cognito" button <br>&emsp; + Initiate PKCE flow via `expo-auth-session` + `expo-web-browser` <br>&emsp; + Handle redirect callback: exchange code → tokens <br>&emsp; + Decode ID Token with `jwt-decode` to extract user claims | 01/16/2026 | 01/16/2026 | <https://docs.expo.dev/guides/authentication/> |
| 6   | - Build **authSlice** (Redux) and token storage <br>&emsp; + State: `isAuthenticated`, `user`, `token`, `refreshToken`, `hasCompletedOnboarding` <br>&emsp; + Actions: `login`, `logout`, `completeOnboarding`, `updateUserProfile` <br>&emsp; + Persist tokens to `expo-secure-store` (mobile) / `localStorage` (web) via `utils/storage.ts` <br> - Wire Axios **request interceptor**: auto-attach `Authorization: Bearer <token>` | 01/17/2026 | 01/17/2026 | |

### Week 2 Achievements:

* **Backend — Security**:
  * Spring Security fully configured with AWS Cognito as JWT issuer.
  * Custom `OAuth2TokenValidator` blocks ID tokens — only Access Tokens accepted at the API layer.
  * Role-based access control works: `ROLE_ADMIN` group from Cognito grants admin privileges.
  * All security rules defined: public health check, authenticated user routes, admin-only `/admin/**` routes.
* **Backend — UserProfile module**:
  * `POST /user/sync` correctly upserts user from Cognito JWT claims without IDOR vulnerability.
  * Full CRUD (`GET`, `PUT`, `DELETE`) on `/user/{id}` with proper authorization checks.
  * `UserProfile` entity persisted to PostgreSQL via JPA.
* **Frontend — Authentication**:
  * `LoginScreen` renders correctly; tapping the button opens Cognito Hosted UI in browser.
  * PKCE code exchange works end-to-end — tokens returned and stored securely.
  * `authSlice` correctly toggles `isAuthenticated`; `RootNavigator` redirects to the right stack.
  * Axios interceptor auto-attaches Bearer token — subsequent API calls authenticated.

### My Personal AWS Lab Notes (Individual Learning):

**Lab 2 — IAM Role Setup for Daily Use**
* Created an IAM Role with appropriate policies and configured it for daily AWS tasks instead of relying on an IAM user with long-term access keys.
* Learned: IAM Roles are preferred over IAM Users for EC2 instances and automated tasks because roles use temporary credentials (STS tokens) that auto-rotate, eliminating the risk of leaked static credentials. For human users doing daily work, a role is also better than hardcoding keys.

**Lab 3 — Amazon VPC (Virtual Private Cloud)**
* Built a VPC from scratch with public and private subnets across multiple AZs.
* Configured **Route Tables**: each route entry maps a destination CIDR to a target (IGW, NAT, local). Public subnets route `0.0.0.0/0` to the IGW; private subnets route it to the NAT Gateway.
* Deployed an **Internet Gateway (IGW)**: enables bidirectional internet traffic for resources in public subnets that have public IPs. AWS-managed, highly available, no maintenance needed.
* Compared **NAT Gateway vs NAT Instance**:
  * NAT Gateway: AWS-managed, up to 100 Gbps, no maintenance, outbound-only, requires an Elastic IP in a public subnet. No port forwarding.
  * NAT Instance: User-managed EC2, single point of failure, flexible (supports port forwarding, can act as bastion host), billing based on instance type.
* Learned **Security Group vs NACL**:
  * Security Groups attach to ENIs (Elastic Network Interfaces) — stateful, instance-level firewall.
  * NACLs attach to subnets — stateless, subnet-level firewall. Need inbound AND outbound rules.
  * Key insight: Route Tables and NACLs are subnet-level but are independent resources that subnets reference (not embedded inside subnets). Multiple subnets can share the same route table or NACL.
* Configured **VPC Endpoints**: private access points to AWS services (like S3, SSM, ECR) without going over the internet.
  * Interface endpoints use ENIs with private IPs — need Security Groups to control access.
  * Gateway endpoints (S3, DynamoDB) do not use ENIs and route through the route table.
* Fixed a tricky **EC2 Instance Connect Endpoint** misconfiguration: the EIC security group must allow outbound to the private subnet, AND the private instance security group must allow inbound from the EIC security group.
* Set up a **VPN connection** to simulate hybrid on-prem networking: a second VPC acting as the on-prem side, using AWS Site-to-Site VPN to connect private IPs securely.

**Lab 10 — Active Directory**: 

Used AWS Managed Microsoft AD (via AWS Directory Service) deployed into two private subnets to simulate an on-prem Windows domain controller for DNS and user management.

### AWS Knowledge Summary (Concluded from Lab Notes):

* Confirmed IAM roles with temporary credentials are safer than long-lived access keys for compute workloads and automation.
* Internalized VPC routing design across public/private subnets with IGW and NAT to control internet exposure.
* Distinguished Security Groups (stateful, ENI-level) from NACLs (stateless, subnet-level) for layered network security.
* Learned how VPC endpoints and Site-to-Site VPN extend private connectivity to AWS services and hybrid networks.
* Applied private-subnet deployment for managed directory services to support enterprise identity patterns securely.

### Next Week Plan:

* **Backend**: Build the common infrastructure layer — `GlobalExceptionHandler`, `CorsConfig`. Implement the `GoalType` module (first business module).
* **Frontend**: Build navigation foundation — `RootNavigator`, `AuthStack`, `MainTabs` with custom tab bar, `OnboardingStack`.
