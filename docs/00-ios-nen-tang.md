# 00 — iOS nền tảng: UIKit, AppDelegate & App lifecycle

File này giải thích **bối cảnh** để hiểu vì sao code SwiftUI trong project trông như vậy:
cái gì là "cách cũ" (UIKit / AppDelegate), cái gì là "cách mới" (SwiftUI).
Đọc file này trước khi vào các component 01 → 08 sẽ dễ hiểu hơn.

## Bức tranh tổng: 2 thế hệ làm UI trên iOS

| | UIKit | SwiftUI |
|---|-------|---------|
| Ra đời | 2008 (iPhone đầu tiên) | 2019 |
| Phong cách | **Imperative** — ra lệnh từng bước | **Declarative** — mô tả UI *nên* trông thế nào |
| Đơn vị màn hình | `class UIViewController` | `struct` tuân theo `View` |
| Cập nhật UI | Tự tay sửa view (`label.text = ...`) | State đổi → UI **tự** vẽ lại |
| Điểm khởi động app | `AppDelegate` | `struct ... : App` (`@main`) |

> Project `AppIos` dùng **SwiftUI** (cột phải). Bạn gần như không viết UIKit ở đây.

---

## 1. UIKit là gì?

Framework UI **cũ** của Apple. Bạn xây giao diện bằng cách ra lệnh từng bước:
"tạo nút này → đặt ở đây → khi bấm thì tự tay đổi màu label kia".

```swift
// Tinh thần UIKit (imperative) — KHÔNG có trong project này
let label = UILabel()
label.text = "Xin chào"
button.addTarget(self, action: #selector(tap), for: .touchUpInside)
// khi bấm, bạn phải TỰ cập nhật:
@objc func tap() { label.text = "Đã bấm" }
```

- Class chính: `UIView`, `UIViewController`, `UIButton`, `UILabel`...
- Bạn phải **tự đồng bộ** dữ liệu ↔ giao diện. Dễ quên → bug "UI không cập nhật".

### Nhưng SwiftUI vẫn "mượn" một chút UIKit
Trong project, file `Helpers/Theme/` có:

```swift
Color(UIColor.systemBackground)   // UIColor là type của UIKit
```

`UIColor` là của UIKit, nhưng SwiftUI cho phép bọc nó thành `Color`. Đây là cách **duy nhất** project chạm tới UIKit — để lấy màu hệ thống tự đổi theo Light/Dark.

---

## 2. AppDelegate là gì?

Là **điểm khởi động cũ** của app (thời UIKit): một class tên `AppDelegate` xử lý các sự kiện vòng đời app.

```swift
// Kiểu CŨ (UIKit) — project bạn KHÔNG có file này
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ app: UIApplication,
                     didFinishLaunchingWithOptions ...) -> Bool {
        // chạy 1 lần khi app vừa mở
        return true
    }
}
```

Nó chịu trách nhiệm: app mở xong, vào nền / quay lại, nhận push notification...

### SwiftUI thay AppDelegate bằng gì?
Bằng một `struct` tuân theo protocol `App`, đánh dấu `@main`. Trong project là file
`AppIos/AppIosApp.swift`:

```swift
@main                              // ← điểm khởi động của app (thay cho AppDelegate)
struct AppIosApp: App {
    var body: some Scene {
        WindowGroup {              // cửa sổ chính của app
            ContentView()          // màn hình đầu tiên hiện ra
        }
    }
}
```

| Câu hỏi | UIKit | SwiftUI (project này) |
|---------|-------|-----------------------|
| Ai khởi động app? | `AppDelegate` | `@main struct AppIosApp: App` |
| Màn đầu tiên khai báo ở đâu? | trong code delegate | `WindowGroup { ContentView() }` |

> 💡 Khi nào vẫn cần AppDelegate trong SwiftUI? Chỉ khi tích hợp thứ cũ (push notification cấu hình sâu, một số SDK). Lúc đó dùng `@UIApplicationDelegateAdaptor` để "gắn" AppDelegate vào `App`. Project hiện chưa cần.

---

## 3. ObservableObject là gì? (tóm tắt)

Đây là cơ chế **state** của SwiftUI cho dữ liệu phức tạp (ViewModel) — bạn đang dùng nó ở
`Core/Authentication/ViewModels/AuthViewModal.swift`.

```swift
@MainActor
final class LoginViewModel: ObservableObject {  // "hộp dữ liệu có thể quan sát"
    @Published var email = ""     // đổi → View đang xem tự vẽ lại
    @Published var password = ""
}
```

Ba mảnh ghép luôn đi cùng:

| Từ khóa | Vai trò |
|---------|---------|
| `ObservableObject` | Class chứa dữ liệu mà View theo dõi (kiểu ViewModel) |
| `@Published` | Đánh dấu property nào "đổi thì báo View" |
| `@StateObject` / `@ObservedObject` | Bên trong View để "đăng ký theo dõi" object đó |

Đây khác hẳn UIKit: bạn **không** tự tay cập nhật UI — chỉ cần đổi `@Published`, SwiftUI lo phần vẽ lại.

> 📖 Chi tiết đầy đủ (kèm `@State`, `@Binding`, khi nào dùng `@StateObject` vs `@ObservedObject`)
> xem **[08 — State & Binding](08-state-binding.md)**.

---

## Ghi nhớ

- **UIKit** = cách làm UI *cũ*, imperative. Project chỉ mượn `UIColor` cho theme.
- **AppDelegate** = điểm khởi động *cũ*. SwiftUI thay bằng `@main struct: App` → xem `AppIos/AppIosApp.swift`.
- **ObservableObject** = "hộp dữ liệu" View theo dõi; đổi `@Published` → UI tự cập nhật → xem `AuthViewModal.swift` và file [08](08-state-binding.md).
- Tư duy chính của SwiftUI: **mô tả UI theo state**, để framework tự vẽ lại — không thao tác view thủ công như UIKit.
