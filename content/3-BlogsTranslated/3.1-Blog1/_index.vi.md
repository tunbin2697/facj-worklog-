---
title: "Công bố Amazon Aurora PostgreSQL serverless có thể tạo cơ sở dữ liệu trong vài giây"
date: 2026-03-25
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

{{% notice info %}}
Bản dịch tiếng Việt phục vụ mục đích học tập. Bài gốc: "Announcing Amazon Aurora PostgreSQL serverless database creation in seconds" by Channy Yun, 25 MAR 2026 — https://aws.amazon.com/blogs/aws/announcing-amazon-aurora-postgresql-serverless-database-creation-in-seconds/
{{% /notice %}}

# Công bố Amazon Aurora PostgreSQL serverless có thể tạo cơ sở dữ liệu trong vài giây

Tác giả gốc: [Channy Yun (윤석찬)](https://aws.amazon.com/blogs/aws/author/channy-yun/) | Ngày đăng: 25 MAR 2026

Tại re:Invent 2025, [Colin Lazier](https://www.linkedin.com/in/colinlazier/), Phó Chủ tịch mảng cơ sở dữ liệu tại AWS, đã nhấn mạnh tầm quan trọng của việc xây dựng sản phẩm theo tốc độ của ý tưởng, giúp rút ngắn hành trình từ ý tưởng đến ứng dụng chạy thực tế. Khách hàng hiện đã có thể tạo bảng [Amazon DynamoDB](https://aws.amazon.com/dynamodb/) sẵn sàng cho production và cơ sở dữ liệu [Amazon Aurora DSQL](https://aws.amazon.com/rds/aurora/dsql/) chỉ trong vài giây. Trước đó, ông cũng đã [demo trước](https://youtu.be/MBvyZENChk0?si=meDKK2zJturw-hK0&t=1084) khả năng tạo cơ sở dữ liệu [Amazon Aurora serverless](https://aws.amazon.com/rds/aurora/serverless/) với tốc độ tương tự, và kể từ đó nhiều khách hàng đã yêu cầu khả năng này.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/02/27/2026-aurora-express-1-reinvent-preview.jpg)

Hôm nay, AWS công bố chính thức (GA) cấu hình express mới cho Amazon Aurora PostgreSQL, mang lại trải nghiệm tạo cơ sở dữ liệu tinh gọn với các cấu hình mặc định được thiết lập sẵn để bạn bắt đầu chỉ trong vài giây.

Chỉ với hai lần nhấp, bạn có thể có ngay một cơ sở dữ liệu Aurora PostgreSQL serverless sẵn sàng sử dụng trong vài giây. Bạn vẫn có thể linh hoạt điều chỉnh một số thiết lập trong và sau khi tạo. Ví dụ, bạn có thể thay đổi dải công suất cho instance serverless ngay lúc tạo, thêm read replica, hoặc chỉnh parameter group sau khi cơ sở dữ liệu được tạo xong. Cụm Aurora với express configuration được tạo mà không cần mạng [Amazon Virtual Private Cloud (Amazon VPC)](https://aws.amazon.com/vpc/), đồng thời có internet access gateway để kết nối an toàn từ các công cụ phát triển quen thuộc - không cần VPN hoặc AWS Direct Connect. Express configuration cũng mặc định bật xác thực [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/) cho tài khoản quản trị, cho phép xác thực không mật khẩu ngay từ đầu mà không cần cấu hình thêm.

Sau khi được tạo, bạn có thể sử dụng các tính năng có sẵn của Aurora PostgreSQL serverless như triển khai thêm read replica cho tính sẵn sàng cao và khả năng failover tự động. Lần ra mắt này cũng giới thiệu lớp định tuyến internet access gateway mới cho Aurora. Instance serverless mới của bạn được bật tính năng này mặc định, cho phép ứng dụng kết nối an toàn từ bất kỳ đâu qua internet bằng PostgreSQL wire protocol từ nhiều công cụ phát triển khác nhau. Gateway này được phân tán trên nhiều Availability Zone, mang lại mức độ sẵn sàng cao tương đương cụm Aurora.

Việc tạo và kết nối Aurora trong vài giây đồng nghĩa với việc thay đổi cách bắt đầu xây dựng ứng dụng. AWS đã ra mắt nhiều khả năng phối hợp với nhau để giúp bạn onboard và vận hành ứng dụng trên Aurora. Aurora hiện đã có trên [AWS Free Tier](https://aws.amazon.com/free/), giúp bạn có trải nghiệm thực hành Aurora mà không cần chi phí ban đầu. Sau khi tạo xong, bạn có thể truy vấn trực tiếp cơ sở dữ liệu Aurora trong [AWS CloudShell](https://aws.amazon.com/cloudshell/) hoặc thông qua ngôn ngữ lập trình và công cụ phát triển nhờ thành phần định tuyến truy cập internet mới của Aurora. Với các tích hợp như v0 by [Vercel](https://vercel.com/), bạn có thể dùng ngôn ngữ tự nhiên để bắt đầu xây dựng ứng dụng với các lợi ích của Aurora.

## Tạo Aurora PostgreSQL serverless trong vài giây

Để bắt đầu, vào [Aurora and RDS console](https://console.aws.amazon.com/rds/) và trong thanh điều hướng chọn **Dashboard**. Sau đó chọn **Create** với biểu tượng tên lửa.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/16/2026-aurora-express-configuration-1-1024x431.jpg)

Xem lại các cấu hình dựng sẵn trong hộp thoại **Create with express configuration**. Bạn có thể chỉnh DB cluster identifier hoặc dải công suất nếu cần. Chọn **Create database**.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/16/2026-aurora-express-configuration-2-1024x820.png)

Bạn cũng có thể dùng [AWS Command Line Interface (AWS CLI)](https://aws.amazon.com/cli/) hoặc [AWS SDKs](https://builder.aws.com/build/tools/) với tham số `--with-express-configuration` để tạo cả cluster và instance trong cluster chỉ với một API call, sẵn sàng để chạy truy vấn sau vài giây. Xem thêm tại [Creating an Aurora PostgreSQL DB cluster with express configuration](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_GettingStartedAurora.CreatingConnecting.AuroraPostgreSQL.html).

Dưới đây là lệnh CLI để tạo cluster:

```bash
$ aws rds create-db-cluster --db-cluster-identifier channy-express-db \
	--engine aurora-postgresql \
	--with-express-configuration
```

Cơ sở dữ liệu Aurora PostgreSQL serverless của bạn sẽ sẵn sàng chỉ trong vài giây. Banner thành công sẽ xác nhận quá trình tạo, và trạng thái database sẽ chuyển sang **Available**.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/02/27/2026-aurora-express-configuration-3.jpg)

Sau khi database sẵn sàng, vào tab **Connectivity & security** để xem ba tùy chọn kết nối. Khi kết nối qua SDK, API hoặc công cụ bên thứ ba (bao gồm agent), chọn **Code snippets**. Bạn có thể chọn nhiều ngôn ngữ như .NET, Golang, JDBC, Node.js, PHP, PSQL, Python, và TypeScript. Bạn có thể copy code ở từng bước và chạy trực tiếp trong công cụ của mình.

Ví dụ, đoạn Python dưới đây được tạo động theo cấu hình xác thực:

```python
import psycopg2
import boto3

auth_token = boto3.client('rds', region_name='ap-south-1').generate_db_auth_token(DBHostname='channy-express-db-instance-1.abcdef.ap-south-1.rds.amazonaws.com', Port=5432, DBUsername='postgres', Region='ap-south-1')

conn = None
try:
	conn = psycopg2.connect(
		host='channy-express-db-instance-1.abcdef.ap-south-1.rds.amazonaws.com',
		port=5432,
		database='postgres',
		user='postgres',
		password=auth_token,
		sslmode='require'
	)
	cur = conn.cursor()
	cur.execute('SELECT version();')
	print(cur.fetchone()[0])
	cur.close()
except Exception as e:
	print(f"Database error: {e}")
	raise
finally:
	if conn:
		conn.close()
```

Chọn **CloudShell** để truy cập nhanh AWS CLI chạy trực tiếp từ console. Khi chọn Launch **CloudShell**, bạn sẽ thấy lệnh đã được điền sẵn thông tin liên quan để kết nối tới cluster cụ thể của bạn. Sau khi kết nối shell, bạn sẽ thấy `psql login` và dấu nhắc `postgres =>` để chạy câu lệnh SQL.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/02/27/2026-aurora-express-configuration-4.jpg)

Bạn cũng có thể chọn **Endpoints** để dùng các công cụ chỉ hỗ trợ username/password như pgAdmin. Khi chọn **Get token**, bạn dùng token xác thực [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/) do công cụ tạo ra trong ô password. Token được tạo cho master username đã thiết lập lúc tạo database. Token có hiệu lực 15 phút mỗi lần. Nếu công cụ bạn dùng ngắt kết nối, bạn cần tạo lại token.

## Tăng tốc xây dựng ứng dụng với Aurora

Tại re:Invent 2025, AWS đã [công bố cập nhật chương trình AWS Free Tier](https://aws.amazon.com/blogs/aws/aws-free-tier-update-new-customers-can-get-started-and-explore-aws-with-up-to-200-in-credits/), cung cấp tối đa $200 tín dụng AWS có thể dùng trên nhiều dịch vụ. Bạn nhận $100 tín dụng khi đăng ký và có thể nhận thêm $100 khi sử dụng các dịch vụ như Amazon Relational Database Service (Amazon RDS), AWS Lambda, và Amazon Bedrock. Ngoài ra, Amazon Aurora hiện đã có trong tập dịch vụ cơ sở dữ liệu đủ điều kiện của [Free Tier](https://aws.amazon.com/free/database/).

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/02/27/2026-aurora-express-configuration-5-1024x447.jpg)

Các developer đang ngày càng ưa chuộng những nền tảng như Vercel, nơi ngôn ngữ tự nhiên đã đủ để xây dựng ứng dụng sẵn sàng production. AWS đã [công bố tích hợp với Vercel Marketplace](https://aws.amazon.com/about-aws/whats-new/2025/12/aws-databases-are-available-on-the-vercel/) để tạo và kết nối cơ sở dữ liệu AWS trực tiếp từ Vercel trong vài giây, cùng với [v0 by Vercel](https://aws.amazon.com/about-aws/whats-new/2026/01/aws-databases-available-vercel-v0/), một công cụ AI giúp biến ý tưởng thành ứng dụng full-stack sẵn sàng production trong vài phút. Tích hợp này bao gồm Aurora PostgreSQL, Aurora DSQL, và DynamoDB. Bạn cũng có thể kết nối cơ sở dữ liệu hiện có tạo bằng express configuration với Vercel. Xem thêm tại [AWS for Vercel](https://vercel.com/marketplace/aws).

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/02/27/2026-aurora-express-configuration-6-1024x663.jpg)

Tương tự Vercel, AWS đang đưa cơ sở dữ liệu vào trải nghiệm của các hệ sinh thái phổ biến và tích hợp trực tiếp với framework, công cụ AI coding assistant, môi trường phát triển, và toolchain để mở khóa khả năng xây dựng theo tốc độ của ý tưởng.

AWS đã giới thiệu [Aurora PostgreSQL integration with Kiro powers](https://aws.amazon.com/about-aws/whats-new/2025/12/amazon-aurora-postgresql-integration-kiro-powers/), giúp developer xây dựng ứng dụng dùng Aurora PostgreSQL nhanh hơn nhờ phát triển có hỗ trợ AI agent qua [Kiro](https://kiro.dev). Bạn có thể dùng Kiro power cho Aurora PostgreSQL trong [Kiro IDE](https://kiro.dev/powers/#how-do-i-install-powers) và từ [Kiro powers webpage](https://kiro.dev/powers/) để cài đặt một lần nhấp. Để tìm hiểu thêm, xem [Introducing Amazon Aurora powers for Kiro](https://aws.amazon.com/blogs/database/introducing-amazon-aurora-powers-for-kiro/) và [Amazon Aurora Postgres MCP Server](https://awslabs.github.io/mcp/servers/postgres-mcp-server).

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/02/27/2026-aurora-express-configuration-7-1024x697.png)

## Hiện đã khả dụng

Bạn có thể tạo Aurora PostgreSQL serverless trong vài giây ngay hôm nay tại tất cả AWS commercial Regions. Để xem khả dụng theo khu vực và lộ trình, truy cập [AWS Capabilities by Region](https://builder.aws.com/build/capabilities/explore).

Bạn chỉ trả phí theo mức công suất tiêu thụ dựa trên Aurora Capacity Units (ACUs), tính theo giây từ mức zero capacity, tự động khởi động, dừng, và scale up/down theo nhu cầu ứng dụng. Xem thêm tại [Amazon Aurora Pricing page](https://aws.amazon.com/rds/aurora/pricing/).

Hãy thử ngay trong [Aurora and RDS console](https://console.aws.amazon.com/rds/) và gửi phản hồi qua [AWS re:Post for Aurora PostgreSQL](https://repost.aws/tags/TAxfQ-h0UrRZ69nv5Q_M-BRQ/aurora-postgresql) hoặc qua kênh AWS Support quen thuộc của bạn.

- [Channy](https://linkedin.com/in/channy)
