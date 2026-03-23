# week1

ngày 9/1:  
module 01-04  
availability zone là 1 hoặc nhiều trung tâm dữ liệu (datacenter) giúp fault isolation. \=\> khuyến khích triển khai ở nhiều az, trong các bài thi cũng yêu cầu từ 2 az đổ lên  
   
1 aws region bao gồm tối thiểu 3 az, hiện tại hơn 25 region toàn cầu. kết nối với nhau bởi hệ thống mạng backbone của aws, tùy vào vị trí địa lí của người dùng để chọn. vài yếu tố ảnh hưởng là 1 số dịch vụ giới hạn region hoặc về chi phí. thường thì region càng lâu đời thì càng rẻ hơn so với region mới. 

edge location: mạng lưới trung tâm dữ liệu aws. bao gồm các dịch vụ: cloundfront (CDN), Web application firewall, route s3 (dns) 

module 01-05  
root user là tài khoản đăng ký aws đầu tiên, hạn chế dùng, nên dùng iam user (là các tài khoản con để dùng các dịch vụ của aws)  
   
mỗi service có trang console riêng để quản lý. ngoài ra có aws cli.   
aws sdk hỗ trợ manage credential, retry, serialization, deserialization 

 module 01-06  
tối ưu hóa chi phí: tùy nhu cầu, dùng các thanh toán giảm giá như reserved instance (thuê dài hạn lấy giảm giá), saving plan, spot (giá rất thấp nhưng có thể bị cancel bất cứ lúc nào). dùng tài nguyên bật tắt tự động, serverless.

thiết kế kiến trúc tối ưu cho bài toán \+ thiết lập  budget, quản lý theo cost allocation tag. 

kiếm tiền cho doanh nghiệp và tiết kiệm tiền cho doanh nghiệp. 

module 01-07 thực hành  
tạo tài khoản, thiết lập mfa, tài khoản và nhóm admin, xác thực. (mã 000001\)  
tạo cost budget, usage budget, reservation budget, saving plan budget (mã 000007\)  
tham khảo thông tin hỗ trợ (mã 000009\)

[docs.aws.amazon.com/wellarchitected/](http://docs.aws.amazon.com/wellarchitected/)

module 01-lab01-01  
tạo tài khoản:  
đã hoàn thành từ trước:

module1-lab01-02  
đã thiết lập mfa từ khi mới tạo tài khoản. note: đừng xóa app mfa, lỡ xóa thì có thể mở support case. có nhiều cách để tạo mfa, cách thường dùng là dùng app hỗ trợ như google auth, hoặc dùng usb vật lý u2f, hoặc dùng extension. 

module1-lab01-03  
tạo user group, bài này cũng khá cơ bản, chỉ cần làm theo. Note: user group giúp phân quyền cho nhiều người dùng, giúp quản lý và phát triển dự án tốt hơn trong khi đảm bảo được bảo mật và vai trò. 

brainstorm idea for final project

# week2

decide final project and pick architecture, techstack, pick basic aws service base on info from Amazon Q

lab2: setup iam role, that is better for daily tasks and is recommended. For later labs, the instruction focus only creates new roles and policies rather than using the root account. 

lab3: Amazon Virtual Private Cloud (Amazon VPC)

Note:

1. Route tables consist of route entries that specify:  
   1. Destination \- The destination CIDR block where you want traffic to go  
   2. Target \- The gateway, network interface, or connection through which to send the traffic  
2. Internet Gateways perform two essential functions:  
   1. Route Table Integration \- IGWs serve as a target in your VPC route tables for internet-bound traffic  
   2. Network Address Translation (NAT) \- IGWs perform network address translation for instances with public IP addresses

Internet Gateway (IGW)

* Purpose: Provides direct internet access for resources in public subnets  
* Direction: Enables bidirectional communication \- both inbound and outbound traffic  
* Usage: Used by EC2 instances in public subnets that have public IP addresses  
* Management: Fully managed by AWS, no maintenance required  
* Availability: Highly available and redundant by design  
* Requirements: Instances need public IP addresses (Elastic IP or auto-assigned public IP)

NAT Gateway

* Purpose: Allows instances in private subnets to access the internet for outbound connections only  
* Direction: Outbound only \- instances can initiate connections to the internet but cannot receive unsolicited inbound connections  
* Management: Fully managed by AWS service  
* Availability: Highly available within a single Availability Zone, with built-in redundancy  
* Bandwidth: Up to 100 Gbps  
* Types:  
  * Public NAT Gateway (for internet access)  
  * Private NAT Gateway (for VPC-to-VPC or on-premises connectivity)  
* Location: Must be placed in a public subnet  
* IP Address: Requires an Elastic IP address (for public NAT Gateway)  
* Maintenance: No user maintenance required

NAT Instance

* Purpose: Same as NAT Gateway \- allows private subnet instances to access internet outbound only  
* Management: User-managed EC2 instance that you configure and maintain  
* Availability: Depends on the instance type and your configuration \- single point of failure  
* Bandwidth: Varies based on instance type and size  
* Maintenance: You're responsible for software updates, patches, and high availability setup  
* Flexibility: More customizable \- supports port forwarding, can be used as bastion server  
* Cost: Charged based on EC2 instance pricing

## Key Comparison Summary

| Feature | Internet Gateway | NAT Gateway | NAT Instance |
| ----- | ----- | ----- | ----- |
| **Traffic Direction** | Bidirectional | Outbound only | Outbound only |
| **Target Subnet** | Public subnets | Private subnets | Private subnets |
| **Management** | AWS managed | AWS managed | User managed |
| **Availability** | Highly available | Highly available in AZ | User dependent |
| **Bandwidth** | No limits | Up to 100 Gbps | Instance dependent |
| **Port Forwarding** | N/A | Not supported | Supported |
| **Bastion Server** | N/A | Not supported | Supported |
| **Maintenance** | None | None | User responsibility |

Use Cases

* Internet Gateway: For web servers, application servers that need direct internet access  
* NAT Gateway: For database servers, application servers in private subnets that need to download updates or access external APIs  
* NAT Instance: When you need custom NAT functionality, port forwarding, or want to use it as a bastion host

The security group is at instance level while network ACL (access control list) is at subnet level. 

This lab is hard, too hard to handle. 

Note from subnet components:  
**Route tables and NACLs are subnet-level controls that are associated with subnets, but they are independent resources.**  
So:

* They are **not embedded inside the subnet**  
* But **subnets reference them**

AWS separates them so:

* Multiple subnets can share the same route table  
* Multiple subnets can share the same NACL


**VPC Endpoints:**  
A VPC Endpoint is a private network access point ( or a service in simple terms) that lets resources in my VPC reach AWS-managed services (those AWS-managed services that normally live on AWS’s public network) without using the internet.  
For interface endpoints (like EC2 API, SSM, ECR, CloudWatch, Secrets Manager…), AWS creates ENIs with private IPs inside my subnets, and we attach Security Groups to those ENIs to control which resources are allowed to connect to the service. For gateway endpoints like S3, DynamoDB (which is the other type of VPC endpoints) do not need ENIs.

Seems like: Creating a VPC Flow Log does NOT immediately create the CloudWatch log group. AWS only creates the log group when the first log event is successfully delivered.

In creating EC2 instance endpoint lab, there is a missconfiguration that may lead to failure using ec2 instance connect endpoint later, the thing is we must allow outbound connection of EIC sg to the private subnet. Another step is we need to add Inbound rules from EIC sg in private sg. 

Set up VPN connection: to securely connect AWS VPC with an on-premise network using private IPs. In the Lab setup, that second VPC is pretending to be an on-prem server.

lab10:  
**Active Directory** is a Microsoft service used to manage users, computers, and resources in a network from a central place  
To set up DNS emulation on-premises, we will utilize the AWS Directory Service to deploy AWS Managed Microsoft Active Directory in two private subnets created by CloudFormation.

| On-prem | AWS workshop |
| ----- | ----- |
| Windows Server DCs | AWS Managed Microsoft AD |
| Internal LAN | VPC |
| Office PCs / servers | EC2 instances |
| Internal DNS | AD-integrated DNS |
| IT admins | You (via AD tools) |

# security group

## **1\. Security Groups are NOT attached to subnets**

In a Amazon VPC:

* **Security Groups (SG)** are attached to **ENIs (Elastic Network Interfaces)**.  
* Practically, this means they are attached to:  
  * EC2 instances  
  * ECS tasks  
  * Load balancers  
  * Lambda ENIs  
  * RDS instances

So the relationship is:

VPC  
 ├── Subnet  
 │    ├── EC2 instance  
 │    │     └── Security Group

**Key point:**  
Security Groups **do not belong to a subnet**. Multiple instances in the same subnet can use completely different SGs.

---

## **2\. Routing happens at the subnet level, not security group**

Routing is controlled by **Route Tables**, which are associated with **subnets**.

Example:

VPC: 10.0.0.0/16

Subnet A (10.0.1.0/24)  
   Route Table:  
      10.0.0.0/16 → local  
      0.0.0.0/0   → Internet Gateway

Subnet B (10.0.2.0/24)  
   Route Table:  
      10.0.0.0/16 → local  
      0.0.0.0/0   → NAT Gateway

So:

* **Routing decision:** Subnet route table  
* **Traffic filtering:** Security group

---

## **3\. Security Groups operate at instance level (L4 firewall)**

Security Groups are **stateful firewalls**.

Example rule:

Inbound:  
Allow TCP 443 from 0.0.0.0/0

Traffic flow:

Internet  
   ↓  
Route Table → Internet Gateway  
   ↓  
Subnet  
   ↓  
Security Group check  
   ↓  
EC2 instance

If the SG blocks it → packet dropped.

---

## **4\. Why people say "SG works at VPC level"**

Because:

* SGs are **defined at VPC scope**  
* Any resource **in the same VPC** can use them  
* They are **not limited to a subnet**

But they **still enforce rules at the ENI level**, not at the VPC routing layer.

---

✅ **Correct mental model**

| Component | Scope | Purpose |
| ----- | ----- | ----- |
| Route Table | Subnet | Decide where packets go |
| Security Group | ENI / Instance | Allow or block traffic |
| NACL | Subnet | Stateless subnet firewall |

---

## **5\. Real packet path example**

Example: user → ALB → ECS task

Internet  
   ↓  
Internet Gateway  
   ↓  
Public Subnet Route Table  
   ↓  
ALB Security Group  
   ↓  
ALB  
   ↓  
Private Subnet Route Table  
   ↓  
ECS Task Security Group  
   ↓  
Container

Routing happens **before** SG filtering.

# week3

hands on lab4

hands on lab14   
https://000014.awsstudygroup.com/

use VMWare Workstation to create VM, use Ubuntu 24LTS as the operation system.   
so vm can be exported. We use aws s3 to store the vm image.

Note that later on this lab, we will ssh to ec2, so chose the live server version for lighter and no GUI.  

Notice that some ui have changed, there are more options but the core method is still the same.  
The workshop uses a bucket name: **import-bucket-2021,**  that is taken and we can not use the same name, so we should have our own and replace all usages.   
At step 2.3, we will properly not see the role auto created, so try to follow the workshop to create role and update policy. 

These are those Warning:   
For On-premise virtual machines, make sure you are not using UEFI boot for the virtual machine. UEFI boot is not supported on AWS. The conversion will fail and an error ClientError: EFI partition detected will appear. UEFI booting is not supported in EC2.  
For Linux VMs, check for the latest kernel version supported by AWS. Newer kernels that support AWS won’t do it. Operating System Requirements can be found at

when trying to do:   
aws ec2 import-image \--description "VM Image" \--disk-containers Format=vhdx,UserBucket="{S3Bucket=import-bucket-2021,S3Key=Ubuntu.vhdx}"

I changed the bucket name to mine: tunbin-bucket-vm-import-2026 but it seems like S3Key=Ubuntu.vhdx is not a valid key. turns out it must be the Name of the .vmdk file that you uploaded earlier. 

AMIs is an EC2’s feature ? wow. Good to know.   
Basically, AMIs is the saved template that helps create an EC2 instance. There are plenty of sample AMIs. 

After some checking with  aws ec2 describe-import-image-tasks \--import-task-ids import-ami-bb7…  
It takes a bit too long to boot, so I need to be patient.

key pair is use to login, ssh to server ?  
The keypair has 2 types: RSA and ED… some things look like ssh keys. 

![][image1]

**S3 Access Control Lists (ACLs)** are a legacy access management mechanism in Amazon S3 that enable you to manage access to buckets and objects. Each bucket and object has an ACL attached to it as a subresource that defines which AWS accounts or groups are granted access and the type of access they have.

Seem like ACL have some updated compared to the workshop, ACLs enabled show these warning:   
We recommend disabling ACLs, unless you need to control access for each object individually or to have the object writer own the data they upload. Using a bucket policy instead of ACLs to share data with users outside of your account simplifies permissions management and auditing.  
**Enabling ACLs turns off the bucket owner enforced setting for Object Ownership**  
Once the bucket owner enforced setting is turned off, access control lists (ACLs) and their associated permissions are restored. Access to objects that you do not own will be based on ACLs and not the bucket policy.

EC2 export is an old EC2 API (pre-IAM maturity).

* Does NOT rely purely on IAM  
* Hard-requires ACL-based permissions  
* Ignores modern “bucket owner enforced” mode

step 6:   
6\. Grant Permissions  
Select “Add grantee.”  
Enter the Canonical ID and select permissions:  
“Write” Objects  
“Read” for the Bucket ACL  
Save the changes.

have mislead information, AWS GovCloud (US) is not us-east-f1, so we should use the All other Regions ID. 

# week 4

Participate in AI/ML track of re:invented at floor 26, AWS office at Bitexco. 

lab130: AWS cloud front  
Amazon CloudFront is the static and dynamic content delivery service of AWS. With the ability to increase the speed and stability of your web applications, Amazon CloudFront provides a temporary (cache) storage solution for your content on Amazon Edge servers.  
2 ways to put content to CF, EC2 or S3.

For preparation step (upload the content to ec2 and s3)  
With EC2, we will configure the instance to listen to a port and serve the content at the path, ex: /content, we can access the content by going to ec2 public url and path /content. Note that we see user data files for the ec2, in the definition of aws ec2, these are config for each ec2 when starting the instance, great use for configuring many ec2 without changing the AMI if those instances use the same AMI. For the lab user data set up, I recommend debugging those because I ran into express installation with node js, the issue is because the script installed node-modules at root, which was not a project folder, so that express was not installed. To fix this, you can manually upgrade to sudo \-i  and move the [app.js](http://app.js) to a folder, then install express, and refresh pm2. 

for S3, we simply upload the object (if we not allow public access to this object, the object url can not be open to view)

Extra notes:   
Choose S3 for higher availability, (S3 have 99,999999999% eleven nines of availability), auto scale, security, and do not need extra maintenance. 

Create CloudFront Distribution  
This is the main function of CF, creating distribution url that will allow access to the content.

Origin term: in CF, we see the term “origin” which means the url of S3 object or public ip of ec2. 

After adding s3 origin to CF distribution, we will get a **CF** **Distribution domain name** and can access the content via proper url and path.   
keynote: we should add a default origin object that will serve the specific object when we use **CF** **Distribution domain name**.  

If you successfully follow the tutorial, you can see that CF is putting every thing in the same Distribution url, any path url will run into the behavior setting and serve the content. Refer to this [response]() from Amazon Q

**Test Distribution Invalidations**  
When using Amazon CloudFront to distribute resources to the website, some resources will be stored in CloudFront’s cache to speed up access for users. However, when you make changes to a cached resource but cannot change the URL to point to the new version, you need to perform Invalidations to discard the old version and reload the session. new version from the original server.

lab81: Cognito  
AWS Cognito  
AWS Cognito allows us to easily build a flow of sign-in, sign-up, verify email, change password, reset password, etc., instead of having to build a DB for users and do many things yourself like JWT, hash password, send mail verify,… This helps you focus on developing other features of the application. Users can log in directly with a username and password or through a third party like Facebook, Amazon, Google, or Apple.

In workshop code with same, the command: sam build  should will fail with no python 11 install in your machine, so consider run container app like docker engine and run sam build \--use-container

For the deploy command, you will be expected to input deploy parameters (name and other value), you must change any S3 bucket name because aws dont allow exited names. 

You should check your cognito sign up policies to make sure your client enter the password correctly:  
aws cognito-idp describe-user-pool \--user-pool-id \<userpool id\> \--region us-east-1 \--query 'UserPool.Policies.PasswordPolicy'

The workshop is mostly copy paste the code template to deploy into aws, i recommend manually setting those to get the sense of how they work together. 

# AWS CF distribution flow

### **Default Root Object Behavior**

✅ **When someone visits your distribution domain** (like   
https://d2b5rcxzmgnvyl.cloudfront.net/):

* CloudFront looks for the **Default Root Object** (in your case: index.html)  
* It goes to your **S3 origin** and fetches index.html  
* Serves it to the user

### **Path-Based Routing with Cache Behaviors**

✅ **When someone requests a specific path** (like   
https://d2b5rcxzmgnvyl.cloudfront.net/api):

* CloudFront checks which **cache behavior** matches /api  
* Routes the request to the **corresponding origin** defined in that behavior  
* Calls origin-server/api (exactly as you said)

## **Visual Example of How This Works**

Let's say you have this setup:

| CloudFront Distribution: d2b5rcxzmgnvyl.cloudfront.net  |
| :---- |
| ├── Default Root Object: index.html  |
| ├── Origin 1: S3 Bucket (static files)  |
| ├── Origin 2: EC2 API Server (your Node.js app)  |
| └── Cache Behaviors:  |
|    ├── Path: /api/\* → Routes to Origin 2 (EC2)  |
|    ├── Path: /images/\* → Routes to Origin 1 (S3)  |
|    └── Default: \* → Routes to Origin 1 (S3)  |

### **Request Flow Examples:**

**1\. User visits:**   
https://d2b5rcxzmgnvyl.cloudfront.net/

| User Request → CloudFront → Checks Default Root Object (index.html)  |
| :---- |
|                         → Routes to S3 Origin  |
|                         → Fetches index.html from S3  |
|                         → Returns to user  |

**2\. User visits:**   
https://d2b5rcxzmgnvyl.cloudfront.net/api

| User Request → CloudFront → Matches /api/\* cache behavior  |
| :---- |
|                         → Routes to EC2 Origin (your API server)  |
|                         → Calls http://your-ec2-server/api  |
|                         → Returns API response to user  |

**3\. User visits:**   
https://d2b5rcxzmgnvyl.cloudfront.net/images/logo.png

| User Request → CloudFront → Matches /images/\* cache behavior  |
| :---- |
|                         → Routes to S3 Origin  |
|                         → Fetches images/logo.png from S3  |
|                         → Returns image to user  |

**4\. User visits:**   
https://d2b5rcxzmgnvyl.cloudfront.net/about.html

| User Request → CloudFront → No specific behavior matches  |
| :---- |
|                         → Uses Default cache behavior  |
|                         → Routes to S3 Origin  |
|                         → Fetches about.html from S3  |
|                         → Returns to user  |

## **Key Points You've Understood Correctly:**

### **1\. Distribution \= Traffic Director**

The CloudFront distribution acts like a smart router that:

* Receives all requests to your domain  
* Decides which origin to forward each request to  
* Based on the path and cache behavior rules

### **2\. Origins \= Actual Servers**

* **S3 Origin**: Stores static files (HTML, CSS, images)  
* **EC2 Origin**: Runs your API/application logic  
* **ALB Origin**: Load balancer for multiple servers

### **3\. Path Preservation**

When CloudFront forwards a request:

* cloudfront.net/api/users → your-origin/api/users  
* cloudfront.net/images/logo.png → s3-bucket/images/logo.png

The path is preserved and passed to the origin exactly as requested.

## **Practical Configuration Example**

Here's how you might set this up:

| {  |
| :---- |
|  "DefaultRootObject": "index.html",  |
|  "Origins": \[  |
|    {  |
|      "Id": "S3-Static-Files",  |
|      "DomainName": "my-bucket.s3.amazonaws.com"  |
|    },  |
|    {  |
|      "Id": "EC2-API-Server",   |
|      "DomainName": "ec2-52-32-52-19.us-west-2.compute.amazonaws.com"  |
|    }  |
|  \],  |
|  "CacheBehaviors": \[  |
|    {  |
|      "PathPattern": "/api/\*",  |
|      "TargetOriginId": "EC2-API-Server",  |
|      "TTL": 300  // 5 minutes cache  |
|    },  |
|    {  |
|      "PathPattern": "/images/\*",  |
|      "TargetOriginId": "S3-Static-Files",   |
|      "TTL": 31536000  // 1 year cache  |
|    }  |
|  \],  |
|  "DefaultCacheBehavior": {  |
|    "TargetOriginId": "S3-Static-Files",  |
|    "TTL": 86400  // 1 day cache  |
|  }  |
| }  |

## **Why This Architecture is Powerful**

1. **Single Domain**: Users only need to remember one URL  
2. **Optimal Routing**: Static files from S3, dynamic content from EC2  
3. **Performance**: Each content type cached appropriately  
4. **Scalability**: CloudFront handles global distribution  
5. **Security**: Different security policies per content type

# week 6

Implement cognito into app.

first is to understand how the flow of cognito work is system

# cognito flow

# **🧠 First: Who is Who?**

In Cognito setup:

* **Cognito** → Authentication Server (issues tokens)  
* **Your Spring Boot backend** → Resource Server (protects APIs)  
* **Frontend (React / Web / Mobile)** → Client  
* **User** → Human logging in

# **🔁 The Full Flow (Real Life Version)**

## **STEP 1 — User tries to login**

Frontend redirects user to Cognito:

https://\<your-domain\>.auth.\<region\>.amazoncognito.com/oauth2/authorize

Example request:

GET /oauth2/authorize  
?client\_id=abc123  
\&response\_type=code  
\&scope=openid profile email  
\&redirect\_uri=https://yourapp.com/callback

What happens?

* Cognito shows login page  
* User enters username/password  
* Cognito verifies user (not your backend\!)

## **STEP 2 — Cognito returns an Authorization Code**

If login succeeds:

Cognito redirects back to your frontend:

https://yourapp.com/callback?code=AUTH\_CODE\_123

This `code` is short-lived (about 1 minute).  
It is NOT the token yet.

## **STEP 3 — Exchange Code for Tokens**

Now frontend (or backend) calls:

POST /oauth2/token

With:

grant\_type=authorization\_code  
code=AUTH\_CODE\_123  
client\_id=abc123  
client\_secret=xyz  
redirect\_uri=https://yourapp.com/callback

Cognito responds with:

{  
  "access\_token": "...",  
  "id\_token": "...",  
  "refresh\_token": "...",  
  "expires\_in": 3600  
}

Now we have real JWT tokens.

# **🎟 What Are These Tokens?**

## **1️⃣ access\_token**

Used to call your backend APIs.

Sent like:

Authorization: Bearer eyJhbGciOiJSUzI1NiIs...

Your Spring Boot verifies it.

## **2️⃣ id\_token**

Contains user identity info:

{  
  "sub": "user-id",  
  "email": "abc@gmail.com",  
  "name": "John",  
  "iss": "https://cognito-idp..."  
}

Used mostly by frontend to know who the user is.**3️⃣ refresh\_token**

Used to get new access tokens without logging in again.

# **🔐 How Your Backend Verifies Cognito Token**

This is the part that confuses many people.

Cognito signs tokens using **RS256 (asymmetric key)**.

That means:

* Cognito signs using PRIVATE key  
* Your backend verifies using PUBLIC key

Cognito exposes public keys at:

https://cognito-idp.\<region\>.amazonaws.com/\<userPoolId\>/.well-known/jwks.json

Spring Boot automatically downloads this.

In Spring Boot you configure:

spring.security.oauth2.resourceserver.jwt.issuer-uri=  
https://cognito-idp.\<region\>.amazonaws.com/\<userPoolId\>

That’s it.

Spring will:

* Check signature  
* Check expiration  
* Check issuer  
* Check audience

You do NOT store secret key anymore.

# **🔄 What Happens When Token Expires?**

Access token expires (usually 1 hour).

Frontend uses refresh token:

POST /oauth2/token  
grant\_type=refresh\_token  
refresh\_token=....

Cognito returns new access token.

User doesn’t notice anything.

# **🚫 What About /revoke?**

If user logs out:

Frontend calls:

POST /oauth2/revoke

Cognito invalidates the refresh token.

Access token still valid until expiration (because JWT is stateless).

That’s why access tokens are short-lived.

# **🧠 Big Mental Model**

Instead of:

Frontend → Backend (login)  
Backend → DB check  
Backend → generate JWT

Now it is:

Frontend → Cognito (login)  
Cognito → issue tokens  
Frontend → Backend (with access\_token)  
Backend → verify signature only

Your backend NEVER sees password anymore.

# **🎯 Why This Is Better?**

* You don't manage passwords  
* You don’t store secret signing keys  
* You don’t implement login security  
* Supports Google login / Facebook easily  
* Industry standard

# **🏗 For Your Legacy Spring Boot System**

Previously:

User table \= authentication \+ profile

With Cognito:

Cognito \= authentication  
Your DB \= profile data

You match user via:

sub (Cognito user ID)

# **⚠️ Common Confusion**

❓ “If Cognito generates token, how can my backend trust it?”

Because:

* It verifies signature using Cognito public key  
* It verifies issuer matches your user pool  
* It verifies audience matches your app client  
* It checks expiration

If any fail → 401

# backend key

# **🔐 Asymmetric Keys in JWT (RS256) — Complete Picture**

When using **Amazon Cognito**, JWT uses **asymmetric cryptography**.

That means there are **two keys**:

* 🔑 **Private key** → kept secret by Cognito  
* 🔓 **Public key** → shared publicly

They are mathematically linked.

# **🧠 Core Idea**

Only the **private key** can create a valid signature.  
The **public key** can only verify it.

Public key CANNOT generate tokens.

That’s the entire security model.

# **🔁 Full Flow (From Login to API Call)**

## **1️⃣ User Logs In**

User authenticates with Cognito.

Cognito generates JWT:

header \+ payload

Then signs it:

signature \= Sign(private\_key, header \+ payload)

Token is returned to client.

## **2️⃣ Client Calls Your Backend**

Client sends:

Authorization: Bearer \<access\_token\>

Your Spring Boot backend:

Downloads Cognito public key from:  
/.well-known/jwks.json

1.   
2. Verifies signature:

Verify(public\_key, header \+ payload, signature)

3. Checks:  
   * Expiration  
   * Issuer  
   * Audience  
4. Extracts claims like:

sub (Cognito user ID)

Then loads your internal user profile using that `sub`.

No call to Cognito needed.

# **🎯 Why Asymmetric Is Needed**

If symmetric (HS256):

* Every service must know the same secret  
* Anyone who can verify → can also create tokens  
* If one service leaks secret → attacker can forge tokens

With asymmetric (RS256):

* Only Cognito has private key  
* All services only have public key  
* Even if backend is hacked → attacker cannot generate tokens

This is why identity providers use asymmetric signing.

# **⚠️ Are There Risks?**

Yes — but controlled ones.

## **1️⃣ Token Revocation Limitation**

JWT is stateless.

If:

* User logs out  
* Account is disabled

Access token still works until expiration.

Because backend only verifies signature locally.

Solution:

* Use short-lived access tokens (e.g., 1 hour)  
* Revoke refresh tokens  
* Let access token expire naturally

This is industry standard tradeoff.

## **2️⃣ Stolen Access Token**

If attacker steals token:

They can use it until expiration.

JWT cannot prevent this.

Mitigation:

* HTTPS only  
* HttpOnly cookies (web)  
* Short expiration  
* XSS protection

## **3️⃣ Key Rotation**

Cognito rotates signing keys.

Your backend:

* Automatically refreshes public keys from JWKS endpoint

This is handled by Spring Security.

# **🏗 Final Mental Model**

Instead of:

Backend \= login \+ password \+ token generator

Now:

Cognito \= Authentication Server  
Your backend \= Resource Server

Cognito proves identity by signing token.  
Your backend only verifies that proof.

# **🔐 Why It’s Safe Enough for Production**

Because:

* Signature cannot be forged without private key  
* Public key does not allow token creation  
* No secret is shared across services  
* No DB lookup required per request  
* Highly scalable

Google, Microsoft, AWS — all use this exact pattern.

# week 7

lab22: Optimizing EC2 Costs with Lambda

in cloudwatch, we could have eventbridge, which is creating rule (condition is some pattern or a schedule) to run something in aws

according to amazon Q about EventBridge schedule timing mechanic: [link]()

lab27: Manage Resources Using Tags and Resource Groups  
Tags are key and value pairs that act as metadata for organizing your AWS resources. With most AWS resources, you have the option of adding tags when you create the resource, whether it’s an Amazon EC2 instance, an Amazon S3 bucket, or other resource. This lab will walkthrough assigning resource tags and using Resource Groups.

Tag  
Tags are words or phrases that act as metadata that you can use to identify and organize your AWS resources. A resource can have up to 50 user-applied tags. It can also have read-only system tags. Each tag consists of a key and one optional value.

Tags allow categorizing AWS resources in a variety of ways \- such as grouping them by purpose, owner, or environment. This becomes useful when there are multiple resources of the same type, and you want to identify a specific resource based on some properties that have been assigned to it.

AWS Resource Groups  
AWS Resource Groups is the service that lets you manage and automate tasks on large numbers of resources at one time. In AWS, a resource is an entity that you can work with. Examples include an Amazon EC2 instance, an AWS CloudFormation stack, or an Amazon S3 bucket. If you work with multiple resources, you might find it useful to manage them as a group rather than move from one AWS service to another for each task.

tag best practice: [link](https://000027.awsstudygroup.com/1-using-tags/1-using-tags-console/1.1.1-newec2/_index.files/aws-tagging-best-practices.pdf)

seem like they deprecated the tags management tab in ec2 console. For managing tags across multiple resources at once Go to the Tag Editor (resource group) in the AWS Management Console  
About filter by tag, aws’s ui keeps the same from the lab, so we can query many tags here. 

# eventbridge timming

Based on the information from AWS documentation, here's how EventBridge scheduled rules work when targeting Lambda functions:

When the Rule Starts  
Rate expressions start immediately when you create the rule. The countdown to the first execution begins as soon as you create the scheduled event rule. For example, if you create a rule with rate(1 hour), the first execution will happen approximately 1 hour after you create the rule.

Timing Behavior  
First Execution: The rule starts counting down immediately upon creation. So if you create a rule at 2:30 PM with rate(1 hour), the first Lambda execution will occur around 3:30 PM.

Subsequent Executions: After the first execution, the rule continues to trigger every hour from that initial execution time. So it would run at approximately 3:30 PM, 4:30 PM, 5:30 PM, and so on.

Precision: EventBridge runs rules within one minute of the scheduled time, but not at the precise 0th second. There can also be a delay of several seconds between when the rule fires and when Lambda actually executes due to the distributed nature of the services.

Important Notes  
Not Clock-Aligned: Rate expressions are NOT aligned to clock boundaries. If you want your Lambda to run every hour on the hour (like 1:00 PM, 2:00 PM, 3:00 PM), you should use a cron expression instead: cron(0 \* \* \* ? \*)

Continuous Operation: Once created and enabled, the rule will continue triggering your Lambda function every hour until you disable or delete the rule.

StartDate Option: With EventBridge Scheduler (the newer service), you can specify a StartDate to control when the schedule begins. If you don't provide a StartDate, it starts immediately.

To create an EventBridge rule that triggers every hour, you can use the EventBridge Console  and set up a scheduled rule with either:

Rate expression: rate(1 hour) (starts immediately)  
Cron expression: cron(0 \* \* \* ? \*) (runs at the top of every hour)

# ECS

# **1\. What ECS Actually Is**

**Amazon ECS (Elastic Container Service) is AWS’s container orchestration service.**  
**It manages:**

* **running containers**  
* **scaling containers**  
* **restarting failed containers**  
* **networking between containers**  
* **load balancing**  
* **deployment updates**

**It is similar in purpose to:**

* **Kubernetes**  
* **Docker Swarm**

**But ECS is simpler because AWS manages most infrastructure.**

---

# **2\. The Two Ways ECS Runs Containers**

**When you use ECS you must choose a launch type.**

### **1️⃣ EC2 Launch Type**

**Containers run on EC2 servers you manage.**

**ECS Cluster**

   **├── EC2 instance**

   **│      ├── Container A**

   **│      └── Container B**

   **└── EC2 instance**

          **└── Container C**

**You must manage:**

* **instance size**  
* **scaling**  
* **patching OS**  
* **cluster capacity**

---

### **2️⃣ Fargate Launch Type**

**With AWS Fargate, AWS runs the servers.**  
**You only define:**

* **CPU**  
* **RAM**  
* **container image**

**ECS Cluster**

   **├── Task (container)**

   **├── Task (container)**

   **└── Task (container)**

**You never see the servers.**

---

# **3\. ECS EC2 vs Fargate**

| Feature | EC2 | Fargate |
| ----- | ----- | ----- |
| **Server management** | **You manage** | **AWS manages** |
| **Scaling** | **You scale EC2** | **Automatic** |
| **Cost model** | **Pay per instance** | **Pay per container** |
| **Control** | **Full control** | **Limited** |
| **Startup speed** | **slower** | **faster** |
| **Best for** | **large stable workloads** | **microservices** |

---

### **Simple analogy**

**EC2 mode:**  
**Renting an apartment building, you manage everything.**  
**Fargate:**  
**Renting a hotel room, everything is managed.**

---

# **4\. Core ECS Concepts**

**There are 5 key concepts you must understand.**

---

# **5\. ECS Cluster**

**An ECS Cluster is just a logical group of compute resources.**

**ECS Cluster**

   **├── Task**

   **├── Task**

   **└── Task**

**With EC2:**

**Cluster**

 **├── EC2 instance**

 **│     ├── Task**

 **│     └── Task**

**With Fargate:**

**Cluster**

 **├── Task**

 **├── Task**

 **└── Task**

**Cluster does not cost money.**

---

# **6\. Task Definition (Blueprint)**

**A Task Definition is a template describing containers.**  
**Example:**

**Task Definition: web-app**

**Container:**

   **image: myapp:latest**

   **cpu: 512**

   **memory: 1024**

   **port: 3000**

**It defines:**

* **Docker image**  
* **CPU**  
* **memory**  
* **environment variables**  
* **ports**  
* **logging**  
* **secrets**  
* **volumes**

**Think of it like:**  
**Docker Compose but for AWS**

---

# **7\. Task**

**A Task is a running instance of a task definition.**  
**Example:**

**Task Definition: web-app**

**Running tasks:**

   **Task 1**

   **Task 2**

   **Task 3**

**Each task \= container runtime.**

---

# **8\. Service**

**A Service ensures tasks keep running.**  
**Example:**

**Service: web-app-service**

**Desired tasks: 3**

**If one crashes:**

**Task 1**

**Task 2**

**Task 3 ❌**

**ECS automatically starts a new one.**

**Task 1**

**Task 2**

**Task 4**

**Services also handle:**

* **load balancing**  
* **rolling deployments**  
* **auto scaling**

---

# **9\. ECS Architecture Overview**

**Typical production architecture:**

**Internet**

   **│**

   **▼**

**Application Load Balancer**

   **│**

   **▼**

**ECS Service**

   **│**

   **▼**

**Tasks (containers)**

   **│**

   **▼**

**Database (RDS)**

**Using:**

* **Application Load Balancer**  
* **Amazon RDS**

---

# **10\. How Container Networking Works in ECS**

**Networking depends on network mode.**  
**But with Fargate there is only one mode:**

**awsvpc**

---

# **11\. awsvpc Networking Mode**

**In awsvpc mode, each task gets its own network interface.**  
**AWS creates an ENI (Elastic Network Interface).**

**Task 1**

  **└── ENI**

       **└── Private IP**

**Task 2**

  **└── ENI**

       **└── Private IP**

**So tasks behave like real EC2 machines inside the VPC.**  
**This means:**

* **tasks have IP addresses**  
* **tasks can use security groups**  
* **tasks can talk directly via VPC**

---

# **12\. Example Networking**

**Imagine:**

**VPC**

 **├── Public Subnet**

 **│      └── Load Balancer**

 **│**

 **└── Private Subnet**

        **├── ECS Task**

        **├── ECS Task**

        **└── ECS Task**

**Flow:**

**User**

  **│**

  **▼**

**ALB (public subnet)**

  **│**

  **▼**

**ECS tasks (private subnet)**

---

# **13\. ECS in VPC**

**Every ECS service runs inside a Amazon VPC.**  
**VPC contains:**

**VPC**

 **├── Subnet**

 **├── Route tables**

 **├── Security groups**

 **├── Internet Gateway**

 **└── NAT Gateway**

---

# **14\. Subnets for ECS**

**Typical architecture:**

### **Public Subnet**

**For:**

* **Load Balancer**  
* **NAT Gateway**

**Public subnet**

 **├── ALB**

 **└── NAT Gateway**

---

### **Private Subnet**

**For:**

* **ECS tasks**  
* **databases**

**Private subnet**

 **├── ECS Task**

 **├── ECS Task**

 **└── RDS**

**Tasks should not be public for security.**

---

# **15\. Internet Access from ECS**

**Containers often need internet to:**

* **download packages**  
* **call APIs**

**But if tasks are in private subnet, they cannot reach internet.**  
**Solution:**  
**Use AWS NAT Gateway**  
**Flow:**

**ECS Task**

   **│**

   **▼**

**NAT Gateway**

   **│**

   **▼**

**Internet Gateway**

   **│**

   **▼**

**Internet**

---

# **16\. Security Groups in ECS**

**Each task can have a security group.**  
**Example:**

**Task security group**

**Inbound:**

  **allow ALB → port 3000**

**Outbound:**

  **allow all**

**Flow:**

**Internet**

  **│**

  **▼**

**ALB**

  **│**

  **▼**

**Task**

**Only ALB can reach the task.**

---

# **17\. Service Discovery**

**ECS can allow containers to call each other using:**

* **internal DNS**  
* **service discovery**

**Example:**

**auth-service**

**payment-service**

**api-gateway**

**API gateway calls:**

**http://auth-service:3000**

**Using AWS Cloud Map**

---

# **18\. Load Balancing with ECS**

**A service usually connects to:**  
**Application Load Balancer**  
**Example:**

**ALB**

 **├── Task 1**

 **├── Task 2**

 **└── Task 3**

**ALB distributes traffic.**

---

# **19\. How Deployment Works**

**When you push new container version:**

**v1 tasks running**

**ECS deploys:**

**v1 task**

**v1 task**

**v2 task**

**Then replaces old tasks.**  
**This is called rolling deployment.**

---

# **20\. Example Real Architecture**

**Example for your web app \+ backend:**

**Route53**

   **│**

   **▼**

**CloudFront**

   **│**

   **▼**

**ALB**

   **│**

   **▼**

**ECS Service (Fargate)**

   **│**

   **├── API container**

   **├── API container**

   **└── API container**

   **│**

   **▼**

**RDS PostgreSQL**

**Using:**

* **Amazon Route 53**  
* **Amazon CloudFront**  
* **Amazon RDS**

---

# **21\. Cost Model**

**Fargate charges by:**

**CPU per second**

**Memory per second**

**Example:**

**0.5 vCPU**

**1GB RAM**

**Cost runs only while task is running.**

---

# **22\. Minimum Example (Mental Model)**

**Deploy container:**  
**1️⃣ Push Docker image to Amazon ECR**  
**2️⃣ Create Task Definition**  
**3️⃣ Create Service**  
**4️⃣ Attach ALB**  
**5️⃣ Deploy tasks**

---

# **23\. Visual Summary**

               **Internet**

                   **│**

                   **▼**

            **Application LB**

                   **│**

                   **▼**

              **ECS Service**

                   **│**

            **┌──────┴──────┐**

            **▼             ▼**

         **Task 1        Task 2**

            **│             │**

            **└─────VPC─────┘**

                   **│**

                   **▼**

                 **RDS**

---

# **24\. Why Fargate Is Popular**

**Advantages:**

* **no servers**  
* **simple scaling**  
* **secure networking**  
* **fast deployment**  
* **good for microservices**

---

# **25\. When NOT to Use Fargate**

**Better to use EC2 when:**

* **GPU workloads**  
* **extremely large clusters**  
* **custom networking**  
* **cost optimization at scale**

---

**✅ Since you mentioned earlier you plan to deploy:**

* **Expo web frontend**  
* **Spring backend**  
* **PostgreSQL**  
* **Redis**

**Your stack:**

**CloudFront**

**S3 (frontend)**

**ALB**

**ECS Fargate (Spring)**

**RDS PostgreSQL**

**ElastiCache Redis**

**is actually a very standard modern AWS architecture.**

# **26\. What is a Target Group?**

A **Target Group** in **Application Load Balancer** is a **collection of destinations that the load balancer sends traffic to**.  
These destinations are called **targets**.  
Targets can be:

* EC2 instances  
* IP addresses  
* Lambda functions  
* ECS tasks

When using **Amazon ECS with AWS Fargate**, the targets are usually **ECS tasks (via their IP addresses)**.  
---

# **27\. Where Target Groups Sit in the Architecture**

Target groups exist **logically between the ALB and the compute resources**.  
Architecture:  
Internet  
   │  
   ▼  
Application Load Balancer  
   │  
   ▼  
Target Group  
   │  
   ▼  
ECS Tasks

Expanded:  
Internet  
   │  
   ▼  
ALB (public subnet)  
   │  
   ▼  
Target Group  
   │  
   ▼  
ECS Tasks (private subnet)

Important idea:  
**The Target Group does NOT run servers.**  
It is just a **routing \+ health-check manager**.  
---

# **28\. Target Group Lives Inside the VPC**

A **Target Group belongs to a specific VPC**.  
Why?  
Because it must route traffic to **private IPs inside that VPC**.  
Example:  
VPC (10.0.0.0/16)

Public Subnet  
 └── ALB

Private Subnet  
 ├── ECS Task (10.0.2.14)  
 ├── ECS Task (10.0.3.21)  
 └── ECS Task (10.0.3.42)

The Target Group stores these **private IP addresses**.  
Target Group  
 ├── 10.0.2.14:8080  
 ├── 10.0.3.21:8080  
 └── 10.0.3.42:8080

The ALB sends traffic to them.  
---

# **29\. How ECS Registers Tasks to Target Group**

When you create an ECS **Service**, you attach a Target Group.  
Example:  
ECS Service  
  └── Target Group: api-target-group

When ECS starts a task:  
Task starts  
   │  
   ▼  
Task receives private IP  
   │  
   ▼  
ECS automatically registers it in Target Group

Example:  
Target Group  
 ├── Task IP 10.0.2.14  
 ├── Task IP 10.0.3.21

When a task stops:  
ECS deregisters the task automatically

---

# **30\. Health Checks**

Target groups perform **health checks** to ensure tasks are alive.  
Example configuration:  
Health check path: /health  
Port: 8080  
Interval: 30s

Health check flow:  
ALB  
 │  
 ▼  
GET /health  
 │  
 ▼  
Task

If a task fails health checks:  
Target Group marks it unhealthy

ALB stops sending traffic to it.  
Then ECS replaces the task.  
---

# **31\. Listener → Target Group Routing**

Traffic reaches a Target Group through an **ALB listener**.  
Example:  
ALB Listener  
Port: 443

Rule:  
IF path \= /api/\*  
THEN forward to api-target-group

Architecture:  
Internet  
   │  
   ▼  
ALB Listener (443)  
   │  
   ▼  
Routing Rule  
   │  
   ▼  
Target Group  
   │  
   ▼  
ECS Tasks

---

# **32\. Multiple Target Groups Example**

One ALB can route to **multiple services**.  
Example microservices:  
ALB  
 ├── Target Group: auth-service  
 ├── Target Group: payment-service  
 └── Target Group: api-service

Routing rules:  
/auth/\*    → auth-service  
/pay/\*     → payment-service  
/api/\*     → api-service

Each Target Group points to **different ECS services**.  
---

# **33\. Target Type (Important for Fargate)**

Target Groups support multiple **target types**.  
instance  
ip  
lambda

For **AWS Fargate** the target type must be:  
ip

Why?  
Because each ECS task has its **own ENI \+ IP address**.  
---

# **34\. Networking Flow (Full Picture)**

Here is the **complete request flow**.  
User Browser  
    │  
    ▼  
Internet  
    │  
    ▼  
Route53  
    │  
    ▼  
ALB (public subnet)  
    │  
    ▼  
Target Group  
    │  
    ▼  
ECS Task (private subnet)  
    │  
    ▼  
Application container

Response returns through the same path.  
---

# **35\. How Security Groups Work in This Flow**

Typical setup:

### **ALB Security Group**

Allow inbound from internet:  
Inbound  
0.0.0.0/0 → 443

---

### **ECS Task Security Group**

Allow only ALB traffic:  
Inbound  
ALB Security Group → port 8080

So traffic flow is restricted:  
Internet  
  │  
  ▼  
ALB  
  │  
  ▼  
ECS Task

No one can directly reach the tasks.  
---

# **36\. Deployment Flow with Target Groups**

When you deploy a new version:  
Service desired count \= 3

Old tasks:  
Task A  
Task B  
Task C

Deployment starts:  
Task D (new version)  
Task E (new version)

Target group temporarily contains:  
A  
B  
C  
D  
E

After health checks pass:  
A B C removed

Final:  
D E F

This is **rolling deployment**.  
---

# **37\. Real Example for Your Stack**

Your earlier architecture idea fits perfectly:  
Internet  
   │  
   ▼  
Route53  
   │  
   ▼  
CloudFront  
   │  
   ▼  
ALB  
   │  
   ▼  
Target Group (Spring API)  
   │  
   ▼  
ECS Fargate Tasks  
   │  
   ▼  
RDS PostgreSQL

Using:

* Amazon Route 53  
* Amazon CloudFront  
* Amazon ECS  
* AWS Fargate  
* Amazon RDS

---

# **38\. Simple Mental Model**

Think of the Target Group as a **smart phonebook for the load balancer**.  
ALB asks:  
"Which containers are alive?"

Target Group answers:  
"Send traffic to these IPs."

10.0.2.14  
10.0.3.21  
10.0.3.42

---

✅ **Most beginners misunderstand this architecture**, but the correct order is always:  
ALB  
   ↓  
Listener  
   ↓  
Target Group  
   ↓  
ECS Tasks

ALB add  origin option service:![][image2]  
origin name is not editable (or at least with normal setup)

# week9

GEN AI event  
Strands agents (aws gen ai framework service)  
workflow: prompt, invoke model. almost basic gen AI api service, with some custom user side configuration such as system prompt or prebuild tool. Because it is a framework, we still need to pay for the model we use, such as a bedrock call with model id, or we can use a local model with no extra fee. 

Still need to care about security, production setting, because again, it is still a framework to customize a model

section 2: prompt engineer   
Problem  
 Generic input- Generic outputs  
 Wasted tokens \- Increased costs  
 Ambiguous instructions \- Inconsistent results  
 Poor communication \- Lost productivity

Great prompt:   
Role (who the model is pretending to be)  
Instruction (what the model should do)  
Context (relevant background information)  
Input Data (text to be analyzed/acted upon)  
Output Format (structure, syntax, style)  
Examples (few-shot demonstrations)  
Constraints/Guidelines (do NOT, focus on, length)

Mastering LLM  
Prompting

Be Clear & Specific  
Use Directive Language  
Use Delimiters to Separate Sections  
Describe DOs, not DON'Ts  
Don't Ask LLMs to Do Math  
Allow "I Don't Know" Responses  
Break Long Inputs into Smaller Segments

Section 3: iot in aws with ai:  
AWS IoT Core service

. Acts as a cloud MQTT broker enabling secure communication between loT devices and AWS services.

· Authenticates and manages loT devices using certificates to ensure only authorized hardware connects.

. Routes sensor events such as RFID scans and door states to Lambda, DynamoDB, and S3.

. Enables scalable loT infrastructure for multiple smart lockers without relying on a local MQTT server.

AWS Rekognition

. Performs facial recognition on captured images to identify which club member is accessing the locker.

· Compares captured images against a pre-trained club member face collection stored in the system.

. Returns similarity confidence scores to determine whether the detected face matches a registered club member.

. Links recognized member identity with RFID asset transactions for accurate logging and audit tracking.  


[image1]: <data:image/png;base64,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>

[image2]: <data:image/png;base64,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>