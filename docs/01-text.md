# 01 — Text

`Text` là component hiển thị chuỗi chữ (read-only). Đây là view đơn giản và hay dùng nhất.

## Cơ bản

```swift
Text("Xin chào SwiftUI")
```

## Định dạng font & kiểu chữ

```swift
Text("Tiêu đề lớn")
    .font(.largeTitle)        // .title, .headline, .body, .caption...
    .fontWeight(.bold)        // .light, .regular, .semibold, .bold
    .italic()
    .foregroundColor(.blue)   // màu chữ
```

Các cỡ font hệ thống (tự co giãn theo Dynamic Type):
`.largeTitle` › `.title` › `.title2` › `.title3` › `.headline` › `.body` › `.callout` › `.subheadline` › `.footnote` › `.caption` › `.caption2`

Font tùy chỉnh kích thước:

```swift
Text("Cỡ 24")
    .font(.system(size: 24, weight: .medium, design: .rounded))
```

## Nhiều dòng & căn lề

```swift
Text("Đây là một đoạn văn bản dài sẽ tự động xuống nhiều dòng khi không đủ chỗ.")
    .multilineTextAlignment(.center)  // .leading, .center, .trailing
    .lineLimit(2)                     // giới hạn tối đa 2 dòng
    .lineSpacing(6)                   // khoảng cách dòng
```

## Các modifier hay dùng

```swift
Text("Gạch & khoảng cách chữ")
    .underline()                 // gạch chân
    .strikethrough()             // gạch ngang
    .kerning(2)                  // giãn cách ký tự
    .textCase(.uppercase)        // IN HOA / .lowercase
    .lineLimit(1)
    .truncationMode(.tail)       // "văn bản dài..." khi bị cắt
```

## Nối nhiều Text (concatenation)

Có thể cộng các `Text` với style khác nhau bằng dấu `+`:

```swift
Text("Giá: ")
    .foregroundColor(.gray)
+ Text("100.000đ")
    .fontWeight(.bold)
    .foregroundColor(.red)
```

## Markdown (iOS 15+)

`Text` tự hiểu cú pháp Markdown cơ bản:

```swift
Text("Đây là **in đậm**, *in nghiêng*, và [một link](https://apple.com)")
```

## Ví dụ hoàn chỉnh (dán vào Xcode để xem Preview)

```swift
import SwiftUI

struct TextDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Card sản phẩm")
                .font(.title2)
                .fontWeight(.bold)

            Text("iPhone 16 Pro")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Mô tả ngắn về sản phẩm nằm ở đây, có thể dài nhiều dòng.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)

            Text("Còn hàng")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.green)
        }
        .padding()
    }
}

#Preview {
    TextDemo()
}
```

## Ghi nhớ

- `.foregroundColor(.primary)` / `.secondary` tự đổi màu theo Light/Dark mode → nên ưu tiên dùng.
- Đặt `.lineLimit(nil)` để cho phép không giới hạn dòng.
- Text luôn read-only. Muốn cho người dùng **nhập** chữ → xem [03-textfield.md](03-textfield.md).
