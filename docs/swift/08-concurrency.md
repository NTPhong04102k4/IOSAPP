# 08 — Concurrency: Thread, Process, async/await

Concurrency = chạy nhiều việc "cùng lúc" để app không bị **đơ** khi làm việc nặng (tải mạng, đọc file, tính toán lớn).

## Khái niệm nền: Process vs Thread

- **Process (tiến trình)**: 1 chương trình đang chạy, có vùng nhớ riêng. App iOS của bạn = 1 process.
- **Thread (luồng)**: 1 "dòng thực thi" bên trong process. 1 process có nhiều thread chạy song song.
- **Main thread (luồng chính / UI thread)**: nơi vẽ giao diện. **Mọi cập nhật UI phải ở main thread.**
  Nếu làm việc nặng trên main thread → app đơ, giật.

> Nguyên tắc vàng: **việc nặng → chạy ở background thread; cập nhật UI → quay về main thread.**

---

## Cách hiện đại: async / await (iOS 15+, khuyến nghị)

Viết code bất đồng bộ mà đọc như code tuần tự.

```swift
// Hàm bất đồng bộ đánh dấu 'async'
func fetchUser() async -> String {
    // ... giả lập chờ mạng ...
    try? await Task.sleep(nanoseconds: 1_000_000_000)  // chờ 1 giây
    return "An"
}

// Gọi hàm async phải dùng 'await', và phải ở trong ngữ cảnh async
func loadProfile() async {
    let name = await fetchUser()      // "chờ" nhưng KHÔNG block UI
    print("Xin chào \(name)")
}
```

### Hàm async có thể ném lỗi

```swift
func downloadData(from url: URL) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}

// Gọi:
do {
    let data = try await downloadData(from: someURL)
    print("Tải \(data.count) bytes")
} catch {
    print("Lỗi tải: \(error)")
}
```

## Task — bắc cầu từ code đồng bộ sang async

Từ code thường (không async), tạo `Task` để chạy việc async:

```swift
Task {
    let name = await fetchUser()
    print(name)
}
```

## Chạy song song thật sự với `async let`

```swift
func loadDashboard() async {
    async let user = fetchUser()        // cả 3 bắt đầu CÙNG LÚC
    async let posts = fetchPosts()
    async let notifs = fetchNotifs()

    let (u, p, n) = await (user, posts, notifs)   // chờ cả 3 xong
    print(u, p, n)
}
```

## @MainActor — đảm bảo chạy trên main thread (để cập nhật UI)

```swift
@MainActor
class ProfileViewModel: ObservableObject {
    @Published var name = ""

    func load() async {
        let result = await fetchUser()   // chạy nền
        name = result                     // @MainActor đảm bảo dòng này ở main thread → UI an toàn
    }
}
```

> Trong SwiftUI, mọi `@Published` nên cập nhật trên main thread. Đánh dấu `@MainActor`
> cho ViewModel là cách gọn nhất để tránh cảnh báo "Publishing changes from background thread".

## actor — bảo vệ dữ liệu khỏi truy cập đồng thời (data race)

Khi nhiều thread cùng sửa 1 dữ liệu → dễ lỗi. `actor` tuần tự hóa truy cập tự động:

```swift
actor BankAccount {
    private var balance = 0

    func deposit(_ amount: Int) {
        balance += amount        // an toàn: actor đảm bảo không có 2 truy cập cùng lúc
    }
    func getBalance() -> Int { balance }
}

let account = BankAccount()
Task {
    await account.deposit(100)   // truy cập actor phải 'await'
    print(await account.getBalance())
}
```

---

## Cách cũ: GCD (Grand Central Dispatch)

Vẫn còn gặp trong code cũ. Nắm để đọc được, nhưng dự án mới nên ưu tiên async/await.

```swift
import Foundation

// Chạy việc nặng ở background, rồi quay về main để cập nhật UI
DispatchQueue.global(qos: .background).async {
    let result = heavyCalculation()          // chạy nền

    DispatchQueue.main.async {
        // cập nhật UI ở đây (main thread)
        print("Xong: \(result)")
    }
}
```

- `DispatchQueue.global()` = hàng đợi nền (background).
- `DispatchQueue.main` = luồng chính (UI).
- `qos` (quality of service): `.userInteractive` › `.userInitiated` › `.default` › `.utility` › `.background`.

Trì hoãn thực thi:

```swift
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    print("Chạy sau 2 giây")
}
```

---

## Ví dụ thực tế: gọi API trong SwiftUI

```swift
import SwiftUI

@MainActor
class PostViewModel: ObservableObject {
    @Published var posts: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadPosts() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }        // luôn chạy khi hàm kết thúc

        do {
            // giả lập tải mạng
            try await Task.sleep(nanoseconds: 500_000_000)
            posts = ["Bài 1", "Bài 2", "Bài 3"]
        } catch {
            errorMessage = "Không tải được: \(error.localizedDescription)"
        }
    }
}

struct PostList: View {
    @StateObject private var vm = PostViewModel()

    var body: some View {
        List(vm.posts, id: \.self) { Text($0) }
            .overlay { if vm.isLoading { ProgressView() } }
            .task {                    // .task tự chạy async khi view xuất hiện
                await vm.loadPosts()
            }
    }
}
```

> `.task { await ... }` là cách chuẩn để khởi chạy công việc async khi view hiện lên
> (tự hủy khi view biến mất).

## Ghi nhớ

| Khái niệm | Vai trò |
|-----------|---------|
| Main thread | Nơi vẽ UI — không làm việc nặng ở đây |
| `async`/`await` | Cách hiện đại viết bất đồng bộ (ưu tiên) |
| `Task { }` | Bắc cầu từ code thường sang async |
| `async let` | Chạy nhiều việc song song |
| `@MainActor` | Đảm bảo cập nhật UI trên main thread |
| `actor` | Bảo vệ dữ liệu khỏi truy cập đồng thời |
| GCD (`DispatchQueue`) | Cách cũ — đọc hiểu code legacy |

- Việc nặng → nền; cập nhật UI → main thread. Đây là nguyên tắc bao trùm mọi concurrency.
- Dự án mới: dùng `async/await` + `@MainActor` + `.task`. GCD chỉ để đọc code cũ.
