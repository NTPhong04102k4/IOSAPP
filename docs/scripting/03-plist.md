# 03 — Property List (`.plist`)

`.plist` (Property List) là file **cấu hình dạng XML** của Apple. Trong iOS/macOS dùng để
lưu cài đặt dạng key–value. Quen thuộc nhất là **`Info.plist`** (mô tả app) và file
**entitlements** (quyền của app).

## Cấu trúc file

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>AppIos</string>

    <key>CFBundleShortVersionString</key>
    <string>1.0</string>

    <key>UILaunchScreen</key>
    <dict/>
</dict>
</plist>
```

Mọi thứ nằm trong 1 `<dict>` gốc: cứ **1 `<key>` đi kèm 1 giá trị** ngay bên dưới.

## Các kiểu dữ liệu

| Kiểu | Tag XML | Ví dụ |
|------|---------|-------|
| Chuỗi | `<string>` | `<string>AppIos</string>` |
| Số nguyên | `<integer>` | `<integer>15</integer>` |
| Boolean | `<true/>` / `<false/>` | `<true/>` |
| Mảng | `<array>` | danh sách các phần tử |
| Từ điển | `<dict>` | lồng key–value bên trong |

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>appios</string>
        </array>
    </dict>
</array>
```

## Vài key quan trọng trong `Info.plist`

| Key | Ý nghĩa |
|-----|---------|
| `CFBundleDisplayName` | Tên app hiển thị dưới icon |
| `CFBundleShortVersionString` | Version cho người dùng (vd `1.0`) |
| `CFBundleVersion` | Số build nội bộ |
| `NSCameraUsageDescription` | Lý do xin quyền camera (bắt buộc nếu dùng camera) |

> 💡 Từ Xcode mới, nhiều thiết lập `Info.plist` được sinh tự động trong tab **Build Settings /
> Info** của target — bạn có thể không thấy file `Info.plist` riêng. Chỉ tạo file thủ công khi cần key đặc biệt.

## Chỉnh sửa & kiểm tra

```bash
# Kiểm tra cú pháp file plist có hợp lệ không
plutil -lint Info.plist

# Đọc 1 giá trị
/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" Info.plist

# Đổi 1 giá trị
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString 1.1" Info.plist

# Chuyển đổi định dạng (xml <-> binary)
plutil -convert xml1 Info.plist
```

## Pitfalls (lỗi thường gặp)

1. **Sai cặp key–value** — mỗi `<key>` phải có đúng 1 giá trị ngay sau. Thiếu/thừa → app crash hoặc build fail.
2. **Quên khai báo Usage Description** — dùng camera/mic/vị trí mà thiếu key `NS...UsageDescription` → app **bị từ chối** hoặc crash khi xin quyền.
3. **Sửa tay dễ hỏng XML** — nên dùng Xcode hoặc `PlistBuddy`/`plutil` thay vì gõ tay.
4. **Nhầm boolean** — dùng `<true/>` (tag rỗng), KHÔNG phải `<string>true</string>`.
