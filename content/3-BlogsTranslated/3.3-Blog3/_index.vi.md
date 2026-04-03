---
title: "Tổng hợp tuần AWS: AWS AI/ML Scholars, Agent Plugin cho AWS Serverless, và các cập nhật khác (30 Mar 2026)"
date: 2026-03-30
weight: 3
chapter: false
pre: " <b> 3.3. </b> "
---

{{% notice info %}}
Bản dịch tiếng Việt phục vụ mục đích học tập. Bài gốc: "AWS Weekly Roundup: AWS AI/ML Scholars program, Agent Plugin for AWS Serverless, and more (March 30, 2026)" by Prasad Rao — https://aws.amazon.com/blogs/aws/aws-weekly-roundup-aws-ai-ml-scholars-program-agent-plugin-for-aws-serverless-and-more-march-30-2026/
{{% /notice %}}

# Tổng hợp tuần AWS: AWS AI/ML Scholars, Agent Plugin cho AWS Serverless, và các cập nhật khác (30 Mar 2026)

Tuần trước, điều làm tôi hào hứng nhất là [sự ra mắt chương trình 2026 AWS AI and ML Scholars](https://www.linkedin.com/posts/swaminathansivasubramanian_excited-to-share-that-applications-are-ugcPost-7442263176475410433-8c8k?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAUt4OcBCLB3u7KY4pbSog9XZD5vI10JCzU) do [Swami Sivasubramanian](https://www.linkedin.com/in/swaminathansivasubramanian/), VP of AWS Agentic AI, công bố, với mục tiêu cung cấp giáo dục AI miễn phí cho tối đa 100.000 học viên trên toàn thế giới. Chương trình gồm hai giai đoạn: giai đoạn Challenge để học nền tảng generative AI, sau đó là học bổng toàn phần chương trình Udacity Nanodegree kéo dài ba tháng dành cho 4.500 người có kết quả cao nhất. Bất kỳ ai từ 18 tuổi trở lên đều có thể đăng ký, không yêu cầu kinh nghiệm trước đó về AI hoặc ML. Hạn nộp hồ sơ là ngày 24/06/2026. Truy cập [trang AWS AI and ML Scholars](https://aws.amazon.com/about-aws/our-impact/scholars/?utm_source=linkedin&utm_medium=s-post&utm_campaign=launch) để tìm hiểu thêm và đăng ký.

![The AWS AI and ML Scholars Program is back](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/27/AWS-AIML.png)

Tôi cũng rất háo hức khi mùa [AWS Summit](https://aws.amazon.com/events/summits/) bắt đầu, mở màn với AWS Summit Paris vào ngày 1/4, tiếp theo là London vào ngày 22/4. AWS Summits là các sự kiện trực tiếp miễn phí, nơi builder và innovator có thể tìm hiểu về Cloud và AI, mở rộng tư duy và kết nối mới. Hãy [khám phá AWS Summits](https://aws.amazon.com/events/summits/#empowering-you-to-innovate-with-aws) gần bạn và tham gia trực tiếp.

Bây giờ, chúng ta cùng điểm qua các tin AWS tuần này.

## Các cập nhật nổi bật tuần trước

Dưới đây là những thông báo thu hút sự chú ý của tôi trong tuần qua:

- [Announcing Amazon Aurora PostgreSQL serverless database creation in seconds](https://aws.amazon.com/blogs/aws/announcing-amazon-aurora-postgresql-serverless-database-creation-in-seconds/) - Amazon Aurora PostgreSQL hiện có express configuration, một cách thiết lập tinh gọn với cấu hình mặc định dựng sẵn để tạo và kết nối cơ sở dữ liệu chỉ trong vài giây. Chỉ với hai lần nhấp, bạn có thể khởi tạo Aurora PostgreSQL serverless database. Bạn vẫn có thể chỉnh một số thiết lập trong hoặc sau khi tạo.
- [Amazon Aurora PostgreSQL now available with the AWS Free Tier](https://aws.amazon.com/about-aws/whats-new/2026/03/amazon-aurora-postgresql-aws-free-tier/) - Amazon Aurora PostgreSQL hiện đã có trên AWS Free Tier. Nếu bạn mới dùng AWS, bạn nhận $100 tín dụng khi đăng ký và có thể nhận thêm $100 khi sử dụng các dịch vụ như Amazon Relational Database Service (Amazon RDS).
- [Announcing Agent Plugin for AWS Serverless](https://aws.amazon.com/about-aws/whats-new/2026/03/agent-plugin-aws-serverless/) - Với Agent Plugin for AWS Serverless mới, bạn có thể dễ dàng xây dựng, triển khai, xử lý sự cố, và quản lý ứng dụng serverless bằng các AI coding assistant như Kiro, Claude Code, và Cursor. Plugin này mở rộng trợ lý AI bằng khả năng có cấu trúc thông qua việc đóng gói skills, sub-agents, và Model Context Protocol (MCP) servers thành một module thống nhất. Nó tự động nạp hướng dẫn và chuyên môn cần thiết xuyên suốt quá trình phát triển để xây dựng ứng dụng serverless sẵn sàng production trên AWS.
- [Amazon SageMaker Studio now supports Kiro and Cursor IDEs as remote IDEs](https://aws.amazon.com/about-aws/whats-new/2026/03/amazon-sagemaker-studio-kiro-cursor/) - Bạn có thể kết nối từ Kiro và Cursor IDE tới Amazon SageMaker Studio theo mô hình remote IDE. Điều này giúp bạn dùng chính thiết lập Kiro/Cursor hiện tại, bao gồm spec-driven development, conversational coding, và automated feature generation, trong khi vẫn tận dụng tài nguyên tính toán mở rộng của Amazon SageMaker Studio.
- [Introducing visual customization capability in AWS Management Console](https://aws.amazon.com/blogs/aws/customize-your-aws-management-console-experience-with-visual-settings-including-account-color-region-and-service-visibility/) - Bạn có thể tùy chỉnh AWS Management Console bằng các thiết lập trực quan như màu tài khoản, và kiểm soát Region/dịch vụ hiển thị. Việc ẩn Region và dịch vụ không dùng giúp bạn tập trung tốt hơn và làm việc nhanh hơn nhờ giảm tải nhận thức và thao tác cuộn không cần thiết.
- [Announcing Aurora DSQL connector to simplify building Ruby applications](https://aws.amazon.com/about-aws/whats-new/2026/03/aurora-dsql-connector-for-ruby/) - Bạn có thể dùng Aurora DSQL Connector cho Ruby (pg gem) để dễ dàng xây dựng ứng dụng Ruby trên Aurora DSQL. Connector này đơn giản hóa xác thực và tăng cường bảo mật bằng cách tự động sinh token cho mỗi kết nối, giảm rủi ro của mật khẩu truyền thống trong khi vẫn tương thích đầy đủ với các tính năng hiện có của pg gem.
- [AWS Lambda increases the file descriptor limit for functions running on Lambda Managed Instances](https://aws.amazon.com/about-aws/whats-new/2026/03/aws-Lambda-file-descriptors-increase-4096/) - AWS Lambda tăng giới hạn file descriptor từ 1.024 lên 4.096 (tăng 4 lần) cho các hàm chạy trên Lambda Managed Instances (LMI). Nhờ đó bạn có thể chạy các workload I/O-intensive như dịch vụ web đồng thời cao hoặc pipeline xử lý dữ liệu nhiều tệp mà không gặp giới hạn file descriptor.
- [AWS Lambda now supports up to 32 GB of memory and 16 vCPUs for Lambda Managed Instances](https://aws.amazon.com/about-aws/whats-new/2026/03/lambda-32-gb-memory-16-vcpus/) - Lambda trên Lambda Managed Instances nay hỗ trợ tới 32 GB RAM và 16 vCPU. Bạn có thể chạy workload tính toán nặng như xử lý dữ liệu, media transcoding, hoặc mô phỏng khoa học mà không cần tự quản lý hạ tầng. Đồng thời bạn có thể điều chỉnh tỉ lệ memory/vCPU (2:1, 4:1, hoặc 8:1) theo nhu cầu workload.
- [Announcing Bidirectional Streaming API for Amazon Polly](https://aws.amazon.com/blogs/machine-learning/introducing-amazon-polly-bidirectional-streaming-real-time-speech-synthesis-for-conversational-ai/) - Các API text-to-speech truyền thống dùng mô hình request-response. Bidirectional Streaming API mới của Amazon Polly được thiết kế cho ứng dụng AI hội thoại sinh text hoặc audio theo từng phần, ví dụ phản hồi từ LLM. Điều này cho phép bắt đầu tổng hợp âm thanh trước khi có toàn bộ văn bản hoàn chỉnh.

Để xem đầy đủ danh sách thông báo từ AWS, hãy theo dõi [News Blog](https://aws.amazon.com/blogs/aws/) và [What's New with AWS](https://aws.amazon.com/new/).

## Sự kiện AWS sắp diễn ra

Hãy kiểm tra lịch và đăng ký các sự kiện AWS sắp tới:

- [AWS Summits](https://aws.amazon.com/events/summits/) - Như đã đề cập ở trên, hãy tham gia AWS Summits 2026, các sự kiện trực tiếp miễn phí để khám phá công nghệ Cloud và AI mới nổi, học best practices, và kết nối với chuyên gia cũng như cộng đồng cùng ngành. Các Summit sắp tới gồm Paris (1/4), London (22/4), Bengaluru (23-24/4), Singapore (6/5), Tel Aviv (6/5), và Stockholm (7/5).
- [AWS Community Days](https://aws.amazon.com/developer/community/community-days/) - Các hội nghị do cộng đồng tổ chức, với nội dung được cộng đồng lên kế hoạch và trình bày, bao gồm thảo luận kỹ thuật, workshop, và hands-on lab. Sự kiện sắp tới gồm San Francisco (10/4) và Romania (23-24/4).

Tham gia [AWS Builder Center](https://builder.aws.com/) để kết nối với cộng đồng builder, chia sẻ giải pháp, và truy cập nội dung hỗ trợ quá trình phát triển. Bạn cũng có thể xem [AWS Events and Webinars](https://aws.amazon.com/events/) để cập nhật các sự kiện trực tiếp/online do AWS tổ chức và các sự kiện hướng đến nhà phát triển.

Đó là tất cả cho tuần này. Hẹn gặp lại vào thứ Hai tuần tới với một bản [Weekly Roundup](https://aws.amazon.com/blogs/aws/tag/week-in-review/?trk=7c8639c6-87c6-47d6-9bd0-a5812eecb848&sc_channel=el) mới.

- [Prasad](https://www.linkedin.com/in/kprasadrao/)

*Bài viết này thuộc chuỗi Weekly Roundup. Hãy quay lại mỗi tuần để xem bản tổng hợp nhanh về các tin tức và thông báo đáng chú ý từ AWS.*
