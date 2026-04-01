---
title: "Hai muoi nam Amazon S3 va nhung buoc di tiep theo"
date: 2026-03-13
weight: 4
chapter: false
pre: " <b> 3.4. </b> "
---

{{% notice info %}}
Bản dịch tiếng Việt phục vụ mục đích học tập. Bài gốc: "Twenty years of Amazon S3 and building what's next" by Sebastien Stormacq, 13 MAR 2026 — https://aws.amazon.com/blogs/aws/twenty-years-of-amazon-s3-and-building-whats-next/
{{% /notice %}}

# Hai muoi nam Amazon S3 va nhung buoc di tiep theo

Tac gia goc: [Sebastien Stormacq](https://aws.amazon.com/blogs/aws/author/stormacq/) | Ngay dang: 13 MAR 2026

Hai mươi năm trước, vào ngày 14/03/2006, [Amazon Simple Storage Service (Amazon S3)](https://aws.amazon.com/s3/) đã ra mắt một cách khá lặng lẽ với một thông báo ngắn chỉ một đoạn trên [trang What's New](https://aws.amazon.com/about-aws/whats-new/2006/03/announcing-amazon-s3---simple-storage-service/):

> Amazon S3 la dich vu luu tru cho Internet. Dich vu nay duoc thiet ke de giup lap trinh vien de dang xay dung he thong tinh toan quy mo web. Amazon S3 cung cap mot giao dien web service don gian de luu tru va truy xuat moi luong du lieu, vao bat ky luc nao, tu bat ky dau tren web. No mang den cho moi developer quyen truy cap vao ha tang luu tru co do mo rong cao, do tin cay cao, toc do nhanh va chi phi hop ly ma Amazon dung de van hanh mang luoi website toan cau cua minh.

Ngay cả [bài blog của Jeff Barr](https://aws.amazon.com/blogs/aws/amazon_s3/) khi đó cũng chỉ có vài đoạn ngắn, được viết trước khi ông lên máy bay đi sự kiện developer ở California. Không ví dụ code. Không demo. Không nhiều truyền thông. Khi ấy, chưa ai biết lần ra mắt đó sẽ định hình cả ngành công nghiệp.

## Những ngày đầu: Các khối xây dựng chỉ cần hoạt động tốt

Về cốt lõi, S3 giới thiệu hai primitive đơn giản: PUT để lưu object và GET để truy xuất lại sau đó. Nhưng đổi mới lớn nhất nằm ở triết lý đằng sau: tạo ra các building block xử lý phần hạ tầng nặng nhọc nhưng không tạo khác biệt trực tiếp, từ đó giải phóng developer tập trung vào bài toán cấp cao hơn.

Ngay từ ngày đầu, S3 đã bám theo năm nguyên tắc nền tảng và đến nay vẫn không thay đổi.

**Security** nghĩa là dữ liệu của bạn được bảo vệ mặc định. **Durability** được thiết kế ở mức 11 số 9 (99.999999999%), và S3 được vận hành theo hướng không mất dữ liệu. **Availability** được thiết kế ở mọi lớp, với giả định lỗi luôn tồn tại và phải được xử lý. **Performance** được tối ưu để lưu trữ lượng dữ liệu gần như không giới hạn mà không suy giảm. **Elasticity** nghĩa là hệ thống tự động tăng/giảm theo dữ liệu bạn thêm hoặc xóa, không cần can thiệp thủ công.

Khi làm tốt những điều này, dịch vụ trở nên đủ đơn giản để phần lớn người dùng không cần nghĩ đến độ phức tạp phía sau.

## S3 hiện tại: Quy mô vượt ngoài tưởng tượng

Trong suốt 20 năm, S3 vẫn giữ vững các nguyên tắc cốt lõi, đồng thời phát triển tới quy mô rất khó hình dung.

Khi mới ra mắt, S3 có khoảng một petabyte dung lượng lưu trữ tổng, trải trên khoảng 400 storage node, 15 rack và 3 data center, với tổng băng thông 15 Gbps. Hệ thống khi đó được thiết kế để lưu hàng chục tỷ object, kích thước object tối đa 5 GB. Mức giá ban đầu là 15 cent cho mỗi GB.

![S3 key metrics illustration](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/10/s3-illustration-2-1024x538.png)

Ngày nay, S3 lưu trữ hơn 500 nghìn tỷ object và phục vụ hơn 200 triệu request mỗi giây trên phạm vi toàn cầu, với hàng trăm exabyte dữ liệu, trải trên 123 Availability Zone tại 39 AWS Region cho hàng triệu khách hàng. [Kích thước object tối đa đã tăng từ 5 GB lên 50 TB](https://aws.amazon.com/about-aws/whats-new/2025/12/amazon-s3-maximum-object-size-50-tb/), tương đương tăng 10.000 lần. Nếu xếp chồng hàng chục triệu ổ cứng của S3 lên nhau, độ cao sẽ chạm tới Trạm Vũ trụ Quốc tế và gần như quay trở lại.

Dù S3 tăng trưởng đến quy mô khổng lồ, chi phí bạn trả lại giảm mạnh. Hiện tại AWS thu hơi trên [2 cent cho mỗi GB](https://aws.amazon.com/s3/pricing/). Đây là mức giảm khoảng 85% so với thời điểm 2006. Song song đó, AWS liên tục ra mắt các cách tối ưu chi phí lưu trữ với storage tier. Ví dụ, khách hàng đã tiết kiệm tổng cộng hơn 6 tỷ USD chi phí lưu trữ khi dùng [Amazon S3 Intelligent-Tiering](https://aws.amazon.com/s3/storage-classes/intelligent-tiering/) so với [Amazon S3 Standard](https://aws.amazon.com/s3/storage-classes/).

Trong hai thập kỷ qua, [S3 API](https://docs.aws.amazon.com/AmazonS3/latest/API/Welcome.html) đã được chấp nhận rộng rãi và trở thành chuẩn tham chiếu trong ngành storage. Nhiều nhà cung cấp hiện cung cấp công cụ và hệ thống tương thích S3, áp dụng cùng pattern API và quy ước. Điều này giúp kỹ năng và công cụ phát triển cho S3 có thể chuyển giao sang các hệ storage khác, làm cho hệ sinh thái lưu trữ nói chung dễ tiếp cận hơn.

Dù tăng trưởng mạnh và được toàn ngành chấp nhận, có lẽ thành tựu ấn tượng nhất là: đoạn code bạn viết cho S3 năm 2006 vẫn chạy được đến hôm nay, không cần chỉnh sửa. Dữ liệu của bạn đã đi qua 20 năm đổi mới kỹ thuật. AWS đã di chuyển hạ tầng qua nhiều thế hệ đĩa và hệ lưu trữ. Toàn bộ code xử lý request đã được viết lại. Nhưng dữ liệu bạn lưu từ 20 năm trước vẫn còn đó, và AWS vẫn duy trì tương thích ngược API đầy đủ. Đó là cam kết của S3 để dịch vụ luôn hoạt động ổn định và đáng tin cậy.

## Kỹ thuật phía sau quy mô đó

Điều gì làm S3 có thể vận hành ở quy mô này? Đó là đổi mới kỹ thuật liên tục.

Nhiều nội dung dưới đây dựa trên cuộc trò chuyện giữa Mai-Lan Tomsen Bukovec, VP of Data and Analytics tại AWS, và [Gergely Orosz](https://www.linkedin.com/in/gergelyorosz/) từ [The Pragmatic Engineer](https://newsletter.pragmaticengineer.com/podcast). [Bài phỏng vấn chuyên sâu](https://newsletter.pragmaticengineer.com/p/how-aws-s3-is-built) đi sâu hơn nhiều vào chi tiết kỹ thuật cho những ai muốn tìm hiểu thêm. Trong phần dưới, tác giả chia sẻ một số ví dụ.

Trọng tâm của durability trong S3 là hệ thống microservices liên tục kiểm tra từng byte dữ liệu trên toàn bộ fleet. Các dịch vụ kiểm định này rà soát dữ liệu và tự động kích hoạt hệ thống sửa chữa ngay khi phát hiện dấu hiệu suy giảm. S3 được thiết kế theo hướng không mất dữ liệu: mục tiêu 11 số 9 phản ánh cách AWS định cỡ hệ số nhân bản và đội tái sao chép, nhưng bản thân hệ thống được xây để object không bị mất.

Kỹ sư S3 sử dụng [formal methods và automated reasoning](https://www.amazon.science/publications/using-lightweight-formal-methods-to-validate-a-key-value-storage-node-in-amazon-s3) trong production để chứng minh tính đúng đắn về mặt toán học. Khi kỹ sư commit code vào subsystem index, các bằng chứng tự động sẽ xác minh rằng tính nhất quán không bị suy giảm. Cách tiếp cận này cũng được dùng để chứng minh tính đúng trong [cross-Region replication](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html) hoặc với [access policy](https://aws.amazon.com/blogs/security/protect-sensitive-data-in-the-cloud-with-automated-reasoning-zelkova/).

Trong 8 năm qua, AWS đã từng bước viết lại các phần code quan trọng về hiệu năng trong đường xử lý request của S3 bằng Rust. Phần di chuyển blob và lưu trữ trên đĩa đã được viết lại, và nhiều thành phần khác vẫn đang tiếp tục. Ngoài hiệu năng thuần, hệ kiểu và bảo đảm an toàn bộ nhớ của Rust giúp loại bỏ cả nhóm lỗi ngay từ lúc biên dịch. Đây là thuộc tính then chốt khi vận hành ở quy mô và mức yêu cầu tính đúng cao như S3.

S3 được xây dựng trên một triết lý thiết kế: quy mô càng lớn càng có lợi. Kỹ sư thiết kế hệ thống sao cho khi quy mô tăng, các thuộc tính của hệ thống cũng tốt hơn cho tất cả người dùng. S3 càng lớn, workload càng tách rời tương quan, từ đó tăng độ tin cậy chung.

## Nhìn về phía trước

Tầm nhìn của S3 không dừng ở một dịch vụ lưu trữ, mà hướng tới trở thành nền tảng phổ quát cho mọi workload dữ liệu và AI. Tầm nhìn này rất rõ: bạn lưu mọi loại dữ liệu một lần trên S3 và làm việc trực tiếp trên đó, không phải di chuyển dữ liệu qua các hệ chuyên biệt khác nhau. Cách tiếp cận này giúp giảm chi phí, giảm độ phức tạp, và loại bỏ nhu cầu tạo nhiều bản sao của cùng một dữ liệu.

Một số lần ra mắt nổi bật gần đây:

- [S3 Tables](https://aws.amazon.com/blogs/aws/new-amazon-s3-tables-storage-optimized-for-analytics-workloads/) - Apache Iceberg table được quản lý hoàn toàn, có bảo trì tự động để tối ưu hiệu quả truy vấn và giảm chi phí lưu trữ theo thời gian.
- [S3 Vectors](https://aws.amazon.com/blogs/aws/amazon-s3-vectors-now-generally-available-with-increased-scale-and-performance/) - Lưu trữ vector native cho semantic search và RAG, hỗ trợ tới 2 tỷ vector mỗi index với độ trễ truy vấn dưới 100ms. Chỉ trong 5 tháng (07-12/2025), người dùng đã tạo hơn 250.000 index, ingest hơn 40 tỷ vector và thực hiện hơn 1 tỷ truy vấn.
- [S3 Metadata](https://aws.amazon.com/blogs/aws/amazon-s3-metadata-now-supports-metadata-for-all-your-s3-objects/) - Metadata tập trung để khám phá dữ liệu tức thì, loại bỏ nhu cầu list đệ quy bucket lớn khi catalog dữ liệu và giảm đáng kể thời gian để có insight từ data lake quy mô lớn.

Mỗi khả năng trên đều vận hành theo cấu trúc chi phí của S3. Bạn có thể xử lý nhiều loại dữ liệu mà trước đây thường phải dùng database đắt đỏ hoặc hệ chuyên dụng, nhưng giờ đã khả thi về mặt kinh tế ở quy mô lớn.

Từ 1 petabyte đến hàng trăm exabyte. Từ 15 cent xuống 2 cent mỗi GB. Từ object storage đơn giản thành nền tảng cho AI và analytics. Xuyên suốt hành trình đó, năm nguyên tắc cốt lõi-security, durability, availability, performance, elasticity-vẫn không thay đổi, và code từ năm 2006 của bạn vẫn chạy đến hôm nay.

Hướng tới 20 năm đổi mới tiếp theo cùng [Amazon S3](https://aws.amazon.com/s3/).

- [seb](https://linktr.ee/sebsto)
