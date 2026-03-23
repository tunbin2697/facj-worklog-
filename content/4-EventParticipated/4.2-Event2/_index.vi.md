---
title: "Cloud Mastery 2026 #1 AI From Scratch"
date: 2026-03-14
weight: 2
chapter: false
pre: " <b> 4.2. </b> "
---


# Bài thu hoạch Sự kiện: "Ứng dụng AI Agent, Prompt Engineering và AIoT trên AWS"

### Mục Đích Của Sự Kiện

- Hiểu rõ giới hạn của LLM độc lập và cách khắc phục thông qua AI Agent.
- Nắm bắt nghệ thuật giao tiếp với AI thông qua các kỹ thuật Prompt Engineering chuẩn mực để tối ưu chi phí và chất lượng.
- Khám phá các ứng dụng thực tế của AIoT kết hợp với các dịch vụ Cloud của AWS (IoT Core, Rekognition).

### Danh Sách Diễn Giả

- **Bành Cẩm Vinh** - Speaker chủ đề Building AI Agent with Strands
- **Nguyễn Tuấn Thịnh** - DevOps Engineer, Speaker chủ đề Automated Prompt Engineering
- **Aiden Dinh & Trần Vũ Bảo Ngọc** - Operation Engineer (Katalon), Speaker chủ đề AIoT Projects

### Nội Dung Nổi Bật

#### Xây dựng AI Agent với Strands

Mô hình ngôn ngữ lớn (LLM) độc lập thường gặp hạn chế do không có dữ liệu thời gian thực và thiếu khả năng tương tác với hệ thống bên ngoài. Việc sử dụng AI Agent giúp giải quyết vấn đề này với các đặc điểm:
- **Lập luận đa bước (Multi-step reasoning):** Lập kế hoạch và thực thi các quy trình làm việc phức tạp.
- **Tích hợp công cụ (Tool integration):** Truy cập API, cơ sở dữ liệu và các dịch vụ bên ngoài.
- Ứng dụng framework **Strands Agents** với cơ chế **Agentic Loop** (vòng lặp gọi công cụ), kết hợp System Prompts và Knowledge Base để tự động đưa ra quyết định và phản hồi theo ngữ cảnh thay đổi.

![Mô hình hoạt động của AI Agent](/images/4-Event/Agent.png "AI Agent Architecture")

#### Kỹ thuật Prompt Engineering Tự động

Giao tiếp với AI là một nghệ thuật. Câu lệnh (prompt) chung chung sẽ dẫn đến kết quả kém, gây lãng phí Token (tăng chi phí) và thiếu tính nhất quán.
Một Prompt tiêu chuẩn cần có đủ 7 thành phần:
1. **Role** (Vai trò của AI)
2. **Instruction** (Chỉ thị rõ ràng)
3. **Context** (Ngữ cảnh nền tảng)
4. **Input Data** (Dữ liệu đầu vào)
5. **Output Format** (Định dạng đầu ra mong muốn)
6. **Examples** (Ví dụ mẫu - Few-shot)
7. **Constraints** (Ràng buộc/Giới hạn cần tuân thủ)

Kiến trúc hệ thống quản lý Prompt tối ưu trên AWS được thiết kế bao gồm: **Amazon DynamoDB** (lưu trữ với tốc độ phản hồi mili-giây), **Amazon CloudWatch** (giám sát log, độ trễ và tỷ lệ lỗi), và nền tảng **Amazon Bedrock**.

![Cấu trúc Prompt và Kiến trúc AWS](/images/4-Event/prompt.png "Prompt Engineering & AWS")

#### Dự án AIoT: Quản lý Tủ đồ Thông minh (Smart Locker)

Giải quyết bài toán mượn đồ thủ công tại các câu lạc bộ bằng hệ thống tủ đồ tự động:
- **Phần cứng (Hardware):** Sử dụng Raspberry Pi làm Controller/MQTT Broker nội bộ; Arduino thu thập dữ liệu cảm biến; kết hợp Reed Switch, RFID Card Reader và Camera.
- **Tích hợp AWS Cloud:** - **AWS IoT Core:** Đóng vai trò trung tâm định tuyến các sự kiện cảm biến (quét RFID, mở cửa) đến Lambda và DynamoDB, giúp mở rộng mà không phụ thuộc server cục bộ.
  - **AWS Rekognition:** Phân tích hình ảnh, so sánh khuôn mặt người mượn với cơ sở dữ liệu thành viên để cấp quyền truy cập.

![Sơ đồ kiến trúc phần cứng và AWS cho dự án AIoT](/images/4-Event/AIot.png "AIoT Smart Locker Architecture")

#### Một số hình ảnh khi tham gia sự kiện

![Ảnh check-in sự kiện](/images/4-Event/event1a.jpg "Check-in")
![Ảnh chụp cùng diễn giả](/images/4-Event/event1b.jpg "Chụp cùng diễn giả")

> Tổng thể, sự kiện không chỉ mang lại cái nhìn sâu sắc về các xu hướng công nghệ AI hiện đại như Agent và Prompt Engineering, mà còn cung cấp kiến thức thực tiễn về cách kết hợp phần cứng IoT với hạ tầng linh hoạt của AWS để giải quyết các bài toán thực tế.