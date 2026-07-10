# 04 — Image, SF Symbols, AsyncImage

Hiển thị hình ảnh: từ **SF Symbols** (icon hệ thống), **Assets** (ảnh trong app),
và **AsyncImage** (tải ảnh từ URL).

## SF Symbols — icon miễn phí của Apple

```swift
Image(systemName: "heart.fill")
    .font(.largeTitle)          // đổi kích thước icon bằng font
    .foregroundColor(.red)
```

- Có hàng nghìn icon. Tải app **SF Symbols** (miễn phí) từ Apple để tra tên.
- Ví dụ tên hay dùng: `person`, `house.fill`, `gear`, `magnifyingglass`, `trash`, `star.fill`, `arrow.right`.

Đổi kích thước & màu nhiều lớp (symbol màu):

```swift
Image(systemName: "cloud.sun.fill")
    .symbolRenderingMode(.multicolor)
    .font(.system(size: 48))
```

## Ảnh từ Assets Catalog

Kéo ảnh vào `Assets.xcassets`, đặt tên (ví dụ `logo`), rồi:

```swift
Image("logo")               // KHÔNG có systemName = ảnh trong Assets
    .resizable()            // BẮT BUỘC nếu muốn đổi kích thước
    .scaledToFit()          // giữ tỉ lệ, vừa khung
    .frame(width: 120, height: 120)
```

> ⚠️ Ảnh thật **phải** có `.resizable()` trước khi set `.frame`, nếu không nó
> giữ nguyên kích thước gốc.

## Các chế độ scale

```swift
.scaledToFit()    // vừa khung, giữ tỉ lệ, có thể để trống 2 bên
.scaledToFill()   // lấp đầy khung, giữ tỉ lệ, có thể bị cắt
```

Khi dùng `.scaledToFill()` nên kèm `.clipped()` để cắt phần thừa:

```swift
Image("banner")
    .resizable()
    .scaledToFill()
    .frame(width: 300, height: 150)
    .clipped()
    .cornerRadius(12)
```

## Ảnh tròn (avatar)

```swift
Image("avatar")
    .resizable()
    .scaledToFill()
    .frame(width: 80, height: 80)
    .clipShape(Circle())
    .overlay(Circle().stroke(.white, lineWidth: 2))
    .shadow(radius: 4)
```

## AsyncImage — tải ảnh từ Internet (iOS 15+)

```swift
AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
    image
        .resizable()
        .scaledToFit()
} placeholder: {
    ProgressView()          // vòng xoay trong lúc tải
}
.frame(width: 200, height: 200)
```

Xử lý đủ trạng thái (loading / thành công / lỗi):

```swift
AsyncImage(url: URL(string: urlString)) { phase in
    switch phase {
    case .empty:
        ProgressView()
    case .success(let image):
        image.resizable().scaledToFit()
    case .failure:
        Image(systemName: "photo")   // icon thay thế khi lỗi
            .foregroundColor(.gray)
    @unknown default:
        EmptyView()
    }
}
```

## Ví dụ: Card hồ sơ

```swift
import SwiftUI

struct ImageDemo: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)

            Text("Nguyễn Văn A")
                .font(.title2).fontWeight(.bold)

            HStack(spacing: 4) {
                Image(systemName: "star.fill").foregroundColor(.yellow)
                Text("4.8 · 120 đánh giá")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    ImageDemo()
}
```

## Ghi nhớ

- `Image(systemName:)` = icon hệ thống · `Image("tên")` = ảnh trong Assets.
- Icon đổi size bằng `.font()`; ảnh thật đổi size bằng `.resizable()` + `.frame()`.
- `AsyncImage` cần iOS 15+ và luôn nên có `placeholder`.
