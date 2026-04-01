---
title: "Tổng kết AWS re:Invent 2025 - Phiên bản Việt Nam"
date: 2026-01-27
weight: 1
chapter: false
pre: " <b> 4.1. </b> "
---

# Báo cáo tổng kết: "AWS re:Invent 2025 Recap - Vietnam Edition"

### Mục tiêu sự kiện

- Tổng kết những thông báo và đổi mới quan trọng nhất được giới thiệu tại AWS re:Invent 2025.
- Giúp cộng đồng developer Việt Nam nhanh chóng nắm bắt các dịch vụ AWS mới và xu hướng kiến trúc cloud hiện đại.
- Cung cấp góc nhìn về các công nghệ cloud tiên tiến, bao gồm Generative AI, Agentic AI và hạ tầng dữ liệu thế hệ mới.

### Các điểm nổi bật chính

#### Generative AI và Agentic Systems trên AWS

Một trong những trọng tâm chính của sự kiện là sự phát triển nhanh chóng của **Generative AI và các AI Agent tự động** trong hệ sinh thái AWS.  
Người tham dự được giới thiệu về **Amazon Bedrock** và **họ mô hình Nova**, cung cấp các foundation model được quản lý sẵn, cho phép developer dễ dàng tích hợp vào ứng dụng.

Buổi chia sẻ cũng nhấn mạnh **Bedrock Agents**, một framework được thiết kế để xây dựng các hệ thống thông minh có khả năng tự động thực thi các workflow phức tạp. Các agent này hỗ trợ nhiều khả năng quan trọng:

- **Orchestration và quản lý Flow** để điều phối các tác vụ nhiều bước.
- **Hệ thống Memory** cho phép agent lưu giữ thông tin ngữ cảnh.
- **Policies và Guardrails** nhằm đảm bảo hành vi AI an toàn và được kiểm soát.
- **Công cụ Evaluation** để theo dõi và cải thiện hiệu năng của agent.

Những thành phần này cho phép developer xây dựng các ứng dụng AI tiên tiến có khả năng tương tác với các công cụ và nguồn dữ liệu bên ngoài.

---

#### SageMaker Unified Studio và các cải tiến của S3

Một chủ đề quan trọng khác là sự phát triển của **môi trường phát triển machine learning trên AWS**.  
Công cụ mới **SageMaker Unified Studio** cung cấp một workspace tập trung nơi **Data Engineer, Data Scientist và AI Engineer** có thể cộng tác trong cùng một IDE tích hợp.

Bên cạnh đó, nhiều cải tiến của **Amazon S3** cũng được giới thiệu:

- **S3 Tables** cho phép lưu trữ dữ liệu gốc bằng định dạng bảng **Apache Iceberg**, giúp đơn giản hóa các workflow phân tích dữ liệu quy mô lớn.
- **S3 Vector** cung cấp khả năng lưu trữ vector tích hợp sẵn, giúp giảm đáng kể chi phí quản lý embedding so với các vector database truyền thống.

Những cập nhật này cho thấy nỗ lực của AWS trong việc hợp nhất lưu trữ dữ liệu, phân tích dữ liệu và phát triển AI trên một nền tảng duy nhất.

---

#### OpenSearch và Agentic Search

Sự kiện cũng giới thiệu các khả năng mới của **OpenSearch Serverless**, đặc biệt là khả năng tích hợp với các hệ thống AI hiện đại.

Một số khái niệm quan trọng bao gồm:

- Tích hợp với **Model Context Protocol (MCP)**.
- Khái niệm **Agentic Memory**, cho phép hệ thống AI lưu trữ và tận dụng tri thức từ quá trình tìm kiếm.
- Triển khai các **agent chuyên biệt** phục vụ cho các tác vụ phân tích dữ liệu.

Một demo trực tiếp đã minh họa cách một **Flow Agent** có thể tự động phân tích dữ liệu bán hàng và trích xuất insight bằng cách tương tác với hệ thống tìm kiếm và các công cụ phân tích.

---

#### Advanced RAG và Multimodal AI

Ngoài các ứng dụng AI dựa trên văn bản truyền thống, sự kiện cũng khám phá sự phát triển của **Retrieval-Augmented Generation (RAG)** theo hướng **đa phương thức (multimodal)**.

Các công nghệ quan trọng được thảo luận bao gồm:

- **Nova Multimodal Embeddings**, cho phép chuyển đổi hình ảnh và video thành vector.
- **Bedrock Data Automation**, giúp tự động trích xuất và cấu trúc thông tin từ các nguồn dữ liệu đa phương tiện.

Những đổi mới này cho phép hệ thống AI làm việc với nhiều loại dữ liệu hơn như **hình ảnh, video và âm thanh**, mở rộng đáng kể khả năng của các ứng dụng thông minh.

---

#### Hạ tầng AI và chuyên sâu về SageMaker

Phiên cuối cùng tập trung vào **hạ tầng cần thiết để huấn luyện và triển khai các hệ thống AI quy mô lớn**.

Một số công cụ trong hệ sinh thái **SageMaker** được giới thiệu:

- **SageMaker HyperPod**, được thiết kế để quản lý các cụm GPU lớn phục vụ workload deep learning.
- **SageMaker MLflow**, hỗ trợ theo dõi thí nghiệm và quản lý vòng đời của các mô hình machine learning.
- **Khả năng streaming hai chiều**, cho phép xây dựng các ứng dụng AI **Voice-to-Voice theo thời gian thực**.

Những tính năng này cho thấy AWS đang tập trung vào việc cung cấp hạ tầng có khả năng mở rộng cho thế hệ hệ thống AI tiếp theo.

---

#### Một số hình ảnh tại sự kiện

![Anh su kien AWS re:Invent 1](/images/event/AWS%20reInvent%202025%20Recap%20Vietnam%20Edition/153579dd169e97c0ce8f2.jpg "AWS re:Invent 1")
![Anh su kien AWS re:Invent 2](/images/event/AWS%20reInvent%202025%20Recap%20Vietnam%20Edition/619d0f756036e168b827.jpg "AWS re:Invent 2")
![Anh su kien AWS re:Invent 3](/images/event/AWS%20reInvent%202025%20Recap%20Vietnam%20Edition/85f27d1a12599307ca481.jpg "AWS re:Invent 3")

> Nhìn chung, sự kiện đã mang lại cái nhìn tổng quan toàn diện về những thông báo quan trọng tại AWS re:Invent 2025, đặc biệt trong các lĩnh vực Generative AI, kiến trúc agent-based và nền tảng dữ liệu hiện đại. Các phiên chia sẻ cũng cung cấp nhiều insight thực tế về cách áp dụng các dịch vụ AWS vào các hệ thống thực tế như kiến trúc NutriTrack, đồng thời mang đến cơ hội để người tham dự kết nối trực tiếp với các AWS Solution Architect và cộng đồng cloud địa phương.