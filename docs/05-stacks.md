# 05 — Stacks & Layout

3 "khối xếp hình" cơ bản để bố cục UI: **VStack** (dọc), **HStack** (ngang), **ZStack** (chồng lên nhau).

## VStack — xếp dọc (trên xuống dưới)

```swift
VStack(alignment: .leading, spacing: 8) {
    Text("Dòng 1")
    Text("Dòng 2")
    Text("Dòng 3")
}
```

- `alignment`: `.leading` (canh trái), `.center` (mặc định), `.trailing` (canh phải).
- `spacing`: khoảng cách giữa các phần tử.

## HStack — xếp ngang (trái sang phải)

```swift
HStack(alignment: .center, spacing: 12) {
    Image(systemName: "star.fill")
    Text("Đánh giá")
    Text("4.8")
}
```

- `alignment` ở HStack là canh theo chiều dọc: `.top`, `.center`, `.bottom`.

## ZStack — chồng lớp (lớp sau đè lớp trước)

```swift
ZStack {
    Color.blue                       // lớp nền
    Text("Nổi trên nền")
        .foregroundColor(.white)
}
```

Dùng ZStack để đặt badge, overlay, nền gradient...

## Spacer — đẩy các phần tử ra xa

```swift
HStack {
    Text("Trái")
    Spacer()          // chiếm hết chỗ trống ở giữa
    Text("Phải")
}
```

`Spacer()` "nở" ra để đẩy nội dung về 2 phía. Rất hay dùng trong thanh toolbar/header.

## padding — khoảng đệm

```swift
Text("Có đệm")
    .padding()               // đệm đều 4 phía (mặc định ~16pt)
    .padding(.horizontal, 24) // chỉ đệm trái/phải
    .padding(.top, 8)         // chỉ đệm trên
```

## frame — kích thước & căn chỉnh

```swift
Text("Ô")
    .frame(width: 100, height: 50)
    .frame(maxWidth: .infinity)      // giãn hết chiều ngang có thể
    .frame(maxWidth: .infinity, alignment: .leading) // giãn + canh trái
```

## background, cornerRadius, shadow

```swift
Text("Thẻ")
    .padding()
    .background(Color.blue)      // đặt SAU padding để phủ cả vùng đệm
    .cornerRadius(12)
    .shadow(radius: 4)
```

> ⚠️ **Thứ tự quan trọng**: `.padding().background()` bọc màu ra ngoài vùng đệm.
> `.background().padding()` thì đệm nằm ngoài màu → khác nhau hoàn toàn.

## Ví dụ: Ghép tất cả thành 1 card

```swift
import SwiftUI

struct StackDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header: icon + tiêu đề + spacer + giá
            HStack {
                Image(systemName: "cart.fill")
                    .foregroundColor(.blue)
                Text("Đơn hàng #1024")
                    .font(.headline)
                Spacer()
                Text("250.000đ")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }

            Divider()   // đường kẻ ngang

            Text("Giao đến: 123 Đường ABC, Quận 1")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Nút full width
            Text("Xem chi tiết")
                .font(.subheadline).fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.blue)
                .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        .padding()
    }
}

#Preview {
    StackDemo()
}
```

## Ghi nhớ

- **VStack** dọc · **HStack** ngang · **ZStack** chồng lớp.
- `Spacer()` đẩy phần tử; `padding` tạo đệm; `frame(maxWidth: .infinity)` giãn hết.
- Mặc định 1 Stack chứa tối đa **10 view con**. Nhiều hơn → dùng `ForEach` (xem [06-list.md](06-list.md)).
- Thứ tự modifier quyết định kết quả — hãy thử đổi chỗ để thấy khác biệt.
