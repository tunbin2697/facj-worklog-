---
title: "Cloud Mastery 2026 #2 - Kubernetes, IaC, and Elixir in DevOps"
date: 2026-04-04
weight: 3
chapter: false
pre: " <b> 4.3. </b> "
---

## Summary Report: "Cloud Mastery 2026 #2"

## Event Objectives

* Build a practical foundation for Kubernetes architecture and day-to-day operations.
* Understand Infrastructure as Code (IaC) approaches on AWS with CloudFormation, AWS CDK, and Terraform.
* Explore Elixir and OTP as a unified approach for highly concurrent and fault-tolerant DevOps systems.

## Speakers

* **Bao Huynh** - Session: Architecting for the Cloud with Kubernetes
* **Nguyen Ta Minh Triet** - Session: Elixir as a Unified Solution for Highly Concurrent and Fault-Tolerant DevOps Infrastructure
* **Khanh Phuc Thinh Nguyen** - Session: Infrastructure as Code with Terraform on AWS

## Key Highlights

### Session 1: Architecting for the Cloud with Kubernetes

The first session introduced container orchestration challenges and explained why Kubernetes is the industry-standard platform for running containerized applications at scale.

Main takeaways:
* **Core architecture:** Control Plane components (etcd, API Server, Scheduler, Controller Manager, **Cloud Controller Manager**) and Worker Node components (kubelet, kube-proxy, container runtime).
* **Essential objects:** Pods, ReplicaSets, Deployments, ConfigMaps, Secrets, and Jobs.
* **Operations basics:** Kubernetes manifests (YAML) and commonly used kubectl commands.
* **Learning path:** Start locally with Minikube, K3s, or K3d, then move to managed environments such as Amazon EKS **(which significantly reduces manual setup by fully managing the control plane)**. For a deeper understanding of underlying mechanics, **Kelsey Hightower's "Kubernetes the Hard Way"** is highly recommended.
* **Ecosystem tools:** Helm for packaging/deployments and K9s for cluster observability and operations in the terminal.

This session helped connect conceptual Kubernetes knowledge with a realistic learning path that can be applied in both personal projects and production environments.

![k8s architecture](/images/4-Event/e3k8s.png "k8s Architecture")
![actual image](/images/4-Event/ws2k8s.jpg "actual image")

---

### Session 2: Elixir for Concurrent and Fault-Tolerant DevOps Systems

The second session presented Elixir and the BEAM ecosystem as a strong option for building resilient backend platforms with high concurrency demands.

Main takeaways:
* **Elixir fundamentals:** Functional paradigm, immutable data, pattern matching, and Erlang/BEAM foundations. **Elixir features a Ruby-inspired syntax but compiles to bytecode to run on the BEAM VM, much like Java.**
* **Concurrency model:** Lightweight BEAM processes and scheduler-based execution for scalable workloads. **A remarkable showcase of this is the Phoenix Framework, benchmarking up to 2 million WebSocket connections on a single server.**
* **Fault tolerance via OTP:** Process supervision, "Let It Crash" philosophy, and robust runtime recovery.
* **Operational benefits:** Integrated tooling **(such as Mix and IEx)** for development and operations, plus support for **hot code upgrades (upgrading systems without downtime).**
* **Real-world impact:** Production case studies showing significant cost optimization when moving high-throughput workloads from serverless architectures to Elixir services **(e.g., rewriting an AWS API Gateway/Lambda Node.js service to Elixir dropped monthly costs from over $12,000 to under $400).**

This session expanded the perspective beyond common DevOps stacks and demonstrated how language/runtime choice can directly affect reliability and infrastructure cost.

![benefits](/images/4-Event/e3benefit.png)
![actual image](/images/4-Event/ws2elixir.jpg "actual image")

---

### Session 3: Infrastructure as Code with Terraform on AWS

The third session focused on Infrastructure as Code as a modern alternative to manual cloud provisioning (ClickOps), emphasizing automation, consistency, and reproducibility.

Main takeaways:
* **IaC mindset:** Define cloud infrastructure using code to reduce manual errors and improve collaboration.
* **CloudFormation fundamentals:** Templates, stacks, template anatomy **(including Parameters, Mappings, Conditions, and Outputs)**, and drift detection. **It was also noted that services like AWS Amplify utilize CloudFormation under the hood.**
* **AWS CDK concepts:** Construct levels (L1, L2, L3), construct tree, and deployment workflow with CDK CLI. **A key advantage of CDK is its support for real programming languages like TypeScript, Python, Java, C#/.Net, and Go.**
* **Terraform fundamentals:** HCL structure, project layout (basic and advanced), execution flow (`init`, `validate`, `plan`, `apply`, `destroy`), state management, **and its strength in multi-cloud deployments.**
* **Tool selection criteria:** Choosing IaC tools based on cloud strategy (One Cloud or Many), team skill set, and ecosystem compatibility. **Other alternatives like OpenTofu and Pulumi were also briefly mentioned.**

This session provided a clear comparison between AWS-native and multi-cloud IaC approaches, which is highly useful for selecting tools in real projects.

![alt text](/images/4-Event/e3cf.png)

---

## Outcomes and Value Gained

Through this event, I gained a broader and more connected view of modern cloud engineering:
* How to design and operate containerized systems with Kubernetes.
* How to reason about fault tolerance and high concurrency at the application-runtime layer using Elixir/OTP.
* How to manage infrastructure lifecycle with IaC tools across AWS and multi-cloud contexts.

![actual image](/images/4-Event/ws2team.jpg "actual image")

The event also clarified a practical roadmap: start from local Kubernetes practice, apply IaC consistently for deployments, and evaluate resilient runtime technologies such as Elixir when building highly concurrent services.

> Overall, Cloud Mastery 2026 #2 delivered a well-balanced combination of architecture principles, implementation practices, and real-world engineering trade-offs across Kubernetes, IaC, and resilient backend systems.