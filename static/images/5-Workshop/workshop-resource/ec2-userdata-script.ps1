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