---
title: "Cloud Mastery 2026 #1 AI From Scratch"
date: 2026-03-14
weight: 2
chapter: false
pre: " <b> 4.2. </b> "
---

# Summary Report: "AI Agents, Prompt Engineering & AIoT on AWS"

### Event Objectives

- Understand the limitations of standalone LLMs and how to overcome them using AI Agents.
- Master the art of communicating with AI through proper Prompt Engineering to optimize costs and output quality.
- Explore practical applications of AIoT integrated with AWS Cloud services (IoT Core, Rekognition).

### Speakers

- **Banh Cam Vinh** - Speaker on Building AI Agent with Strands
- **Nguyen Tuan Thinh** - DevOps Engineer, Speaker on Automated Prompt Engineering
- **Aiden Dinh** - Operation Engineers (Katalon), Speakers on AIoT Projects

### Key Highlights

#### Building AI Agent with Strands

Standalone Large Language Models (LLMs) often face limitations due to a lack of real-time data and the inability to interact with external systems. AI Agents resolve this by providing:
- **Multi-step reasoning:** Planning and executing complex workflows.
- **Tool integration:** Accessing APIs, databases, and external services.
- Leveraging the **Strands Agents** framework with an **Agentic Loop** (tool calling mechanism), combining System Prompts and Knowledge Bases to make autonomous decisions and adapt dynamically.

#### Automated Prompt Engineering

Communicating with AI is an art. Generic prompts lead to poor results, wasted Tokens (increasing costs), and inconsistent outputs. 
A standard, high-quality Prompt should contain 7 core components:
1. **Role** (Persona for the AI)
2. **Instruction** (Specific task)
3. **Context** (Background information)
4. **Input Data** (Information to process)
5. **Output Format** (Expected structure)
6. **Examples** (Few-shot demonstrations)
7. **Constraints** (Guidelines or limitations to follow)

The optimized AWS architecture for managing prompts includes **Amazon DynamoDB** (for millisecond response storage), **Amazon CloudWatch** (for monitoring logs, latency, and errors), and **Amazon Bedrock**.


#### AIoT Projects: Smart Locker Management

Solving the manual borrowing process in clubs with an automated smart locker system:
- **Hardware:** Using Raspberry Pi as the Main Controller and local MQTT Broker; Arduino for sensor data collection; integrated with Reed Switches, RFID Card Readers, and Cameras.
- **AWS Cloud Integration:** - **AWS IoT Core:** Acts as the central hub routing sensor events (RFID scans, door states) to Lambda and DynamoDB, enabling scalability without a local server.
  - **AWS Rekognition:** Performs facial recognition, comparing captured images with the member database to authorize access.


#### Some event photos

![Cloudmasteries GEN AI photo 1](/images/event/Cloudmasteries%20GEN%20AI%20event/0S0A0199.jpg "Cloudmasteries GEN AI photo 1")
![Cloudmasteries GEN AI photo 2](/images/event/Cloudmasteries%20GEN%20AI%20event/0S0A9983.jpg "Cloudmasteries GEN AI photo 2")
![Cloudmasteries GEN AI photo 3](/images/event/Cloudmasteries%20GEN%20AI%20event/0S0A9994.jpg "Cloudmasteries GEN AI photo 3")

> Overall, the event not only provided deep insights into modern AI trends like Agents and Prompt Engineering but also offered practical knowledge on how to combine IoT hardware with the flexible AWS infrastructure to solve real-world problems.