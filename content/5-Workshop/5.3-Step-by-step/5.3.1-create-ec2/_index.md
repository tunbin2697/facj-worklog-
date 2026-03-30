---
title : "Create EC2 and VPC"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.3.1. </b> "
---

Create the VPC foundation, then launch an EC2 instance to host a simple Node.js backend that will be accessed through ALB.

This step assumes you are already familiar with VPC, EC2, security groups, and basic networking. The screenshots below show the expected setup and output, and you can adapt the exact configuration to your own environment.

## Steps

1. Open AWS Console -> EC2 -> Instances -> Launch instance.
2. Select Amazon Linux 2023.
3. Choose `t2.micro` or `t3.micro`.
4. Attach an IAM role that can write logs to CloudWatch (recommended).
5. Create/select a Security Group:
	 - Inbound: HTTP (80) from ALB security group.
	 - Outbound: allow default all traffic.
6. Launch the instance.

## Validation

Confirm the app process is running and can return `Public` on `/`.

## Headless deployment (EC2 user-data)

If you use EC2 User Data, the instance still needs Node.js installed before the app can start. For that reason, place the EC2 instance in a public subnet, or otherwise make sure it has outbound internet access. If you prefer to keep the instance in a private subnet, use a NAT gateway or a Node.js-installed AMI.

Paste the following into the EC2 "User data" field when launching the instance (Advanced options).

```bash
#!/bin/bash
dnf update -y
dnf install -y nodejs

cat > /home/ec2-user/app.js <<'EOF'
const http = require("http");

function parseGroups(jwt) {
    try {
        const payload = jwt.split('.')[1];
        const decoded = JSON.parse(Buffer.from(payload, 'base64').toString());
        return decoded["cognito:groups"] || [];
    } catch (e) {
        return [];
    }
}

const server = http.createServer((req, res) => {
    const user = req.headers["x-amzn-oidc-identity"];
    const token = req.headers["x-amzn-oidc-data"];

    // Health check (no auth)
    if (req.url === "/health") {
        res.writeHead(200);
        return res.end("OK");
    }

    // Public route (Guest allowed)
    if (req.url === "/") {
        res.writeHead(200);
        return res.end("Public (Guest allowed)");
    }

    // From here, expect authenticated user
    if (!user) {
        res.writeHead(401);
        return res.end("Unauthorized");
    }

    // Dashboard for any logged-in user
    if (req.url === "/dashboard") {
        res.writeHead(200);
        return res.end("User: " + user);
    }

    // Admin route
    if (req.url === "/admin") {
        const groups = parseGroups(token);

        if (groups.includes("admin")) {
            res.writeHead(200);
            return res.end("Admin: " + user);
        } else {
            res.writeHead(403);
            return res.end("Forbidden: Admins only");
        }
    }

    // Default
    res.writeHead(200);
    res.end("OK");
});

server.listen(80, "0.0.0.0");
EOF

sleep 10
nohup /usr/bin/node /home/ec2-user/app.js > /home/ec2-user/app.log 2>&1 &
```

This will create `/home/ec2-user/app.js`, install Node.js, and start the app in the background; check `/var/log/app.log` for output.

## Visual guide

![Private EC2 architecture diagram](/images/5-Workshop/workshop-resource/diagram/aws%20architecture%20diagram%20workshop.png)

![VPC setup screenshot](/images/5-Workshop/workshop-resource/vpc/1.png)

![EC2 instance screenshot](/images/5-Workshop/workshop-resource/ec2/1.png)

