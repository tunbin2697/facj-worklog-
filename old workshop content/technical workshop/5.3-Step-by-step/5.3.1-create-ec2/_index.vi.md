---
title : "Tạo EC2 và VPC"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.3.1. </b> "
---

Khởi tạo VPC trước, sau đó tạo EC2 instance để chạy ứng dụng Node.js backend mà ALB sẽ forward request đến.

Phần này giả định bạn đã quen với VPC, EC2, security group và các kiến thức networking cơ bản. Các hình minh họa bên dưới chỉ để tham khảo output và cấu hình mong đợi, bạn có thể tự điều chỉnh theo môi trường của mình.

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

Nếu bạn dùng EC2 User Data, instance vẫn cần cài Node.js trước khi chạy ứng dụng. Vì vậy, hãy đặt EC2 trong public subnet, hoặc đảm bảo instance có quyền truy cập internet outbound. Nếu muốn giữ EC2 ở private subnet, bạn có thể dùng NAT gateway hoặc một AMI đã cài sẵn Node.js.

Hãy dán đoạn sau vào trường "User data" khi Launch instance (Advanced options).

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

## Hình minh họa

![Sơ đồ EC2 private](/images/5-Workshop/workshop-resource/diagram/private%20ec2%20-%20aws%20architeture%20diagram%20workshop%20.png)

![Ảnh tạo VPC](/images/5-Workshop/workshop-resource/vpc/1.png)

![Ảnh EC2 instance](/images/5-Workshop/workshop-resource/ec2/1.png)
