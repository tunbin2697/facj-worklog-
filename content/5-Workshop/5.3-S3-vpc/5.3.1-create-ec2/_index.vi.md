---
title : "Tạo EC2 Backend"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.3.1. </b> "
---

Khởi tạo EC2 instance để chạy ứng dụng Node.js backend, sau đó ALB sẽ forward request đến instance này.

## Các bước

1. Vào AWS Console -> EC2 -> Instances -> Launch instance.
2. Chọn Amazon Linux 2023.
3. Chọn loại `t2.micro` hoặc `t3.micro`.
4. Gắn IAM role có quyền ghi CloudWatch Logs (khuyến nghị).
5. Tạo/chọn Security Group:
	 - Inbound: HTTP (80) từ ALB security group.
	 - Outbound: giữ mặc định cho phép toàn bộ.
6. Launch instance.

## Cài đặt ứng dụng

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

## Kiểm tra

Xác nhận tiến trình app đang chạy và endpoint `/` trả về `Public`.

## Triển khai không cần SSH (EC2 User Data)

Chúng tôi giả sử bạn đã nắm cơ bản VPC và EC2 (subnet, routing, security group). Nếu EC2 được tạo trong private subnet và không thể SSH trực tiếp, hãy sử dụng EC2 User Data để cài đặt và chạy app khi khởi tạo instance. Dán đoạn sau vào trường "User data" khi Launch instance (Advanced options).

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

Lệnh trên sẽ tạo `/home/ec2-user/app.js`, cài Node.js và chạy app ở chế độ nền; kiểm tra `/var/log/app.log` để xem output.
