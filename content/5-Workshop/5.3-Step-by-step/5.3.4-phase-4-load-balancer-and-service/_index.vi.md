---
title: "Phase 4 - Load Balancer and Service"
date: 2026-04-03
weight: 4
chapter: false
pre: " <b> 5.3.4. </b> "
---

## 1. Tạo target group

- Mở EC2 Console - `Target groups` - `Create target group`.
- Chọn Target type: `IP addresses`.
- Nhập Target group name: `<your-target-group-name>`.
- Chọn Protocol: `HTTP`.
- Nhập Port: `80`.
- Chọn VPC: `vpc-0c93d1f17635865a7`.
- Nhập Health check protocol: `HTTP`.
- Nhập Health check path: `/test/health`.
- Nhập Health check port: `traffic-port`.
- Nhập Healthy threshold: `5`.
- Nhập Unhealthy threshold: `2`.
- Nhập Timeout: `5`.
- Nhập Interval: `30`.
- Nhập Success codes: `200-399`.
- Bấm `Create target group`.
![Create target group screen](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/target%20group/target%20group.png)

## 2. Tạo application load balancer

- Mở EC2 Console - `Load balancers` - `Create load balancer`.
- Chọn `Application Load Balancer`.
![Create ALB screen 1](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%201.png)

- Nhập Load balancer name: `<your-alb-name>`.
- Chọn Scheme: `internet-facing`.
- Chọn IP address type: `ipv4`.
![Create ALB screen 2](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%202.png)

- Chọn VPC: `vpc-0c93d1f17635865a7`.
- Chọn subnet `subnet-08b30664885ff91ec` (`us-east-1a`).
- Chọn subnet `subnet-06ba3f4e55b68d1f8` (`us-east-1b`).
![Create ALB screen 3](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%203.png)

- Xóa default security group.
- Chọn security group: `sg-08002e12b1aa827d0`.
![Create ALB screen 4](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%204.png)

- Nhập Listener protocol/port: `HTTP:80`.
- Chọn Default action: `Forward to <your-target-group-name>`.
![Create ALB screen 5](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%205.png)

- Kiểm tra toàn bộ trường.
- Bấm `Create load balancer`.
![Create ALB screen 6](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%206.png)

- Chờ ALB status là `active`.
- Sao chép ALB DNS name: `<your-alb-dns-name>`.
![Create ALB screen 7](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/alb/alb%207.png)

## 3. Tạo ECS service

- Mở ECS Console - `Clusters` - `<your-ecs-cluster-name>` - `Create service`.
![Create ECS service screen 1](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service1.png)

- Chọn Launch type: `FARGATE`.
- Chọn Task definition family: `<your-task-definition-family>`.
- Chọn Task definition revision: `LATEST`.
![Create ECS service screen 2](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service2.png)

- Nhập Service name: `<your-ecs-service-name>`.
- Chọn Service type: `REPLICA`.
- Nhập Desired tasks: `2`.
![Create ECS service screen 3](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service3.png)

- Chọn Load balancer type: `Application Load Balancer`.
- Chọn Use existing load balancer: `Yes`.
- Chọn Load balancer: `<your-alb-name>`.
- Chọn Listener: `HTTP:80`.
- Chọn Target group: `<your-target-group-name>`.
- Nhập Health check grace period: `180`.
- Chọn Container name: `web`.
- Chọn Container port: `8080`.
![Create ECS service screen 4](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service4.png)

- Chọn VPC: `vpc-0c93d1f17635865a7`.
- Chọn subnet `subnet-08b30664885ff91ec`.
- Chọn subnet `subnet-06ba3f4e55b68d1f8`.
- Xóa default security group.
- Chọn security group: `sg-04c05a2f2abab96cc`.
- Chọn Public IP: `ENABLED`.
![Create ECS service screen 5](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service5.png)

- Chọn Deployment controller type: `ECS`.
- Bấm `Next`.
![Create ECS service screen 6](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service6.png)

## 4. Cấu hình auto scaling cho ECS service

- Bật Service auto scaling.
- Nhập Minimum task count: `2`.
- Nhập Maximum task count: `4`.
![Create ECS service screen 7](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service7.png)

- Tạo Target tracking policy.
- Nhập Policy metric: `ECSServiceAverageCPUUtilization`.
- Nhập Target value: `70`.
- Nhập Scale-out cooldown: `60`.
- Nhập Scale-in cooldown: `60`.
![Create ECS service screen 8](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service8.png)

## 5. Tạo service và xác nhận

- Kiểm tra toàn bộ trường.
- Bấm `Create`.
- Xác nhận ECS service status: `ACTIVE`.
- Xác nhận Desired count: `2`.
![Create ECS service screen 9](/images/workshop/Phase%204%20Load%20Balancer%20and%20Service/ecs%20service/ecs%20service9.png)

## 6. Checklist hoàn tất phase

1. Xác nhận target group protocol/port là `HTTP:80` và health check path là `/test/health`.
2. Xác nhận ALB scheme là `internet-facing`, listener là `HTTP:80`, và default action forward đến target group.
3. Xác nhận ECS service launch type là `FARGATE`, scheduling strategy là `REPLICA`, desired count là `2`.
4. Xác nhận ECS service network dùng subnet , security group, public IP `ENABLED`.
5. Xác nhận ECS service load balancer mapping dùng container `web` port `8080` với target group.
6. Lưu ý là sau này, với thay đổi trong CDK thì auto scaling min/max là `2/4` và CPU target policy là `70` với cooldown `60/60`.
