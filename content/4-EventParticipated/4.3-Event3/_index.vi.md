---
title: "Cloud Mastery 2026 #2 - Kubernetes, IaC và Elixir trong DevOps"
date: 2026-04-04
weight: 3
chapter: false
pre: " <b> 4.3. </b> "
---

## Báo cáo tóm tắt: "Cloud Mastery 2026 #2"

## Mục tiêu sự kiện

* Xây dựng nền tảng thực tiễn về kiến trúc Kubernetes và vận hành hằng ngày.
* Hiểu các phương pháp Infrastructure as Code (IaC) trên AWS với CloudFormation, AWS CDK và Terraform.
* Khám phá Elixir và OTP như một cách tiếp cận thống nhất cho các hệ thống DevOps có tính đồng thời cao và khả năng chịu lỗi tốt.

## Diễn giả

* **Bao Huynh** - Phiên: Thiết kế kiến trúc Cloud với Kubernetes
* **Nguyen Ta Minh Triet** - Phiên: Elixir như một giải pháp thống nhất cho hạ tầng DevOps có tính đồng thời cao và chịu lỗi
* **Khanh Phuc Thinh Nguyen** - Phiên: Infrastructure as Code với Terraform trên AWS


## Điểm nổi bật chính

### Phiên 1: Thiết kế kiến trúc Cloud với Kubernetes

Phiên đầu tiên giới thiệu các thách thức trong điều phối container và giải thích vì sao Kubernetes trở thành nền tảng tiêu chuẩn trong ngành để chạy các ứng dụng container ở quy mô lớn.

Các ý chính:
* **Kiến trúc cốt lõi:** Các thành phần Control Plane (etcd, API Server, Scheduler, Controller Manager, **Cloud Controller Manager**) và các thành phần Worker Node (kubelet, kube-proxy, container runtime).
* **Các đối tượng quan trọng:** Pods, ReplicaSets, Deployments, ConfigMaps, Secrets và Jobs.
* **Vận hành cơ bản:** Kubernetes manifests (YAML) và các lệnh kubectl thường dùng.
* **Lộ trình học:** Bắt đầu cục bộ với Minikube, K3s hoặc K3d, sau đó chuyển sang môi trường managed như Amazon EKS **(giúp giảm đáng kể việc thiết lập thủ công nhờ quản lý toàn bộ control plane)**. Để hiểu sâu cơ chế bên dưới, **"Kubernetes the Hard Way" của Kelsey Hightower** được khuyến nghị.
* **Công cụ hệ sinh thái:** Helm để đóng gói/triển khai và K9s để quan sát và vận hành cluster ngay trên terminal.

Phiên này giúp kết nối kiến thức lý thuyết về Kubernetes với một lộ trình học thực tế có thể áp dụng cho cả dự án cá nhân lẫn môi trường production.

![k8s architecture](/images/4-Event/e3k8s.png "k8s Architecture")
![actual image](/images/4-Event/ws2k8s.jpg "actual image")

---

### Phiên 2: Elixir cho hệ thống DevOps đồng thời cao và chịu lỗi

Phiên thứ hai trình bày Elixir và hệ sinh thái BEAM như một lựa chọn mạnh mẽ để xây dựng các nền tảng backend có khả năng chịu lỗi cao và xử lý đồng thời lớn.

Các ý chính:
* **Kiến thức nền tảng Elixir:** Lập trình hàm, dữ liệu bất biến, pattern matching và nền tảng Erlang/BEAM. **Elixir có cú pháp lấy cảm hứng từ Ruby nhưng biên dịch thành bytecode chạy trên BEAM VM, tương tự Java.**
* **Mô hình đồng thời:** Các tiến trình nhẹ của BEAM và cơ chế scheduler giúp mở rộng tốt. **Một minh chứng nổi bật là Phoenix Framework có thể xử lý tới 2 triệu kết nối WebSocket trên một server.**
* **Khả năng chịu lỗi với OTP:** Cơ chế giám sát tiến trình, triết lý "Let It Crash" và khả năng phục hồi mạnh mẽ khi runtime gặp lỗi.
* **Lợi ích vận hành:** Công cụ tích hợp **(như Mix và IEx)** hỗ trợ cả phát triển và vận hành, cùng với **khả năng nâng cấp code nóng (hot code upgrade) không cần downtime.**
* **Tác động thực tế:** Các case study cho thấy tối ưu chi phí đáng kể khi chuyển workload throughput cao từ serverless sang Elixir **(ví dụ: viết lại dịch vụ AWS API Gateway/Lambda Node.js sang Elixir giúp giảm chi phí từ hơn 12,000 USD xuống dưới 400 USD mỗi tháng).**

Phiên này mở rộng góc nhìn vượt ra ngoài các stack DevOps phổ biến, cho thấy việc lựa chọn ngôn ngữ/runtime có thể ảnh hưởng trực tiếp đến độ tin cậy và chi phí hạ tầng.

![benefits](/images/4-Event/e3benefit.png)
![actual image](/images/4-Event/ws2elixir.jpg "actual image")

---

### Phiên 3: Infrastructure as Code với Terraform trên AWS

Phiên thứ ba tập trung vào Infrastructure as Code như một phương pháp hiện đại thay thế cho việc cấu hình cloud thủ công (ClickOps), nhấn mạnh tự động hóa, tính nhất quán và khả năng tái tạo.

Các ý chính:
* **Tư duy IaC:** Định nghĩa hạ tầng cloud bằng code để giảm lỗi thủ công và cải thiện khả năng cộng tác.
* **Kiến thức cơ bản về CloudFormation:** Templates, stacks, cấu trúc template **(bao gồm Parameters, Mappings, Conditions và Outputs)**, và phát hiện drift. **Ngoài ra, các dịch vụ như AWS Amplify cũng sử dụng CloudFormation phía sau.**
* **Khái niệm AWS CDK:** Các cấp độ construct (L1, L2, L3), construct tree và quy trình triển khai với CDK CLI. **Ưu điểm lớn của CDK là hỗ trợ các ngôn ngữ lập trình phổ biến như TypeScript, Python, Java, C#/.Net và Go.**
* **Kiến thức cơ bản về Terraform:** Cấu trúc HCL, tổ chức project (cơ bản và nâng cao), luồng thực thi (`init`, `validate`, `plan`, `apply`, `destroy`), quản lý state, **và thế mạnh trong triển khai đa cloud.**
* **Tiêu chí chọn công cụ:** Lựa chọn IaC dựa trên chiến lược cloud (một cloud hay đa cloud), kỹ năng đội ngũ và mức độ tương thích hệ sinh thái. **Một số lựa chọn khác như OpenTofu và Pulumi cũng được nhắc đến.**

Phiên này cung cấp cái nhìn rõ ràng về sự khác biệt giữa các công cụ IaC native của AWS và các giải pháp đa cloud, rất hữu ích khi lựa chọn công cụ trong dự án thực tế.

![alt text](/images/4-Event/e3cf.png)


---

## Kết quả và giá trị đạt được

Thông qua sự kiện này, tôi có được cái nhìn rộng hơn và mang tính kết nối về cloud engineering hiện đại:
* Cách thiết kế và vận hành hệ thống container với Kubernetes.
* Cách tư duy về khả năng chịu lỗi và xử lý đồng thời ở tầng runtime ứng dụng với Elixir/OTP.
* Cách quản lý vòng đời hạ tầng bằng IaC trong môi trường AWS và đa cloud.

![actual image](/images/4-Event/ws2team.jpg "actual image")

Sự kiện cũng giúp làm rõ một lộ trình thực tế: bắt đầu với Kubernetes cục bộ, áp dụng IaC một cách nhất quán cho việc triển khai, và cân nhắc các công nghệ runtime có tính chịu lỗi cao như Elixir khi xây dựng các dịch vụ có mức độ đồng thời lớn.

> Nhìn chung, Cloud Mastery 2026 #2 mang lại sự cân bằng tốt giữa nguyên lý kiến trúc, thực hành triển khai và các đánh đổi kỹ thuật trong thực tế xoay quanh Kubernetes, IaC và các hệ thống backend có độ bền cao.

