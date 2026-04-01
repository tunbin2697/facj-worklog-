---
title: "Worklog Tuần 12"
date: 2026-03-30
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

### Mục tiêu Tuần 12

* Thực hiện bài thuyết trình cuối cùng cho tất cả các bên liên quan.
* Hoàn thành phần tự đánh giá và phản hồi.
* Nộp báo cáo thực tập.
* Ăn mừng hoàn thành dự án và nhìn lại hành trình đã qua.

### Các nhiệm vụ đã thực hiện trong tuần

| Ngày | Nhiệm vụ | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 1 | - Chuẩn bị cho bài thuyết trình cuối <br>&emsp; + Tổng duyệt lần cuối cùng cùng với team <br>&emsp; + Chuẩn bị video demo dự phòng cho ứng dụng myFit <br>&emsp; + Kiểm tra lại thiết lập kỹ thuật của API và Bedrock | 30/03/2026 | 30/03/2026 | [Presentation] |
| 2 | - Thuyết trình cuối cùng <br>&emsp; + Trình bày myFit trước ban lãnh đạo FCAJ <br>&emsp; + Demo trực tiếp kèm phần hỏi đáp (Q&A) <br>&emsp; + Nhận được lời khen về kiến trúc Spring Boot và AWS vững chắc | 31/03/2026 | 31/03/2026 | [Presentation Recording] |
| 3 | - Tự đánh giá <br>&emsp; + Hoàn thành biểu mẫu tự đánh giá <br>&emsp; + Nhìn lại hành trình 12 tuần <br>&emsp; + Xác định các điểm mạnh kỹ thuật và các lĩnh vực cần phát triển thêm | 01/04/2026 | 01/04/2026 | [Evaluation Form] |
| 4 | - Phản hồi về chương trình <br>&emsp; + Viết phản hồi chi tiết cho chương trình FCAJ <br>&emsp; + Nêu bật những trải nghiệm tích cực <br>&emsp; + Đề xuất cải thiện cho các thực tập sinh trong tương lai | 02/04/2026 | 02/04/2026 | [Feedback Form] |
| 6-7 | - Ăn mừng & tổng kết <br>&emsp; + Tiệc ăn mừng cùng team <br>&emsp; + Chuyển giao kiến thức và bàn giao dự án <br>&emsp; + Đăng bài trên LinkedIn về trải nghiệm thực tập | 04/04/2026 | 05/04/2026 | [Photos] |

### Thành tựu Tuần 12

* **Bài thuyết trình cuối:**
  * Trình bày thành công ứng dụng myFit trước các bên liên quan và mentor của FCAJ.
  * Demo trực tiếp ứng dụng React Native và tính năng AI Chat Bedrock diễn ra suôn sẻ, không gặp sự cố kỹ thuật.

* **Hoàn thành dự án:**
  * Backend myFit (Spring Boot) và Frontend (React Native) hoạt động đầy đủ và đã tích hợp hoàn chỉnh.
  * Tất cả tài liệu đã hoàn thiện, bao gồm tài liệu API, sơ đồ kiến trúc và hướng dẫn cài đặt.
  * Repository GitHub được tổ chức lại, dọn dẹp code.

* **Phát triển cá nhân:**
  * Thành thạo các dịch vụ AWS quan trọng (Cognito, S3, Bedrock, Secrets Manager).
  * Tích lũy kinh nghiệm sâu về phát triển full-stack end-to-end.
  * Cải thiện kỹ năng thuyết trình, giải quyết vấn đề và viết tài liệu kỹ thuật.
  * Xây dựng được mạng lưới quan hệ tốt với các chuyên gia AWS và mentor.

### Tổng kết toàn bộ kỳ thực tập

**Các giai đoạn trong hành trình 12 tuần:**

| Phase | Weeks | Thành tựu chính |
|------|------|-----------------|
| Nền tảng | 1-2 | Thiết lập dự án, thiết kế database, xây dựng REST API cơ bản |
| Phát triển cốt lõi | 3-6 | Xác thực AWS Cognito, tích hợp S3 Media, System Workouts |
| Mở rộng tính năng | 7-8 | Module Workout Sessions và theo dõi dinh dưỡng |
| Tích hợp AI | 9-10 | Tính toán chỉ số sức khỏe, AI Fitness Coach với AWS Bedrock |
| Tối ưu | 11 | Hoàn thiện UI, kiểm thử E2E, sẵn sàng Docker Compose |
| Hoàn thiện | 12 | Tài liệu, thuyết trình cuối, nộp báo cáo |

**Thống kê dự án:**
* Hơn **10 module REST API cốt lõi** được phát triển hoàn chỉnh (Auth, Food, Workout, Metrics, ...)
* **6 luồng người dùng đầy đủ** được thiết kế và kiểm thử thành công
* Triển khai **bộ nhớ sliding window 12 lượt hội thoại** cho AI Fitness Bot
* Thời gian khởi động Docker Compose backend trung bình **dưới 25 giây**

### Suy ngẫm cuối cùng

Kỳ thực tập 12 tuần thông qua chương trình FCAJ là một trải nghiệm mang tính bước ngoặt. Từ việc thiết kế các schema PostgreSQL ban đầu ở Tuần 1 cho đến khi triển khai một ứng dụng React Native tích hợp AI hoàn chỉnh ở Tuần 12, hành trình này đã giúp tôi hiểu rõ tầm quan trọng của:

1. **Security by design**, đặc biệt là phòng chống IDOR, quản lý JWT stateless và tích hợp AWS Cognito một cách an toàn.
2. **Separation of concerns** trong toàn bộ hệ thống (sử dụng Redux cho auth, React Query cho server cache và giữ cho backend service layer sạch sẽ).
3. **Vận hành cloud theo mô hình Well-Architected**, đảm bảo containerization ổn định và có lộ trình triển khai AWS rõ ràng.
4. **Hợp tác nhóm và tài liệu hóa**, là chìa khóa để đảm bảo khả năng bảo trì và bàn giao dự án thành công.

Tôi vô cùng biết ơn các mentor của FCAJ, các AWS Solution Architect và đồng nghiệp đã giúp trải nghiệm này trở nên đáng nhớ. Đây không phải là điểm kết thúc, mà là nền tảng vững chắc cho hành trình cloud và full-stack trong tương lai của tôi! ☁️🚀


