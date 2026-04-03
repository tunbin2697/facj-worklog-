---
title: "Phase 4 - Load Balancer and Service"
date: 2026-04-03
weight: 4
chapter: false
pre: " <b> 5.3.4. </b> "
---

## 1. Create target group

- Open EC2 Console - `Target groups` - `Create target group`.
- Select Target type: `IP addresses`.
- Enter Target group name: `<your-target-group-name>`.
- Select Protocol: `HTTP`.
- Enter Port: `80`.
- Select VPC: `vpc-0c93d1f17635865a7`.
- Enter Health check protocol: `HTTP`.
- Enter Health check path: `/test/health`.
- Enter Health check port: `traffic-port`.
- Enter Healthy threshold: `5`.
- Enter Unhealthy threshold: `2`.
- Enter Timeout: `5`.
- Enter Interval: `30`.
- Enter Success codes: `200-399`.
- Click `Create target group`.
![Create target group screen](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/target%20group/target%20group.png)

## 2. Create application load balancer

- Open EC2 Console - `Load balancers` - `Create load balancer`.
- Select `Application Load Balancer`.
![Create ALB screen 1](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%201.png)

- Enter Load balancer name: `<your-alb-name>`.
- Select Scheme: `internet-facing`.
- Select IP address type: `ipv4`.
![Create ALB screen 2](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%202.png)

- Select VPC: `vpc-0c93d1f17635865a7`.
- Select subnet `subnet-08b30664885ff91ec` (`us-east-1a`).
- Select subnet `subnet-06ba3f4e55b68d1f8` (`us-east-1b`).
![Create ALB screen 3](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%203.png)

- Remove default security group.
- Select security group: `sg-08002e12b1aa827d0`.
- Enter Listener protocol/port: `HTTP:80`.
![Create ALB screen 4](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%204.png)

- Select Default action: `Forward to <your-target-group-name>`.
- Select `<your target group>`
![Create ALB screen 6](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%206.png)

- Review all fields.
- Click `Create load balancer`.
![Create ALB screen 5](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%205.png)

- Wait for ALB status `active`.
- Copy ALB DNS name: `<your-alb-dns-name>`.

## 3. Create ECS service

- Open ECS Console - `Clusters` - `<your-ecs-cluster-name>` - `Create service`.
![Create ECS service screen 1](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service1.png)

- Select Task definition family: `<your-task-definition-family>`.
- Select Task definition revision: `LATEST`.
- Enter Service name: `<your-ecs-service-name>`.
![Create ECS service screen 2](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service2.png)

- Select Service type: `REPLICA`.
- Enter Desired tasks: `2`.
![Create ECS service screen 3](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service3.png)


- Select VPC: `<your-vpc-id>`.
- Select subnet `<your-subnet-id-1>`.
- Select subnet `<your-subnet-id-2>`.
- Remove default security group.
- Select security group: `<backend-service-sg>`.
- Select Public IP: `ENABLED`.
![Create ECS service screen 4](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service4.png)

- Select Load balancer type: `Application Load Balancer`.
- Select Use existing load balancer: `Yes`.
- Select Load balancer: `<your-alb-name>`.
- Select Listener: `HTTP:80`.
- Select Target group: `<your-target-group-name>`.
- Enter Health check grace period: `180`.
- Select Container name: `web`.
- Select Container port: `8080`.
![Create ECS service screen 5](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service5.png)

- Use default listenner.
![Create ECS service screen 6](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service6.png)

## 4. Configure ECS service auto scaling

- Enable Service auto scaling.
- Enter Minimum task count: `1`.
- Enter Maximum task count: `4`.
![Create ECS service screen 7](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service7.png)

- Create Target tracking policy.
- Enter Policy metric: `ECSServiceAverageCPUUtilization`.
- Enter Target value: `70`.
- Enter Scale-out cooldown: `300`.
- Enter Scale-in cooldown: `300`.
![Create ECS service screen 8](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service8.png)

## 5. Create service and verify

- Review all fields.
- Click `Create`.
- Confirm ECS service status: `ACTIVE`.
- Confirm Desired count: `2`.
![Create ECS service screen 9](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service9.png)

## 6. Phase completion checklist
1. Verify that the target group protocol/port is `HTTP:80` and the health check path is `/test/health`.
2. Verify that the ALB scheme is `internet-facing`, the listener is `HTTP:80`, and the default action forwards to the target group.
3. Verify that the ECS service launch type is `FARGATE`, the scheduling strategy is `REPLICA`, and the desired count is `2`.
4. Verify that the ECS service network uses the correct subnets, security groups, and has public IP set to `ENABLED`.
5. Verify that the ECS service load balancer mapping uses container `web` on port `8080` with the target group.
6. Verify that auto scaling min/max is `2/4` and the CPU target policy is `70` with cooldown `60/60`.
