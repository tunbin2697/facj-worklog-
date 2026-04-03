Step 11: Create Application Load Balancer (10-12 minutes)
Navigate to EC2 Console - Load Balancers
Go to EC2 Console - Load Balancers 

A. Create Load Balancer
Click "Create load balancer"
Select "Application Load Balancer"
Click "Create"
B. Basic Configuration
Load balancer name: myfit-backend-alb
Scheme: Internet-facing
IP address type: IPv4
C. Network Mapping
VPC: Select your created VPC from Phase 1
Mappings: Select both availability zones
us-east-1a: Select your public subnet (10.0.0.0/18)
us-east-1b: Select your public subnet (10.0.64.0/18)
D. Security Groups
Security groups:
Remove default security group
Select Backend Load Balancer SG (created in Phase 1)
E. Listeners and Routing
Create Target Group First
Click "Create target group" (opens in new tab)
Target Group Configuration
Choose a target type: IP addresses
Target group name: myfit-backend-targets
Protocol: HTTP
Port: 8080
VPC: Select your VPC
Protocol version: HTTP1
Health Check Settings
Health check protocol: HTTP
Health check path: /actuator/health
Port: Traffic port
Healthy threshold: 2
Unhealthy threshold: 3
Timeout: 5 seconds
Interval: 30 seconds
Success codes: 200
Advanced Health Check Settings
Grace period: 300 seconds
Click "Next"
Register Targets
Skip this step - ECS will register targets automatically
Click "Create target group"
Back to Load Balancer Configuration
Listener: HTTP:80
Default action: Forward to target group
Target group: Select myfit-backend-targets (refresh if needed)
F. Additional Settings (Optional)
Load balancer attributes:
Idle timeout: 60 seconds
Deletion protection: Disabled (for testing)
HTTP/2: Enabled
Access logs: Disabled (can enable later)
G. Tags
Add any desired tags for resource management

H. Create Load Balancer
Review all settings
Click "Create load balancer"
Wait for status to become "Active" (2-3 minutes)
Step 12: Create ECS Service (8-10 minutes)
Navigate to ECS Console
Go to ECS Console - Clusters 

A. Access Your Cluster
Click on your cluster: myfit-cluster
Click "Create service"
B. Environment Configuration
Compute options: Launch type
Launch type: FARGATE
Platform version: LATEST (Linux)
C. Deployment Configuration
Application type: Service
Task definition:
Family: myfit-backend-task
Revision: LATEST (or specific revision number)
D. Service Configuration
Service name: myfit-backend-service
Service type: Replica
Desired tasks: 2
E. Load Balancing
Load balancer type: Application Load Balancer
Use an existing load balancer: Yes
Load balancer: Select myfit-backend-alb
Listener: Use an existing listener (80:HTTP)
Target group: Use an existing target group
Target group name: myfit-backend-targets
Health check grace period: 180 seconds
Container to load balance:
Container: web
Port: 8080
F. Networking Configuration
VPC: Select your VPC
Subnets: Select both public subnets
10.0.0.0/18 (us-east-1a)
10.0.64.0/18 (us-east-1b)
Security groups:
Remove default security group
Select Backend Service SG (created in Phase 1)
Public IP: ENABLED (required for Fargate in public subnets)
G. Auto Scaling Configuration
Service auto scaling: Use service auto scaling
Minimum number of tasks: 1
Maximum number of tasks: 4
Target tracking scaling policies:
CPU Scaling Policy
Policy name: myfit-cpu-scaling
ECS service metric: ECSServiceAverageCPUUtilization
Target value: 70
Scale-out cooldown: 300 seconds
Scale-in cooldown: 300 seconds
Memory Scaling Policy (Optional)
Policy name: myfit-memory-scaling
ECS service metric: ECSServiceAverageMemoryUtilization
Target value: 80
Scale-out cooldown: 300 seconds
Scale-in cooldown: 300 seconds
H. Service Tags
Add any desired tags for resource management

I. Create Service
Review all configurations
Click "Create"
Step 13: Configure Service Discovery (Optional - 3 minutes)
If you want internal service discovery:

A. Create Service Discovery Service
Go to Cloud Map Console 
Create namespace: myfit.local
Create service: backend
B. Update ECS Service
Edit the ECS service
Enable service discovery
Configure with your Cloud Map service
Detailed Configuration Summary
Application Load Balancer Settings:
Name: myfit-backend-alb
Scheme: Internet-facing
IP Type: IPv4
VPC: Your VPC
Subnets: Both public subnets
Security Group: Backend Load Balancer SG
Listener: HTTP:80 → Target Group

Target Group Settings:
Name: myfit-backend-targets
Type: IP addresses
Protocol: HTTP:8080
Health Check: /actuator/health
Healthy Threshold: 2
Unhealthy Threshold: 3
Timeout: 5s
Interval: 30s

ECS Service Settings:
Name: myfit-backend-service
Launch Type: FARGATE
Task Definition: myfit-backend-task:LATEST
Desired Count: 2
Subnets: Public subnets
Security Group: Backend Service SG
Public IP: ENABLED
Load Balancer: myfit-backend-alb
Target Group: myfit-backend-targets

Auto Scaling Settings:
Min Tasks: 1
Max Tasks: 4
CPU Target: 70%
Memory Target: 80%
Scale-out Cooldown: 300s
Scale-in Cooldown: 300s

Verification Steps
1. Load Balancer Health
Go to EC2 Console - Load Balancers 
Select your ALB
Check State: Should be "Active"
Note the DNS name for testing
2. Target Group Health
Go to EC2 Console - Target Groups 
Select myfit-backend-targets
Click "Targets" tab
Wait for targets to show "healthy" status (may take 2-3 minutes)
3. ECS Service Health
Go to ECS Console 
Click your cluster → Services tab
Click myfit-backend-service
Check Status: Should be "Active"
Check Running count: Should be 2
Check Health: All tasks should be "Healthy"
4. Test Application
Copy ALB DNS name
Test endpoint: http://ALB-DNS-NAME/actuator/health
Should return HTTP 200 with health status
Common Issues & Troubleshooting
Target Registration Issues:
Symptom: Targets show "unhealthy"
Solutions:
Check security group allows port 8080 from ALB SG
Verify health check path /actuator/health is accessible
Check ECS task logs for application startup issues
Service Won't Start:
Symptom: Tasks keep stopping/restarting
Solutions:
Check CloudWatch logs for container errors
Verify all environment variables and secrets are correct
Ensure ECR image exists and is accessible
Check IAM role permissions
Load Balancer 503 Errors:
Symptom: ALB returns 503 Service Unavailable
Solutions:
Wait for targets to become healthy
Check target group health check settings
Verify application is listening on port 8080
Auto Scaling Not Working:
Symptom: Service doesn't scale up/down
Solutions:
Check CloudWatch metrics are being published
Verify scaling policies are correctly configured
Ensure service has proper IAM permissions for auto scaling