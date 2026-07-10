# Swift Language — Tutorial đầy đủ

Phần này dạy **ngôn ngữ Swift** (nền tảng), tách khỏi phần SwiftUI (giao diện) ở thư mục `docs/`.
Học xong phần này bạn sẽ đọc/hiểu mọi code Swift trong project.

> Cách chạy thử: mở Xcode → **File › New › Playground** (chọn Blank) → dán code vào chạy.
> Hoặc dùng lệnh `swift` trong Terminal với file `.swift`.

## Lộ trình học

| # | Chủ đề | Nội dung |
|---|--------|----------|
| 01 | [Cơ bản](01-basics.md) | Biến/hằng, kiểu dữ liệu, **tuple**, **typealias**, string, toán tử |
| 02 | [Optional](02-optionals.md) | `?`, `!`, `if let`, `guard let`, `??`, optional chaining |
| 03 | [Collections](03-collections.md) | **Array (List)**, **Set**, **Dictionary (Map)** + thao tác |
| 04 | [Functions](04-functions.md) | Tham số, nhãn, giá trị mặc định, variadic, `inout`, trả nhiều giá trị |
| 05 | [Closures](05-closures.md) | Closure, trailing, capture, `@escaping`, higher-order (map/filter/reduce) |
| 06 | [Enum & Pattern Matching](06-enums-pattern.md) | Enum, associated/raw values, `switch`, `where`, binding |
| 07 | [Struct, Class & Protocol](07-struct-class-protocol.md) | Kiến trúc: value vs reference, property, protocol, extension, generic |
| 08 | [Concurrency](08-concurrency.md) | **Thread**, **process**, GCD, `async/await`, `Task`, `actor`, `@MainActor` |

## Bản đồ nhanh: Swift ↔ khái niệm quen thuộc

| Khái niệm | Swift gọi là | File |
|-----------|-------------|------|
| List / mảng | `Array` | 03 |
| Map / từ điển | `Dictionary` | 03 |
| Set / tập hợp | `Set` | 03 |
| Hàm | `func` | 04 |
| Lambda / hàm ẩn danh | `closure` | 05 |
| Null / rỗng | `Optional` (`nil`) | 02 |
| Bộ giá trị ghép | `tuple` | 01 |
| Đặt tên kiểu khác | `typealias` | 01 |
| Luồng / bất đồng bộ | `async/await`, `Task`, GCD | 08 |

## Nguyên tắc Swift cần nhớ ngay

1. **An toàn kiểu (type-safe)**: mọi biến có kiểu rõ ràng; Swift tự suy luận nếu gán ngay.
2. **`let` vs `var`**: `let` = hằng (không đổi), `var` = biến. Ưu tiên `let` mặc định.
3. **Optional**: Swift không có "null bừa bãi"; giá trị có thể rỗng phải khai báo `?` → buộc bạn xử lý nil.
4. **Value type là mặc định**: `struct`, `enum`, mọi collection đều copy khi gán (khác `class`).
