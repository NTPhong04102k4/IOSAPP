# 08 — State & Binding (@State, @Binding, $, ObservableObject)

Đây là phần **quan trọng nhất** để hiểu SwiftUI. Nó trả lời câu hỏi:
"Làm sao UI tự cập nhật khi dữ liệu thay đổi?"

## Nguyên tắc cốt lõi

SwiftUI là **declarative**: UI = 1 hàm của state.
Khi state đổi → SwiftUI **tự động vẽ lại** (re-render) view. Bạn không tự cập nhật label thủ công.

## @State — dữ liệu riêng của 1 view

Dùng cho giá trị đơn giản, thuộc về **1 view duy nhất**.

```swift
struct Counter: View {
    @State private var count = 0     // luôn để 'private'

    var body: some View {
        VStack {
            Text("Số: \(count)")     // đọc count
            Button("Tăng") {
                count += 1           // ghi count → UI tự vẽ lại
            }
        }
    }
}
```

- `@State` khiến SwiftUI "theo dõi" biến. Đổi giá trị → view liên quan tự cập nhật.
- Luôn đánh dấu `private` vì nó là state nội bộ.

## Dấu $ — tạo Binding (kết nối 2 chiều)

- `count` → **giá trị** (đọc).
- `$count` → **binding**: cho phép view con vừa đọc vừa **ghi ngược** lại.

TextField/Toggle... cần binding vì chúng phải ghi giá trị người dùng nhập vào:

```swift
@State private var name = ""
TextField("Tên", text: $name)   // $ = cho phép TextField sửa 'name'
```

## @Binding — nhận state từ view cha

Khi tách 1 phần UI ra **component con**, con dùng `@Binding` để "mượn" state của cha:

```swift
// Component con: 1 nút toggle tùy biến
struct LikeButton: View {
    @Binding var isLiked: Bool       // không tự sở hữu, chỉ mượn

    var body: some View {
        Button {
            isLiked.toggle()
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .gray)
        }
    }
}

// View cha: sở hữu state thật bằng @State, truyền xuống bằng $
struct ParentView: View {
    @State private var liked = false

    var body: some View {
        VStack {
            LikeButton(isLiked: $liked)       // truyền binding xuống
            Text(liked ? "Đã thích" : "Chưa thích")
        }
    }
}
```

> Quy tắc vàng: **cha** giữ dữ liệu thật (`@State`), **con** mượn (`@Binding`),
> truyền xuống bằng dấu `$`.

## @StateObject / @ObservedObject — dữ liệu phức tạp, dùng chung

Khi logic phức tạp (gọi API, nhiều biến), tách ra 1 class `ObservableObject` (kiểu ViewModel):

```swift
import SwiftUI

// ViewModel
class LoginViewModel: ObservableObject {
    @Published var email = ""          // @Published: đổi → view vẽ lại
    @Published var isLoading = false

    func login() {
        isLoading = true
        // ... gọi API ...
    }
}

// View
struct LoginScreen: View {
    @StateObject private var vm = LoginViewModel()   // tạo & sở hữu ViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $vm.email)      // $vm.email vẫn dùng được
            Button("Đăng nhập") { vm.login() }
                .disabled(vm.isLoading)
        }
    }
}
```

- `@StateObject`: dùng ở nơi **tạo ra** ViewModel (owner) — chỉ tạo 1 lần.
- `@ObservedObject`: dùng khi ViewModel được **truyền vào từ ngoài**.
- `@Published`: đánh dấu thuộc tính; đổi giá trị → mọi view đang xem sẽ tự cập nhật.

> 💡 Trong project này, file `Core/Authentication/ViewModels/AuthViewModal.swift`
> chính là nơi nên tạo 1 class `ObservableObject` như trên.

## Bảng tổng hợp — chọn cái nào?

| Tình huống | Dùng |
|-----------|------|
| Giá trị đơn giản, chỉ 1 view dùng | `@State` |
| Truyền state cho component con sửa | `@Binding` (+ `$` khi truyền) |
| Tạo & sở hữu ViewModel | `@StateObject` |
| Nhận ViewModel từ nơi khác | `@ObservedObject` |
| Thuộc tính trong ViewModel cần theo dõi | `@Published` |

## Lỗi thường gặp

1. **Quên dấu `$`**: `TextField("x", text: name)` ❌ → phải là `$name` ✅.
2. **Đổi `let` thành cần sửa**: muốn thay đổi giá trị thì phải `@State var`, không phải `let`.
3. **Dùng `@ObservedObject` để tạo ViewModel**: sẽ bị tạo lại mỗi lần vẽ → dùng `@StateObject` ở owner.
4. **Đổi state trong `body`**: không được sửa state trực tiếp khi đang tính `body` (chỉ sửa trong action/closure).

## Ghi nhớ

- State đổi → UI tự vẽ lại. Đó là toàn bộ "phép màu" của SwiftUI.
- `biến` = giá trị; `$biến` = binding (đọc + ghi).
- Bắt đầu bằng `@State`; khi logic lớn dần thì chuyển sang `ObservableObject` (ViewModel).
