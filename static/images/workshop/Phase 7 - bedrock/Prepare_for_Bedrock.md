

### **TÀI LIỆU HƯỚNG DẪN: THIẾT LẬP VÀ CẤU HÌNH AMAZON BEDROCK API**

**Mục đích:**

Hướng dẫn quy trình chi tiết để khởi tạo API Key, trích xuất Model ID từ Amazon Bedrock và cấu hình các biến môi trường cần thiết vào file .env của hệ thống backend.

#### **Phần 1: Khởi tạo Khóa xác thực (Long-term API Key)**

Quá trình này giúp tạo ra thông tin xác thực để mã nguồn có quyền gọi các API của dịch vụ Amazon Bedrock.

1. **Truy cập quản lý API Keys:** \* Đăng nhập vào AWS Management Console và điều hướng đến dịch vụ **Amazon Bedrock**.  
   * Tại thanh menu bên trái (mục *Discover*), nhấn chọn **API keys**.  
2. **Bắt đầu tạo khóa mới:** \* Trên màn hình quản lý, chuyển sang tab **Long-term API keys**.  
   * Nhấn vào nút **Generate long-term API keys** (màu cam) ở góc phải màn hình.  
3. **Cấu hình thời hạn bảo mật:** \* Tại giao diện *Generate long-term API key*, điền số ngày mong muốn vào trường **Specify API key expiry in days**. Việc giới hạn thời gian tồn tại của khóa giúp tăng cường tính bảo mật cho hệ thống.  
4. **Hoàn tất và lưu trữ khóa:** \* Cuộn xuống cuối trang và nhấn nút **Generate**.  
   * **Lưu ý quan trọng:** Ngay sau khi khóa được tạo, anh yêu cần sao chép chuỗi API Key này (thường bắt đầu bằng tiền tố ABSK...) và lưu tạm vào một nơi bảo mật để sử dụng cho bước cấu hình môi trường phía dưới.

#### **Phần 2: Trích xuất Mã định danh Mô hình (Model ID)**

Bước này nhằm xác định chính xác phiên bản mô hình AI (Large Language Model) nào sẽ được hệ thống gọi đến để xử lý dữ liệu.

5. **Truy cập danh mục mô hình:** \* Quay lại thanh menu bên trái của Amazon Bedrock, nhấn chọn **Model catalog**.  
   * Tìm kiếm và chọn mô hình phù hợp với nhu cầu xử lý của hệ thống (Ví dụ theo hình ảnh: chọn **Claude 3.5 Haiku** từ nhà cung cấp Anthropic).  
6. **Sao chép Model ID:** \* Tại trang chi tiết thông số của mô hình vừa chọn, cuộn xuống bảng thông tin cơ bản.  
   * Tìm dòng **Model ID** và sao chép toàn bộ chuỗi định danh (Ví dụ: anthropic.claude-3-5-haiku-20241022-v1:0).

#### **Phần 3: Tích hợp vào hệ thống mã nguồn Backend**

Bước cuối cùng để kết nối dịch vụ AWS với hệ thống mã nguồn cục bộ hoặc máy chủ triển khai.

7. **Mở tệp tin cấu hình:** \* Trên trình soạn thảo mã nguồn (IDE), mở thư mục gốc của dự án API.  
   * Tìm và mở file cấu hình môi trường .env.  
8. **Cập nhật các biến môi trường:** \* **BEDROCK\_API\_KEY:** Dán chuỗi khóa xác thực đã sao chép ở **Bước 4** vào biến này (Ví dụ: BEDROCK\_API\_KEY=ABSK...).  
   * **BEDROCK\_MODEL:** Dán chuỗi định danh mô hình đã sao chép ở **Bước 6** vào biến này.  
   * **Kiểm tra các thông số liên quan:** Đảm bảo các thông số thiết lập hạ tầng khác đã chính xác, bao gồm:  
     * BEDROCK\_REGION (ví dụ: ap-southeast-1)  
     * BEDROCK\_TEMPERATURE (mức độ sáng tạo của mô hình)  
     * BEDROCK\_MAX\_TOKENS (giới hạn độ dài văn bản trả về)  
     * Các cấu hình kết nối Database và S3 bucket nếu có thay đổi.

