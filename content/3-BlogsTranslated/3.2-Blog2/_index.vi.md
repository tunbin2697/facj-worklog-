---
title: "Tuy chinh AWS Management Console voi mau tai khoan, region va dich vu hien thi"
date: 2026-03-26
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---

{{% notice info %}}
Bản dịch tiếng Việt phục vụ mục đích học tập. Bài gốc: "Customize your AWS Management Console experience with visual settings including account color, region and service visibility" by Channy Yun, 26 MAR 2026 — https://aws.amazon.com/blogs/aws/customize-your-aws-management-console-experience-with-visual-settings-including-account-color-region-and-service-visibility/
{{% /notice %}}

# Tuy chinh AWS Management Console voi mau tai khoan, region va dich vu hien thi

Tac gia goc: [Channy Yun (윤석찬)](https://aws.amazon.com/blogs/aws/author/channy-yun/) | Ngay dang: 26 MAR 2026

Vào tháng 8/2025, AWS đã giới thiệu khả năng [AWS User Experience Customization (UXC)](https://docs.aws.amazon.com/awsconsolehelpdocs/latest/gsg/getting-started-uxc.html), cho phép tùy chỉnh giao diện người dùng (UI) theo nhu cầu cụ thể để hoàn thành công việc hiệu quả hơn. Với khả năng này, quản trị viên tài khoản có thể tùy chỉnh một số thành phần giao diện của [AWS Management Console](https://console.aws.amazon.com/), ví dụ như [gán màu cho tài khoản AWS](https://aws.amazon.com/about-aws/whats-new/2025/08/aws-management-console-assigning-color-aws-account/) để dễ nhận diện.

Hôm nay, AWS công bố thêm khả năng tùy chỉnh trong UXC, cho phép hiển thị chọn lọc các AWS Region và dịch vụ phù hợp cho từng thành viên trong nhóm. Bằng cách ẩn các Region và dịch vụ không dùng, bạn có thể giảm tải nhận thức, giảm thao tác thừa khi nhấp và cuộn, từ đó tập trung tốt hơn và làm việc nhanh hơn. Với lần ra mắt này, bạn có thể tùy chỉnh đồng thời màu tài khoản, Region, và khả năng hiển thị dịch vụ.

## Phân loại tài khoản bằng màu

Bạn có thể đặt màu cho từng tài khoản để phân biệt trực quan. Để bắt đầu, đăng nhập [AWS Management Console](https://console.aws.amazon.com/) và chọn tên tài khoản trên thanh điều hướng. Nếu tài khoản chưa có màu, hãy chọn **Account** để thiết lập.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/18/2026-aws-uxc-1-change-color-1.png)

Trong **Account display settings**, chọn màu tài khoản mong muốn rồi bấm **Update**. Sau đó bạn sẽ thấy màu đã chọn xuất hiện trên thanh điều hướng.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/18/2026-aws-uxc-1-change-color-setting.png)

Việc thay đổi màu tài khoản giúp bạn phân biệt mục đích của từng môi trường rõ ràng hơn. Ví dụ: dùng màu cam cho tài khoản development, xanh nhạt cho test, và đỏ cho production.

## Tùy chỉnh hiển thị Region và dịch vụ

Bạn có thể kiểm soát những AWS Region nào xuất hiện trong bộ chọn Region hoặc những dịch vụ nào xuất hiện trong điều hướng console. Nói cách khác, bạn có thể cấu hình để chỉ hiển thị Region và dịch vụ liên quan đến tài khoản của mình.

Để bắt đầu, chọn biểu tượng bánh răng trên thanh điều hướng rồi chọn **See all user settings**. Nếu bạn đang dùng vai trò quản trị viên, bạn sẽ thấy tab mới **Account settings** trong phần thiết lập hợp nhất. Nếu chưa cấu hình gì, tất cả Region và dịch vụ đều hiển thị.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/18/2026-aws-uxc-2-visible-setting-1.png)

Để đặt Region hiển thị, chọn **Edit** trong phần **Visible Regions**. Chọn **All available Regions** hoặc **Select Regions** rồi cấu hình danh sách của bạn. Sau đó chọn **Save changes**.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/18/2026-aws-uxc-2-visible-setting-1-Regions.png)

Sau khi cấu hình, bạn sẽ chỉ thấy các Region đã chọn trong bộ chọn Region trên thanh điều hướng.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/18/2026-aws-uxc-3-Regions.png)

Bạn cũng có thể cấu hình dịch vụ hiển thị theo cách tương tự. Tìm kiếm hoặc chọn dịch vụ theo nhóm. Trong ví dụ, tác giả dùng nhóm **Popular services** để chọn các dịch vụ hay dùng. Khi hoàn tất, chọn **Save changes**.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/18/2026-aws-uxc-2-visible-setting-2-Services.png)

Sau khi cấu hình, bạn sẽ chỉ thấy các dịch vụ đã chọn trong menu **All services** trên thanh điều hướng.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/18/2026-aws-uxc-4-Services.png)

Khi tìm kiếm tên dịch vụ trong ô search, bạn cũng chỉ có thể chọn các dịch vụ đã cấu hình hiển thị.

![](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2026/03/18/2026-aws-uxc-4-Services-search.png)

Lưu ý: thiết lập hiển thị Region và dịch vụ chỉ ảnh hưởng đến giao diện console. Thiết lập này không giới hạn quyền truy cập qua [AWS Command Line Interface (AWS CLI)](https://aws.amazon.com/cli/), [AWS SDKs](https://builder.aws.com/build/tools), AWS APIs, hoặc [Amazon Q Developer](https://aws.amazon.com/q/developer/).

Bạn cũng có thể quản lý các thiết lập tùy chỉnh này theo lập trình với hai tham số mới `visibleServices` và `visibleRegions`. Ví dụ, bạn có thể dùng mẫu [AWS CloudFormation](https://aws.amazon.com/cloudformation/) sau:

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: Customize AWS Console appearance for this account

Resources:
  AccountCustomization:
    Type: AWS::UXC::AccountCustomization
    Properties:
      AccountColor: red
      VisibleServices:
        - s3
        - ec2
        - lambda
      VisibleRegions:
        - us-east-1
        - us-west-2
```

Bạn có thể triển khai template CloudFormation bằng lệnh:

```bash
$ aws cloudformation deploy \
  --template-file account-customization.yaml \
  --stack-name my-account-customization
```

Để tìm hiểu thêm, xem [AWS User Experience Customization API Reference](https://docs.aws.amazon.com/awsconsolehelpdocs/latest/APIReference/Welcome.html) và [AWS CloudFormation template reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-uxc-accountcustomization.html).

Hãy thử ngay trong [AWS Management Console](https://console.aws.amazon.com/) và gửi phản hồi bằng cách chọn liên kết **Feedback** ở cuối trang console, đăng lên [AWS re:Post forum for the AWS Management Console](https://repost.aws/tags/TAnTglnGsnR_CdJMgsyCH_uA/aws-management-console), hoặc liên hệ AWS Support như thường lệ.

- [Channy](https://linkedin.com/in/channy/)
