# 02 — Button

`Button` là nút bấm: gồm 1 **action** (chạy khi bấm) và 1 **label** (nội dung hiển thị).

## Cơ bản

```swift
Button("Đăng nhập") {
    print("Đã bấm nút")   // action
}
```

Dạng đầy đủ với label tùy biến:

```swift
Button(action: {
    print("Đã bấm")
}) {
    Text("Đăng nhập")     // label có thể là bất kỳ View nào
}
```

## Label có Icon + Text

```swift
Button {
    // action
} label: {
    HStack {
        Image(systemName: "arrow.right.circle.fill")
        Text("Tiếp tục")
    }
}
```

Hoặc dùng `Label` (tự sắp icon + chữ):

```swift
Button {
    // action
} label: {
    Label("Xóa", systemImage: "trash")
}
```

## Button Style có sẵn (iOS 15+)

```swift
Button("Bordered") { }
    .buttonStyle(.bordered)

Button("Nổi bật") { }
    .buttonStyle(.borderedProminent)   // nền màu, chữ trắng
    .tint(.blue)                        // đổi màu chủ đạo

Button("Viền mảnh") { }
    .buttonStyle(.borderless)
```

## Tự style bằng modifier (cách hay dùng nhất)

```swift
Button {
    // action
} label: {
    Text("Đăng nhập")
        .font(.headline)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)   // giãn hết chiều ngang
        .padding()
        .background(Color.blue)
        .cornerRadius(12)
}
```

## Vô hiệu hóa (disabled)

```swift
Button("Gửi") { }
    .disabled(true)          // true = không bấm được, tự làm mờ
```

## Vai trò (role) — iOS 15+

```swift
Button("Xóa tài khoản", role: .destructive) { }   // chữ đỏ
Button("Hủy", role: .cancel) { }
```

## Ví dụ: nút Login đẹp + đếm số lần bấm

```swift
import SwiftUI

struct ButtonDemo: View {
    @State private var count = 0
    @State private var isAgree = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Đã bấm: \(count) lần")
                .font(.headline)

            // Nút chính, full width
            Button {
                count += 1
            } label: {
                Text("Đăng nhập")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isAgree ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!isAgree)   // chỉ bấm được khi đã đồng ý

            Button(isAgree ? "Đã đồng ý điều khoản" : "Tôi đồng ý điều khoản") {
                isAgree.toggle()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    ButtonDemo()
}
```

## Ghi nhớ

- Action là 1 **closure** — code chạy *khi bấm*, không phải khi tạo view.
- Muốn nút full chiều ngang: dùng `.frame(maxWidth: .infinity)` trên label.
- `.disabled()` nhận `Bool`; SwiftUI tự làm mờ khi `true`.
- Biến `@State` (như `count`) sẽ khiến UI tự vẽ lại khi thay đổi → xem [08-state-binding.md](08-state-binding.md).
