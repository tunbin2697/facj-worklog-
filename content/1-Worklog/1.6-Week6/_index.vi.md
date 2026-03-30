---
title: "Worklog Tuần 6"
date: 2026-02-09
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

### Mục tiêu tuần 6:

* **Backend**: Xây dựng module `UserWorkoutSession` và `WorkoutLog` để ghi lại hoạt động tập luyện thực tế.
* **Frontend**: Xây dựng `PlanDetailScreen` và `WorkoutSessionScreen` — trải nghiệm tập luyện trực tiếp.
* Hoàn thiện vòng lặp chính: kế hoạch → buổi tập → log set → kết thúc.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --------- | ------------ | --------------- | -------------- |
| 2   | - Xây dựng **UserWorkoutSession** entity <br>&emsp; + `user`, `userWorkoutPlan (@ManyToOne)`, `workoutDate (LocalDate)`, `isActive`, `weekIndex`, `dayIndex` <br>&emsp; + Cascade to `WorkoutLog` qua `@OneToMany(cascade = ALL)` | 10/02/2026 | 10/02/2026 | |
| 3   | - Xây dựng **WorkoutLog** entity <br>&emsp; + `userWorkoutSession`, `exercise`, `setNumber`, `reps`, `weight (Float)`, `durationSeconds` <br> - Xây dựng **UserWorkoutSessionController** (`/api/sessions`) <br>&emsp; + Create, Get by ID/user/date, Get active, Deactivate, Add log | 11/02/2026 | 11/02/2026 | |
| 4   | - Xây dựng **PlanDetailScreen** (Frontend) <br>&emsp; + Hiển thị kế hoạch active, bộ chọn ngày Thứ 2–CN <br>&emsp; + Nút "Bắt đầu tập": tạo session → chuyển đến `WorkoutSessionScreen` <br>&emsp; + Banner session đang tiến hành nếu có <br>&emsp; + Link đến `SessionCalendar` để xem lịch sử | 12/02/2026 | 12/02/2026 | |
| 5   | - Xây dựng **workoutSessionSlice** (Redux) <br>&emsp; + State: `sessionId`, `exercises[]`, `currentExIndex`, `currentSet`, `completedSets[]`, `phase`, `restSeconds` <br>&emsp; + Actions: `initializeSession`, `logSetStart/Success/Failure`, `finishRest`, `skipExercise`, `resetSession` <br>&emsp; + Lưu session vào `AsyncStorage` — khôi phục khi app reload | 13/02/2026 | 13/02/2026 | |
| 6   | - Xây dựng **WorkoutSessionScreen** (Frontend) <br>&emsp; + `ActiveExerciseCard`: hiển thị tên bài tập, tiến độ set, mục tiêu rep <br>&emsp; + `LogSetSheet`: nhập rep + cân nặng → gọi `addWorkoutLog` API <br>&emsp; + `RestTimer`: đếm ngược, tự chuyển bài tập sau khi nghỉ <br> - Xây dựng **WorkoutSuccessScreen** <br>&emsp; + Trophy screen với tóm tắt buổi tập <br>&emsp; + Chặn nút back phần cứng | 14/02/2026 | 14/02/2026 | |

### Kết quả đạt được tuần 6:

* **Backend — Module Session**:
  * Entity `UserWorkoutSession` + `WorkoutLog` lưu thành công với cascade DELETE.
  * API tạo session, deactivate và log set hoạt động đúng.
  * Query theo ngày và lấy active session hoạt động chính xác.
* **Frontend — Tập Thực Tế**:
  * `PlanDetailScreen` load kế hoạch active; bộ chọn ngày lọc bài tập theo `dayOfWeek`.
  * Redux `workoutSessionSlice` quản lý toàn bộ trạng thái buổi tập, lưu AsyncStorage.
  * `WorkoutSessionScreen` hướng dẫn user qua tất cả bài tập/set với timer nghỉ.
  * Vòng lặp tập luyện hoàn chỉnh được test end-to-end.

### Nhật ký lab AWS cá nhân (học độc lập):

**Tự học — Luồng xác thực Cognito (từ đầu đến cuối)**

Tuần này tôi ghi chép luồng OAuth2 Cognito đầy đủ để hỗ trợ việc tích hợp Cognito của cả nhóm:

* **Bước 1 — Người dùng đăng nhập**: Frontend chuyển hướng đến Cognito Hosted UI qua OAuth2 authorize endpoint. Cognito hiển thị trang đăng nhập và xác minh username/password trực tiếp (backend không bao giờ thấy mật khẩu).

* **Bước 2 — Trả về Authorization Code**: Sau khi đăng nhập thành công, Cognito redirect về app kèm `code` ngắn hạn (~1 phút), đây chưa phải là token.

* **Bước 3 — Đổi Code lấy Token**: Frontend gọi `POST /oauth2/token` với `grant_type=authorization_code`, Cognito trả về `access_token`, `id_token`, `refresh_token`, `expires_in`.

* **Loại token và vai trò**:
  * **access_token**: Gửi lên backend qua header `Authorization: Bearer`. Backend xác thực token này.
  * **id_token**: Chứa thông tin danh tính người dùng (`sub`, `email`, `name`). Frontend dùng biết ai đang đăng nhập. KHÔNG gửi lên backend để authorize.
  * **refresh_token**: Dùng lấy access_token mới khi hết hạn mà không yêu cầu đăng nhập lại.

* **Backend xác minh token Cognito (RS256 / JWKS)**:
  * Cognito ký token bằng **private key** (chỉ Cognito có).
  * Cognito công khai **public key** tại: `https://cognito-idp.<region>.amazonaws.com/<userPoolId>/.well-known/jwks.json`
  * Spring Boot tự động tải public key và xác minh chữ ký cho mọi request.
  * Cổng hóa trong Spring: `spring.security.oauth2.resourceserver.jwt.issuer-uri=https://cognito-idp.<region>.amazonaws.com/<userPoolId>`
  * Spring kiểm tra: chữ ký, hạn sử dụng (exp), issuer, audience.

* **Tại sao RS256 an toàn hơn HS256**:
  * HS256: Mọi dịch vụ xác minh token đều phải biết chung 1 secret. Nếu 1 service bị lộ key, kẻ tấn công có thể giả mạo token.
  * RS256: Chỉ Cognito có private key. Backend chỉ có public key và KHHNG TạO được token dù bị xâm nhập.

* **Giới hạn và cách giảm thiểu**:
  * JWT stateless — thu hồi access token ngay lập tức không khả thi. Nếu user logout hoặc tài khoản bị vô hiệu hóa, access token vẫn còn hiệu lực đến khi hết hạn (thường 1 tiếng). Giải pháp: access token ngắn hạn + thu hồi refresh token khi logout.
  * Token bị đánh cắp vẫn dùng được đến khi hết hạn. Giảm thiểu: chỉ dùng HTTPS, thời hạn ngắn, HttpOnly cookie trên web, chống XSS.

* Đào sâu toàn bộ luồng Cognito: authorize, đổi code lấy token, refresh token, và revoke khi logout.
* Phân định rõ vai trò token trong hệ thống thật: access token cho API backend, ID token cho thông tin danh tính, refresh token cho duy trì phiên.
* Củng cố mô hình validate JWT với Spring Security theo issuer/JWKS và kiểm tra claim nghiêm ngặt.
* Làm rõ mô hình trust bằng asymmetric key: Cognito ký bằng private key, backend verify bằng public key.
* Ghi chú các điểm dễ nhầm và biện pháp giảm rủi ro về hết hạn token, giới hạn revoke, và nguy cơ token bị lộ.

### Tóm tắt kiến thức AWS (rút ra từ nhật ký lab):

* Hệ thống hóa đầy đủ luồng OAuth2 Authorization Code + PKCE của Cognito cho client mobile/web.
* Phân tách chuẩn vai trò token: Access Token cho authorize API, ID Token cho danh tính, Refresh Token cho duy trì phiên.
* Nắm ranh giới tin cậy RS256: Cognito ký bằng private key, dịch vụ xác minh bằng public key từ JWKS.
* Nhận diện giới hạn revoke của JWT stateless và áp dụng giảm thiểu bằng access token ngắn hạn cùng revoke refresh token.
* Củng cố thực hành bảo mật token ở lớp truyền tải và lưu trữ để giảm rủi ro bị đánh cắp phiên.

### Kế hoạch tuần tiếp theo:

* **Backend**: Xây dựng module Media — entity `Image`, tích hợp AWS S3, `ImageController` liên kết hình ảnh với bài tập/thực phẩm/kế hoạch.
* **Frontend**: Xây dựng `SessionDetailScreen` và `SessionCalendarScreen` (lịch tháng có chấm buổi tập).
