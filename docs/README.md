# Tài liệu học Swift & SwiftUI

Bộ tài liệu học cho project `AppIos`, chia làm 2 phần:

1. **[Swift Language](swift/README.md)** — học *ngôn ngữ* Swift (collections, optional, closure, enum, concurrency...). **Nên học phần này trước.**
2. **SwiftUI Components** (bên dưới) — học *giao diện*: Text, Button, TextField, List...
3. **[Scripting & Build files](scripting/README.md)** — cách viết `Makefile`, `.sh`, `.plist`, `.ps1`, `.cmd`.

> Yêu cầu: iOS 15+ (project đang dùng Swift 5.0). Ví dụ Swift chạy trong **Playground**;
> ví dụ SwiftUI đặt trong `struct ... : View` và xem bằng `#Preview { ... }` trong Xcode.

---

## Phần A — Swift Language (nền tảng)

Xem chi tiết tại **[swift/README.md](swift/README.md)**.

| # | Chủ đề | Nội dung |
|---|--------|----------|
| 01 | [Cơ bản](swift/01-basics.md) | Biến/hằng, kiểu, **tuple**, **typealias**, string |
| 02 | [Optional](swift/02-optionals.md) | `?` `!` `if let` `guard let` `??` optional chaining |
| 03 | [Collections](swift/03-collections.md) | **Array (List)**, **Set**, **Dictionary (Map)** |
| 04 | [Functions](swift/04-functions.md) | Tham số, label, default, variadic, `inout`, `throws` |
| 05 | [Closures](swift/05-closures.md) | Closure, trailing, `map`/`filter`/`reduce`, `@escaping` |
| 06 | [Enum & Pattern](swift/06-enums-pattern.md) | Enum, associated value, `switch`, `where` |
| 07 | [Struct/Class/Protocol](swift/07-struct-class-protocol.md) | Kiến trúc: value vs reference, protocol, generic |
| 08 | [Concurrency](swift/08-concurrency.md) | **Thread**, **process**, `async/await`, `actor`, GCD |

---

## Phần B — SwiftUI Components (giao diện)

## Mục lục

| # | Chủ đề | Component chính |
|---|--------|-----------------|
| 00 | [iOS nền tảng](00-ios-nen-tang.md) | **UIKit vs SwiftUI**, **AppDelegate** vs `App` lifecycle, `ObservableObject` (bối cảnh — nên đọc trước) |
| 01 | [Text](01-text.md) | `Text` — hiển thị chữ, định dạng, style |
| 02 | [Button](02-button.md) | `Button` — nút bấm, action, style |
| 03 | [TextField](03-textfield.md) | `TextField`, `SecureField`, `TextEditor` — nhập liệu |
| 04 | [Image](04-image.md) | `Image`, SF Symbols, `AsyncImage` |
| 05 | [Stacks & Layout](05-stacks.md) | `VStack`, `HStack`, `ZStack`, `Spacer`, `padding` |
| 06 | [List & ForEach](06-list.md) | `List`, `ForEach`, `Section`, navigation |
| 07 | [Form Controls](07-form-controls.md) | `Toggle`, `Picker`, `Slider`, `Stepper`, `DatePicker` |
| 08 | [State & Binding](08-state-binding.md) | `@State`, `@Binding`, `@ObservedObject`, `$` |

---

## Phần C — Scripting & Build files (tự động hóa)

Xem chi tiết tại **[scripting/README.md](scripting/README.md)**.

| # | File | Nền tảng | Dùng để làm gì |
|---|------|----------|----------------|
| 01 | [Makefile](scripting/01-makefile.md) | macOS/Linux | Gom lệnh dài thành target ngắn (`make build`) |
| 02 | [Shell `.sh`](scripting/02-shell-sh.md) | macOS/Linux | Script tự động hóa (bootstrap, build) |
| 03 | [`.plist`](scripting/03-plist.md) | Apple | Cấu hình XML (Info.plist, entitlements) |
| 04 | [PowerShell `.ps1`](scripting/04-powershell-ps1.md) | Windows | Script tự động hóa hiện đại |
| 05 | [Batch `.cmd`](scripting/05-batch-cmd.md) | Windows | Script batch cũ |

---

## Cách học hiệu quả

1. Đọc từng file theo thứ tự (00 → 08).
2. Copy đoạn code vào 1 file `.swift` mới trong Xcode.
3. Bấm **Resume** ở khung Preview bên phải để xem kết quả.
4. Đổi thử tham số (màu, size, text...) để hiểu cách chúng ảnh hưởng UI.

## Khái niệm cốt lõi cần nhớ

- **View** là 1 `struct` tuân theo protocol `View`, bắt buộc có thuộc tính `body`.
- **Modifier** (ví dụ `.foregroundColor()`, `.padding()`) trả về 1 View mới → nối chuỗi được.
- **Thứ tự modifier quan trọng**: `.padding().background(.blue)` khác `.background(.blue).padding()`.
- SwiftUI là **declarative**: bạn mô tả UI *nên trông thế nào* theo state, không thao tác trực tiếp.
