---
title: "AWS Weekly Roundup: AWS AI/ML Scholars program, Agent Plugin for AWS Serverless, and more (March 30, 2026)"
date: 2026-03-30
weight: 3
chapter: false
pre: " <b> 3.3. </b> "
---

{{% notice info %}}
Reproduced with permission for educational use. Original: "AWS Weekly Roundup: AWS AI/ML Scholars program, Agent Plugin for AWS Serverless, and more (March 30, 2026)" by Prasad Rao — https://aws.amazon.com/blogs/aws/aws-weekly-roundup-aws-ai-ml-scholars-program-agent-plugin-for-aws-serverless-and-more-march-30-2026/
{{% /notice %}}

# AWS Weekly Roundup: AWS AI/ML Scholars program, Agent Plugin for AWS Serverless, and more (March 30, 2026)

Last week, what excited me most was the [launch of the 2026 AWS AI and ML Scholars program](https://www.linkedin.com/posts/swaminathansivasubramanian_excited-to-share-that-applications-are-ugcPost-7442263176475410433-8c8k?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAUt4OcBCLB3u7KY4pbSog9XZD5vI10JCzU) by [Swami Sivasubramanian](https://www.linkedin.com/in/swaminathansivasubramanian/), VP of AWS Agentic AI, to provide free AI education to up to 100,000 learners worldwide. The program has two phases: a Challenge phase where you will learn foundational generative AI skills, followed by a fully funded three-month Udacity Nanodegree for the top 4,500 performers. Anyone 18 or older can apply, with no prior AI or ML experience required. Applications close on June 24, 2026. Visit the [AWS AI and ML Scholars webpage](https://aws.amazon.com/about-aws/our-impact/scholars/?utm_source=linkedin&utm_medium=s-post&utm_campaign=launch) to learn more and apply.

![The AWS AI and ML Scholars Program is back](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/27/AWS-AIML.png)

I am also excited about the start of [AWS Summit](https://aws.amazon.com/events/summits/) season, kicking off with AWS Summit Paris on April 1, followed by London on April 22. AWS Summits are free in-person events where builders and innovators can learn about Cloud and AI, think big, and make new connections. [Explore the AWS Summits](https://aws.amazon.com/events/summits/#empowering-you-to-innovate-with-aws) near you and join us in person.

Now, let us dive into this week's AWS news.

## Last week's launches

Here are last week's launches that caught my attention:

- [Announcing Amazon Aurora PostgreSQL serverless database creation in seconds](https://aws.amazon.com/blogs/aws/announcing-amazon-aurora-postgresql-serverless-database-creation-in-seconds/) - Amazon Aurora PostgreSQL now offers express configuration, a streamlined setup with preconfigured defaults that supports creating and connecting to a database in seconds. With just two clicks, you can launch an Aurora PostgreSQL serverless database. You can modify certain settings during or after creation.
- [Amazon Aurora PostgreSQL now available with the AWS Free Tier](https://aws.amazon.com/about-aws/whats-new/2026/03/amazon-aurora-postgresql-aws-free-tier/) - Amazon Aurora PostgreSQL is now available on the AWS Free Tier. If you are new to AWS, you receive $100 in AWS credits upon sign-up and can earn an additional $100 in credits by using services like Amazon Relational Database Service (Amazon RDS).
- [Announcing Agent Plugin for AWS Serverless](https://aws.amazon.com/about-aws/whats-new/2026/03/agent-plugin-aws-serverless/) - With the new Agent Plugin for AWS Serverless, you can easily build, deploy, troubleshoot, and manage serverless applications using AI coding assistants like Kiro, Claude Code, and Cursor. This plugin extends AI assistants with structured capabilities by packaging skills, sub-agents, and Model Context Protocol (MCP) servers into one modular unit. It automatically loads the guidance and expertise you need throughout development to build production-ready serverless applications on AWS.
- [Amazon SageMaker Studio now supports Kiro and Cursor IDEs as remote IDEs](https://aws.amazon.com/about-aws/whats-new/2026/03/amazon-sagemaker-studio-kiro-cursor/) - You can now remotely connect from Kiro and Cursor IDEs to Amazon SageMaker Studio. This lets you use your existing Kiro and Cursor setup, including spec-driven development, conversational coding, and automated feature generation, while accessing the scalable compute resources of Amazon SageMaker Studio.
- [Introducing visual customization capability in AWS Management Console](https://aws.amazon.com/blogs/aws/customize-your-aws-management-console-experience-with-visual-settings-including-account-color-region-and-service-visibility/) - You can now customize your AWS Management Console with visual settings like account color and control which regions and services you see. Hiding unused regions and services helps you focus better and work faster by reducing cognitive load and unnecessary scrolling.
- [Announcing Aurora DSQL connector to simplify building Ruby applications](https://aws.amazon.com/about-aws/whats-new/2026/03/aurora-dsql-connector-for-ruby/) - You can now use the Aurora DSQL Connector for Ruby (pg gem) to easily build Ruby applications on Aurora DSQL. The Ruby Connector simplifies authentication and improves security by automatically generating tokens for each connection, eliminating the risks of traditional passwords while maintaining full compatibility with existing pg gem features.
- [AWS Lambda increases the file descriptor limit for functions running on Lambda Managed Instances](https://aws.amazon.com/about-aws/whats-new/2026/03/aws-Lambda-file-descriptors-increase-4096/) - AWS Lambda increases the file descriptor limit from 1,024 to 4,096, a 4x increase, for functions running on Lambda Managed Instances (LMI). You can now run I/O intensive workloads such as high-concurrency web services and file-heavy data processing pipelines without running into file descriptor limits.
- [AWS Lambda now supports up to 32 GB of memory and 16 vCPUs for Lambda Managed Instances](https://aws.amazon.com/about-aws/whats-new/2026/03/lambda-32-gb-memory-16-vcpus/) - AWS Lambda functions on Lambda Managed Instances now support up to 32 GB of memory and 16 vCPUs. You can run compute-intensive workloads like data processing, media transcoding, and scientific simulations without managing infrastructure. Plus, you can adjust the memory-to-vCPU ratio (2:1, 4:1, or 8:1) to fit your workload.
- [Announcing Bidirectional Streaming API for Amazon Polly](https://aws.amazon.com/blogs/machine-learning/introducing-amazon-polly-bidirectional-streaming-real-time-speech-synthesis-for-conversational-ai/) - Traditional text-to-speech APIs use a request-response pattern. The new Bidirectional Streaming API for Amazon Polly is designed for conversational AI applications that generate text or audio incrementally, like large language model (LLM) responses. This lets you start synthesizing audio before the full text is available.

For a full list of AWS announcements, be sure to keep an eye on our [News Blog](https://aws.amazon.com/blogs/aws/) channel and the [What's New with AWS](https://aws.amazon.com/new/) page.

## Upcoming AWS events

Check your calendar and sign up for upcoming AWS events:

- [AWS Summits](https://aws.amazon.com/events/summits/) - As I mentioned earlier, join AWS Summits in 2026 for free in-person events where you can explore emerging cloud and AI technologies, learn best practices, and network with industry peers and experts. Upcoming Summits include Paris (April 1), London (April 22), Bengaluru (April 23-24), Singapore (May 6), Tel Aviv (May 6), and Stockholm (May 7).
- [AWS Community Days](https://aws.amazon.com/developer/community/community-days/) - Community-led conferences where content is planned, sourced, and delivered by community leaders, featuring technical discussions, workshops, and hands-on labs. Upcoming events include San Francisco (April 10) and Romania (April 23-24).

Join the [AWS Builder Center](https://builder.aws.com/) to connect with builders, share solutions, and access content that supports your development. Browse the [AWS Events and Webinars](https://aws.amazon.com/events/) for upcoming AWS-led in-person and virtual events and developer-focused events.

That is all for this week. Check back next Monday for another [Weekly Roundup](https://aws.amazon.com/blogs/aws/tag/week-in-review/?trk=7c8639c6-87c6-47d6-9bd0-a5812eecb848&sc_channel=el).

- [Prasad](https://www.linkedin.com/in/kprasadrao/)

*This post is part of our Weekly Roundup series. Check back each week for a quick roundup of interesting news and announcements from AWS.*
