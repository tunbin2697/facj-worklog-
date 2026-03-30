---
title : "Clean-up"
date : 2024-01-01
weight : 5
chapter : false
pre : " <b> 5.5. </b> "
---

# 5.5 Clean-up Resources

Delete all workshop resources to avoid unexpected charges.

This section assumes the workshop resources were created using the earlier steps. The screenshots below use the current cleanup image set, so you can match them against your own environment before deleting anything.

## Recommended Order

1. Delete ALB listener rules if you want to keep the load balancer available briefly.
2. Delete the Application Load Balancer.
3. Delete the Target Group.
4. Terminate the EC2 backend instance.
5. Delete the Cognito User Pool and app client.
6. Delete the ACM certificate if you created one for this lab.
7. Delete CloudWatch log groups created for the workshop.
8. Delete custom IAM roles and security groups created only for this lab.
9. Delete the VPC and any remaining subnets, route tables, gateways, or endpoints after all dependent resources are gone.

{{% notice warning %}}
Always verify there are no shared resources before deleting IAM roles or security groups.
{{% /notice %}}

## 1. Delete ALB listener rules

If your load balancer still exists, remove the listener rules first so the ALB can be deleted cleanly without leaving behind application-specific routing.

## 2. Delete the Application Load Balancer

![Delete ALB](/images/5-Workshop/workshop-resource/cleanup/clean%20alb.png)

After the listener rules are removed, delete the ALB itself. This stops any inbound traffic and prevents the load balancer from continuing to incur charges.

## 3. Delete the Target Group

![Delete target group](/images/5-Workshop/workshop-resource/cleanup/clean%20targetgoup.png)

Once the ALB no longer depends on the target group, remove the target group to clear the remaining load-balancing configuration.

## 4. Terminate the EC2 backend instance

![Terminate EC2](/images/5-Workshop/workshop-resource/cleanup/clean%20ec2.png)

Terminate the EC2 instance after the target group is deleted. This ensures the backend is no longer running and avoids any compute charges.

## 5. Delete the Cognito User Pool and app client

![Delete Cognito](/images/5-Workshop/workshop-resource/cleanup/clean%20cognito.png)

Delete the user pool only after you no longer need sign-in for the workshop. Removing the app client at the same time keeps the Cognito setup fully cleaned up.

## 6. Delete the ACM certificate

![Delete ACM](/images/5-Workshop/workshop-resource/cleanup/cleanup%20acm.png)

If you requested an ACM certificate for HTTPS, delete it after the ALB is removed. ACM certificates are free, but cleaning them up keeps the account tidy.

## 7. Delete CloudWatch log groups

Delete any log groups created by the workshop so old application logs do not remain in CloudWatch.

## 8. Delete custom IAM roles and security groups

Remove workshop-only IAM roles and security groups once no resource still depends on them.

## 9. Delete the VPC and remaining networking resources

![Delete VPC](/images/5-Workshop/workshop-resource/cleanup/clean%20vpc.png)

Delete the VPC last, after all subnets, route tables, internet gateways, NAT gateways, and endpoints have been removed. This is the final cleanup step for the workshop network.

## Final Verification

- No running EC2 instances
- No ALB or Target Group
- No workshop Cognito User Pool
- No workshop ACM certificate
- No workshop-specific CloudWatch log groups
- No workshop VPC or leftover networking resources

