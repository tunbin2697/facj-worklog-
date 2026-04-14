---
title: "Cloud Mastery 2026 #3 - Networking, Security, and IAM on AWS"
date: 2026-04-11
weight: 4
chapter: false
pre: " <b> 4.4. </b> "
---

## Summary Report: "Cloud Mastery 2026 #3"

## Event Objectives

* Build a practical foundation for designing and securing network infrastructure on AWS using VPCs, Subnets, and Gateways.
* Understand the comprehensive suite of AWS Network & Application Protection services to defend against DDoS attacks and web exploits.
* Explore Identity & Access Management (IAM) best practices, multi-account governance with SSO, and advanced permission control mechanisms.

## Speakers

* **Lam An Thinh & Nguyen Phan Quoc Viet** - Session: Networking on AWS
* **Lam Tuan Kiet** - Session: AWS Network & Application Protection
* **Huynh Hoang Long & Dang Thi Minh Thu** - Session: Identity & Access Management

## Key Highlights

### Session 1: Networking on AWS

The first session introduced the core components of AWS networking, emphasizing how to control the "blast radius" and manage traffic flow within a Virtual Private Cloud (VPC).

Main takeaways:
* **Core Components:** Key building blocks include VPC & CIDR, Subnets (defining network size), Internet Gateways (IGW), and Route Tables for traffic direction.
* **NAT Gateway Architecture:** Enables resources in Private Subnets to reach the internet for updates while blocking unsolicited inbound connections. It utilizes Source NAT (SNAT) and Port Address Translation (PAT) to manage traffic from multiple instances.
* **Security Group vs. NACL:** Security Groups act as stateful firewalls at the instance level (ENI), remembering connection states to allow return traffic automatically. In contrast, Network ACLs (NACLs) are stateless firewalls at the subnet level that evaluate rules in numerical order and require manual configuration for both inbound and outbound traffic.
* **Network Isolation:** Proper subnetting and routing ensure that sensitive resources remain protected from the public internet while still maintaining necessary outbound connectivity.

![vpc architecture](/images/4-Event/e4vpc.jpg "actual")

---

### Session 2: Identity & Access Management (IAM)

The second session covered the critical principles of identity and access control, highlighting the importance of the "Least Privilege" principle.

Main takeaways:
* **IAM Best Practices:** Essential security measures include enabling MFA for all users, deleting root access keys, using IAM Roles for operations, and avoiding wildcards in policy actions.
* **AWS IAM Identity Center (SSO):** Provides a centralized portal for multi-account access. It is preferred over long-term access keys as it issues short-term, temporary credentials.
* **Governance at Scale:** Service Control Policies (SCPs) define the maximum permissions for all accounts in an organization, while Permission Boundaries set the upper limit for specific IAM Users or Roles to prevent privilege escalation.
* **Automation & Monitoring:** Utilizing IAM Access Analyzer helps identify resources shared with external entities, while automated credential rotation via Secrets Manager and Lambda reduces the risk of leaked keys.

![iam boundary](/images/4-Event/e4iam.jpg "IAM Boundary")


---

### Session 3: AWS Network & Application Protection

The final session focused on perimeter defense and advanced threat mitigation, detailing how to protect applications from external attacks.

Main takeaways:
* **AWS WAF (Web Application Firewall):** Protects web applications from common exploits like SQL Injection and Cross-Site Scripting (XSS). It filters HTTP/HTTPS requests and integrates with CloudFront, ALB, and API Gateway.
* **AWS Shield:** Provides managed DDoS protection. The Standard tier offers automatic protection against common infrastructure attacks, while the Advanced tier provides enhanced mitigation, access to the Shield Response Team, and cost protection.
* **AWS Network Firewall:** A managed service that deploys security boundaries across VPCs, offering intrusion prevention (IPS) and stateful/stateless traffic filtering at the network level.
* **AWS Firewall Manager:** A centralized tool that automates security policy management across multiple accounts, ensuring consistent WAF, Shield, and Network Firewall rules throughout an organization.

![waf architecture](/images/4-Event/e4waf.jpg "WAF Architecture")

---
## Outcomes and Value Gained

This event provided a comprehensive roadmap for architecting secure environments on AWS:
* Mastered the design of isolated network topologies using VPCs and tiered subnets.
* Developed a multi-layered defense strategy combining instance-level, subnet-level, and application-level firewalls.
* Learned to govern identities across complex, multi-account organizations using advanced IAM features.

![actual event image](/images/4-Event/ws3team.jpg "Event audience")

The session reinforced that robust cloud security is a combination of strict network boundaries, specialized application protection, and a zero-trust approach to identity management.

> Overall, Cloud Mastery 2026 #3 delivered high-impact knowledge ranging from foundational networking to sophisticated organizational security governance.
