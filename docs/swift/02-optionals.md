# 02 — Optional (giá trị có thể rỗng)

**Optional** là tính năng an toàn nổi bật nhất của Swift. Nó trả lời: "biến này có thể *không có* giá trị (nil) không?"

## Vấn đề nó giải quyết

Ở nhiều ngôn ngữ, `null` gây crash bất ngờ. Swift buộc bạn khai báo rõ khi nào giá trị có thể rỗng,
và **bắt buộc xử lý** trước khi dùng → tránh crash.

## Khai báo Optional bằng `?`

```swift
var name: String = "An"     // BẮT BUỘC có giá trị
var nickname: String? = nil  // có thể rỗng (Optional String)

nickname = "Bin"             // gán giá trị sau cũng được
```

- `String` → luôn có chữ.
- `String?` → hoặc có chữ, hoặc `nil`.

## Không dùng trực tiếp được — phải "mở khóa" (unwrap)

```swift
var age: Int? = 20
// let next = age + 1        // ❌ lỗi: age là Optional, chưa unwrap
```

## Cách 1: `if let` — unwrap an toàn

```swift
if let realAge = age {
    print("Tuổi là \(realAge)")   // chỉ chạy khi age có giá trị
} else {
    print("Không có tuổi")
}

// Swift 5.7+: viết gọn nếu trùng tên
if let age {
    print("Tuổi \(age)")
}
```

## Cách 2: `guard let` — thoát sớm nếu nil (hay dùng trong hàm)

```swift
func greet(_ name: String?) {
    guard let name = name else {
        print("Không có tên")
        return                  // guard bắt buộc thoát nếu nil
    }
    // từ đây trở đi 'name' đã chắc chắn có giá trị
    print("Xin chào \(name)")
}
```

> `if let` dùng giá trị *bên trong* khối; `guard let` mở giá trị ra dùng cho *cả phần còn lại* của hàm.
> Trong thực tế, `guard let` rất phổ biến ở đầu hàm để kiểm tra đầu vào.

## Cách 3: `??` — giá trị mặc định (nil-coalescing)

```swift
let display = nickname ?? "Khách"   // nếu nickname nil → dùng "Khách"
let count = age ?? 0
```

## Cách 4: Optional chaining `?.`

Gọi thuộc tính/hàm qua chuỗi; nếu bất kỳ mắt xích nào nil → cả biểu thức trả nil (không crash).

```swift
struct Address { let city: String }
struct User { let address: Address? }

let user: User? = User(address: Address(city: "HCM"))
let city = user?.address?.city    // "HCM" (kiểu String?)
let len  = user?.address?.city.count ?? 0
```

## `!` — force unwrap (NGUY HIỂM)

```swift
let x: Int? = 5
let y = x!        // ép mở; nếu x là nil → CRASH ngay
```

> ⚠️ Chỉ dùng `!` khi bạn **chắc chắn 100%** có giá trị. Người mới nên tránh — ưu tiên `if let`/`guard let`/`??`.

## Ví dụ thực tế: chuyển String → Int

`Int("...")` trả về Optional vì chuỗi có thể không phải số:

```swift
let input = "42"
let number = Int(input)          // Int? (có thể nil nếu không phải số)

if let number = number {
    print("Số hợp lệ: \(number)")
} else {
    print("Không phải số")
}

// Hoặc gọn:
let safe = Int(input) ?? 0
```

## Optional trong dictionary (sẽ gặp lại ở file 03)

Truy cập dictionary luôn trả Optional (vì key có thể không tồn tại):

```swift
let scores = ["An": 9, "Bình": 7]
let anScore = scores["An"]        // Optional(9)
let unknown = scores["X"] ?? 0    // 0 (key không có)
```

## Ghi nhớ

| Cú pháp | Ý nghĩa |
|---------|---------|
| `Type?` | Có thể có giá trị hoặc nil |
| `if let x = x { }` | Unwrap an toàn, dùng trong khối |
| `guard let x = x else { return }` | Thoát sớm nếu nil |
| `x ?? default` | Giá trị thay thế khi nil |
| `a?.b?.c` | Chuỗi an toàn, nil nếu đứt mắt xích |
| `x!` | Ép mở — crash nếu nil (hạn chế dùng) |

- Optional = "hộp có thể rỗng"; luôn mở hộp an toàn trước khi dùng.
- Ưu tiên `guard let` ở đầu hàm, `??` cho giá trị mặc định.
