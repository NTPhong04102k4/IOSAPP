# 07 — Struct, Class & Protocol (Kiến trúc ngôn ngữ)

Đây là "khung xương" để tổ chức code Swift: gộp dữ liệu + hành vi thành kiểu riêng.

## Struct — value type (ưu tiên dùng)

```swift
struct User {
    var name: String
    var age: Int

    // Method
    func greeting() -> String {
        "Xin chào, tôi là \(name)"
    }

    // Computed property (thuộc tính tính toán)
    var isAdult: Bool {
        age >= 18
    }
}

var a = User(name: "An", age: 20)   // init tự sinh sẵn
print(a.greeting())
print(a.isAdult)                     // true
```

### Value type = COPY khi gán (điểm cực quan trọng)

```swift
var b = a          // COPY — b là bản sao độc lập
b.name = "Bình"
print(a.name)      // "An"  (a KHÔNG bị ảnh hưởng)
print(b.name)      // "Bình"
```

> `struct`, `enum`, và mọi collection (Array/Set/Dictionary), String, Int... đều là value type.

### `mutating` — method sửa chính struct

```swift
struct Counter {
    var value = 0
    mutating func increment() {   // cần 'mutating' để sửa self
        value += 1
    }
}
var c = Counter()
c.increment()      // c.value = 1  (c phải là var)
```

## Class — reference type

```swift
class Account {
    var balance: Int

    init(balance: Int) {     // class PHẢI tự viết init
        self.balance = balance
    }

    func deposit(_ amount: Int) {   // không cần 'mutating'
        balance += amount
    }
}

let x = Account(balance: 100)
let y = x           // KHÔNG copy — x và y trỏ CÙNG 1 object
y.deposit(50)
print(x.balance)    // 150  (x cũng đổi theo!)
```

### Struct vs Class — chọn cái nào?

| | struct (value) | class (reference) |
|---|---|---|
| Gán/truyền | Copy (bản sao độc lập) | Chia sẻ (cùng 1 object) |
| Kế thừa | Không | Có (`class B: A`) |
| init | Tự sinh | Tự viết |
| Dùng khi | Dữ liệu thuần (Model, DTO) | Cần chia sẻ trạng thái, ViewModel |

> Quy tắc: **mặc định dùng `struct`**. Chỉ dùng `class` khi cần chia sẻ tham chiếu
> hoặc kế thừa (ví dụ `ObservableObject` ViewModel trong SwiftUI phải là class).

## Kế thừa (chỉ class)

```swift
class Animal {
    func sound() -> String { "..." }
}
class Dog: Animal {
    override func sound() -> String { "Gâu gâu" }   // ghi đè
}
Dog().sound()      // "Gâu gâu"
```

## Protocol — "hợp đồng" (interface)

Protocol định nghĩa *phải có gì*, không nói *làm thế nào*. Kiểu nào tuân theo thì phải cài đủ.

```swift
protocol Describable {
    var description: String { get }     // yêu cầu có thuộc tính
    func summary() -> String            // yêu cầu có method
}

struct Book: Describable {
    let title: String
    var description: String { "Sách: \(title)" }
    func summary() -> String { "Tóm tắt \(title)" }
}
```

Protocol cho phép viết code tổng quát, không phụ thuộc kiểu cụ thể:

```swift
func printInfo(_ item: Describable) {
    print(item.description)
}
printInfo(Book(title: "Swift 101"))
```

Vài protocol chuẩn hay gặp:
- `Identifiable` — có `id` (cần cho `List`/`ForEach` trong SwiftUI).
- `Equatable` — so sánh bằng `==`.
- `Codable` — chuyển đổi qua lại JSON.
- `Hashable` — dùng làm phần tử `Set` hoặc key `Dictionary`.

```swift
struct Product: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
}
```

## Extension — thêm chức năng cho kiểu có sẵn

```swift
extension Int {
    var squared: Int { self * self }
    func times(_ action: () -> Void) {
        for _ in 0..<self { action() }
    }
}
5.squared            // 25
3.times { print("Hi") }   // in "Hi" 3 lần

// Thêm cả cho kiểu của Apple
extension String {
    var isValidEmail: Bool { contains("@") && contains(".") }
}
"a@b.com".isValidEmail   // true
```

## Generic — code dùng cho mọi kiểu

```swift
func swapValues<T>(_ a: inout T, _ b: inout T) {
    let tmp = a; a = b; b = tmp
}

struct Stack<Element> {          // ngăn xếp cho kiểu bất kỳ
    private var items: [Element] = []
    mutating func push(_ item: Element) { items.append(item) }
    mutating func pop() -> Element? { items.popLast() }
}
var s = Stack<Int>()
s.push(1); s.push(2)
s.pop()              // Optional(2)
```

## Ví dụ áp dụng cho project (Model + ViewModel)

```swift
// Model — struct thuần (value type)
struct AuthUser: Identifiable, Codable {
    let id: String
    let email: String
    var displayName: String
}

// ViewModel — class vì cần ObservableObject (reference type, chia sẻ trạng thái)
import SwiftUI
class AuthViewModel: ObservableObject {
    @Published var currentUser: AuthUser?
    @Published var isLoggedIn = false

    func login(email: String) {
        currentUser = AuthUser(id: "1", email: email, displayName: "User")
        isLoggedIn = true
    }
}
```

## Ghi nhớ

- **struct = copy** (mặc định dùng) · **class = chia sẻ tham chiếu** (khi cần).
- `mutating` để struct sửa chính nó; class không cần.
- **Protocol** = hợp đồng; **extension** = thêm chức năng; **generic** = tái dùng cho mọi kiểu.
- Model → dùng `struct`; ViewModel (`ObservableObject`) → phải `class`.
