---
title : "Create EC2 Backend"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.3.1. </b> "
---

Launch an EC2 instance to host a simple Node.js backend that will be accessed through ALB.

## Steps

1. Open AWS Console -> EC2 -> Instances -> Launch instance.
2. Select Amazon Linux 2023.
3. Choose `t2.micro` or `t3.micro`.
4. Attach an IAM role that can write logs to CloudWatch (recommended).
5. Create/select a Security Group:
	 - Inbound: HTTP (80) from ALB security group.
	 - Outbound: allow default all traffic.
6. Launch the instance.

## Install App

```bash
sudo dnf update -y
sudo dnf install -y nodejs

cat > app.js <<'EOF'
const http = require("http");

const server = http.createServer((req, res) => {
	const user = req.headers["x-amzn-oidc-identity"] || "Guest";

	if (req.url === "/") {
		res.end("Public");
	} else if (req.url === "/dashboard") {
		res.end("User: " + user);
	} else if (req.url === "/admin") {
		res.end("Admin: " + user);
	}
});

server.listen(80);
EOF

sudo node app.js
```

## Validation

Confirm the app process is running and can return `Public` on `/`.

## Headless deployment (EC2 user-data)

This workshop assumes basic familiarity with VPC and EC2 (subnets, routing, security groups). If your EC2 instance is launched into a private subnet without direct SSH access, use EC2 User Data to install and start the app at boot. Paste the following into the EC2 "User data" field when launching the instance (Advanced options).

```bash
cat > /home/ec2-user/app.js <<'EOF'
const http = require("http");

const server = http.createServer((req, res) => {
	const user = req.headers["x-amzn-oidc-identity"];
	const token = req.headers["x-amzn-oidc-data"]; // JWT (optional)

	// Public
	if (req.url === "/") {
		return res.end("Public");
	}

	// Require login
	if (!user) {
		res.statusCode = 401;
		return res.end("Unauthorized");
	}

	// Authenticated user
	if (req.url === "/dashboard") {
		return res.end("User: " + user);
	}

	// Admin check (TEMP: simple check)
	if (req.url === "/admin") {
		// ⚠️ Replace this with real role check
		if (user !== "your-admin-user-id") {
			res.statusCode = 403;
			return res.end("Forbidden");
		}
		return res.end("Admin: " + user);
	}

	res.statusCode = 404;
	res.end("Not found");
});

server.listen(80, "0.0.0.0");
EOF

# Install Node and run app at first boot
yum update -y
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs
chown ec2-user:ec2-user /home/ec2-user/app.js
nohup node /home/ec2-user/app.js >/var/log/app.log 2>&1 &
```

This will create `/home/ec2-user/app.js`, install Node.js, and start the app in the background; check `/var/log/app.log` for output.