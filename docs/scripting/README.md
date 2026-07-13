# Scripting & Build files — cách viết các loại file tự động hóa

Phần này dạy cách **viết** các file thường gặp khi build/tự động hóa dự án:
Makefile, shell script (`.sh`), Property List (`.plist`), PowerShell (`.ps1`), batch (`.cmd`).

> Bối cảnh: project `AppIos` chạy trên **macOS** (Xcode). Nên `Makefile`, `.sh`, `.plist`
> là thứ bạn dùng **thực tế**. Còn `.ps1` và `.cmd` là của **Windows** — đưa vào đây để
> hiểu khi làm việc đa nền tảng (CI, script cho đồng nghiệp dùng Windows).

## Mục lục

| # | File | Nền tảng | Dùng để làm gì |
|---|------|----------|----------------|
| 01 | [Makefile](01-makefile.md) | macOS/Linux | Gom các lệnh dài thành "target" ngắn (`make build`, `make test`) |
| 02 | [Shell `.sh`](02-shell-sh.md) | macOS/Linux | Script tự động hóa (bootstrap, build, dọn dẹp) |
| 03 | [Property List `.plist`](03-plist.md) | Apple | File cấu hình XML (Info.plist, entitlements) |
| 04 | [PowerShell `.ps1`](04-powershell-ps1.md) | Windows | Script tự động hóa hiện đại trên Windows |
| 05 | [Batch `.cmd`](05-batch-cmd.md) | Windows | Script batch cũ trên Windows |

## Nhanh: file nào cho việc gì?

| Bạn muốn... | Dùng |
|-------------|------|
| Gõ 1 lệnh ngắn thay cho lệnh `xcodebuild` dài | **Makefile** |
| Chạy 1 chuỗi lệnh setup dự án trên máy Mac | **`.sh`** |
| Chỉnh cấu hình app iOS (tên, quyền, version) | **`.plist`** |
| Tự động hóa trên máy Windows (mới) | **`.ps1`** |
| Tự động hóa trên máy Windows (cũ/đơn giản) | **`.cmd`** |

## Nguyên tắc chung cho mọi script

1. **Có tính idempotent**: chạy lại nhiều lần vẫn an toàn (kiểm tra trước khi tạo/xóa).
2. **Fail nhanh, rõ ràng**: lỗi thì dừng ngay và in thông báo dễ hiểu.
3. **Không hardcode đường dẫn tuyệt đối** của riêng máy bạn (`/Users/ten-ban/...`).
4. **Comment ngắn** ở đầu file: script này làm gì, chạy sao.
