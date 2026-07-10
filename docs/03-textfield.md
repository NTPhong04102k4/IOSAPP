# 03 — TextField, SecureField, TextEditor

Nhóm component cho người dùng **nhập chữ**. Điểm mấu chốt: chúng cần 1 biến `@State`
để lưu giá trị, và truyền vào bằng `$` (binding).

## TextField cơ bản

```swift
struct Demo: View {
    @State private var name = ""          // nơi lưu giá trị

    var body: some View {
        TextField("Nhập tên của bạn", text: $name)   // $ = binding 2 chiều
    }
}
```

- Tham số 1 `"Nhập tên của bạn"` là **placeholder** (chữ mờ gợi ý).
- `$name` cho phép TextField vừa **đọc** vừa **ghi** vào biến `name`.

## Thêm viền / kiểu ô nhập

```swift
TextField("Email", text: $email)
    .textFieldStyle(.roundedBorder)     // kiểu bo góc có sẵn
```

Tự style thủ công:

```swift
TextField("Email", text: $email)
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(10)
    .overlay(
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
    )
```

## Bàn phím & auto-correct (rất quan trọng cho form)

```swift
TextField("Email", text: $email)
    .keyboardType(.emailAddress)        // .numberPad, .phonePad, .URL...
    .textInputAutocapitalization(.never) // không tự viết hoa (iOS 15+)
    .autocorrectionDisabled(true)        // tắt tự sửa lỗi
    .submitLabel(.next)                  // đổi nút Return thành "Next"
```

## SecureField — nhập mật khẩu (ẩn ký tự)

```swift
SecureField("Mật khẩu", text: $password)
    .textFieldStyle(.roundedBorder)
```

## TextEditor — nhập đoạn văn nhiều dòng

```swift
TextEditor(text: $note)
    .frame(height: 120)
    .padding(4)
    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.3)))
```

## Bắt sự kiện & focus

```swift
TextField("Tìm kiếm", text: $query)
    .onSubmit {                 // khi bấm Return
        print("Tìm: \(query)")
    }
    .onChange(of: query) { newValue in   // mỗi lần chữ đổi
        print("Đang gõ: \(newValue)")
    }
```

Ẩn bàn phím / quản lý focus bằng `@FocusState`:

```swift
@FocusState private var isFocused: Bool

TextField("Email", text: $email)
    .focused($isFocused)

Button("Xong") { isFocused = false }   // bấm để ẩn bàn phím
```

## Ví dụ: Form đăng nhập hoàn chỉnh

```swift
import SwiftUI

struct LoginFormDemo: View {
    @State private var email = ""
    @State private var password = ""

    // Kiểm tra hợp lệ đơn giản
    private var isValid: Bool {
        email.contains("@") && password.count >= 6
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Đăng nhập")
                .font(.largeTitle).fontWeight(.bold)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            SecureField("Mật khẩu (tối thiểu 6 ký tự)", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            Button {
                print("Login: \(email)")
            } label: {
                Text("Đăng nhập")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isValid ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!isValid)
        }
        .padding()
    }
}

#Preview {
    LoginFormDemo()
}
```

## Ghi nhớ

- **Luôn** cần biến `@State` + truyền `$biến` vào `text:`.
- Quên dấu `$` là lỗi phổ biến nhất khi mới học.
- Đặt `keyboardType` và `textInputAutocapitalization(.never)` cho ô Email để tránh viết hoa nhầm.
- Xem thêm về `$` và binding tại [08-state-binding.md](08-state-binding.md).
