# Report 1 page - Lab 4 DES / TripleDES

## Mục tiêu

Mục tiêu của bài lab là hoàn thiện chương trình DES từ code khởi tạo để hỗ trợ đầy đủ luồng nhập từ bàn phím theo contract của môn học, bao gồm mã hóa/giải mã DES và TripleDES. Ngoài ra, chương trình cần xử lý nhiều block với zero padding, và xuất kết quả cuối cùng dưới dạng chuỗi bit để CI có thể auto-check.

## Cách làm / Method

Em giữ lại lõi DES (key schedule, IP/IP-1, Feistel rounds, S-box) và tái cấu trúc theo hướng hàm hóa:
- Bổ sung kiểm tra input nhị phân và độ dài key.
- Tách hàm DES block-level để dùng chung cho encrypt/decrypt bằng cách đảo thứ tự round keys.
- Thêm xử lý multi-block cho mode DES bằng cách chia block 64-bit và zero padding block cuối.
- Cài đặt TripleDES theo chuỗi EDE: `E(K3, D(K2, E(K1, P)))`, và giải mã ngược lại.
- Cập nhật `main()` để đọc mode 1/2/3/4 từ stdin đúng thứ tự dữ liệu yêu cầu.

Sau phần code, em hoàn thiện README, report, và viết đủ 5 test shell gồm sample DES, round-trip, multi-block padding, tamper negative, wrong key negative.

## Kết quả / Result

Kết quả chính:
- DES encrypt với plaintext/key mẫu cho ra ciphertext:
  `0111111010111111010001001001001100100011111110101111101011111000`
- DES hỗ trợ plaintext dài hơn 64 bit và mã hóa nhiều block đúng với zero padding.
- TripleDES encrypt/decrypt pass theo vector kiểm thử của repo.
- Round-trip DES thỏa mãn: decrypt(encrypt(plaintext)) trả về plaintext đã pad.
- Negative test tamper và wrong key đều cho kết quả plaintext khác bản gốc như kỳ vọng.

Các minh chứng chạy đã được lưu trong thư mục `logs/`.

## Kết luận / Conclusion

Qua bài này em nắm được rõ cấu trúc Feistel của DES, vai trò của key schedule, và cách mở rộng sang TripleDES EDE. Em cũng học cách thiết kế chương trình theo contract input/output để tự động kiểm thử CI.

Hạn chế hiện tại: chương trình dùng zero padding đơn giản nên chưa phù hợp cho ứng dụng thực tế; chưa có chế độ mã khối như CBC/CTR; dữ liệu đang xử lý ở dạng bit-string thủ công. Hướng mở rộng là thêm padding chuẩn (PKCS#7 cho byte-oriented data), hỗ trợ đọc/ghi file, và bổ sung kiểm tra toàn vẹn dữ liệu.
