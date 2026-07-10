# 04 — Functions (Hàm)

Hàm = khối code có tên, nhận **tham số** và (tùy chọn) **trả về** giá trị.

## Cơ bản

```swift
func sayHello() {
    print("Xin chào")
}
sayHello()          // gọi hàm
```

## Có tham số & giá trị trả về

```swift
func add(a: Int, b: Int) -> Int {   // -> Int là kiểu trả về
    return a + b
}
let sum = add(a: 3, b: 5)   // 8

// Nếu thân hàm chỉ 1 biểu thức → bỏ được 'return'
func square(_ x: Int) -> Int { x * x }
```

## Argument label vs parameter name

Swift cho phép tên gọi ngoài (label) khác tên dùng bên trong.

```swift
func greet(to name: String) {   // 'to' = label, 'name' = dùng bên trong
    print("Chào \(name)")
}
greet(to: "An")                 // đọc như câu tiếng Anh
```

Dùng `_` để **bỏ label** (gọi gọn hơn):

```swift
func multiply(_ a: Int, _ b: Int) -> Int { a * b }
multiply(4, 5)                  // không cần label
```

## Giá trị mặc định

```swift
func power(_ base: Int, exp: Int = 2) -> Int {
    var result = 1
    for _ in 0..<exp { result *= base }
    return result
}
power(3)            // 9  (exp mặc định = 2)
power(2, exp: 10)   // 1024
```

## Variadic — nhận số lượng tham số tùy ý

```swift
func total(_ numbers: Int...) -> Int {   // dấu ...
    numbers.reduce(0, +)
}
total(1, 2, 3)          // 6
total(1, 2, 3, 4, 5)    // 15
```

## `inout` — sửa trực tiếp biến truyền vào

Bình thường tham số là bản copy (không đổi được biến gốc). `inout` cho phép sửa gốc:

```swift
func increment(_ value: inout Int) {
    value += 1
}
var count = 10
increment(&count)       // dùng & khi gọi
print(count)            // 11
```

## Trả về nhiều giá trị bằng tuple

```swift
func divide(_ a: Int, by b: Int) -> (quotient: Int, remainder: Int) {
    return (a / b, a % b)
}
let r = divide(17, by: 5)
print("\(r.quotient) dư \(r.remainder)")   // 3 dư 2
```

## Trả về Optional (khi có thể thất bại)

```swift
func firstEven(in numbers: [Int]) -> Int? {
    for n in numbers where n % 2 == 0 {
        return n
    }
    return nil          // không tìm thấy
}
let even = firstEven(in: [1, 3, 6, 9]) ?? -1   // 6
```

## Hàm ném lỗi (throws) — giới thiệu nhanh

```swift
enum LoginError: Error { case emptyEmail, wrongPassword }

func login(email: String, password: String) throws {
    guard !email.isEmpty else { throw LoginError.emptyEmail }
    guard password == "1234" else { throw LoginError.wrongPassword }
    print("Đăng nhập thành công")
}

// Gọi hàm throws phải dùng do/try/catch
do {
    try login(email: "a@b.com", password: "1234")
} catch {
    print("Lỗi: \(error)")
}
```

## Hàm là "công dân hạng nhất" (first-class)

Hàm có thể gán vào biến, truyền vào hàm khác, trả về từ hàm khác:

```swift
func double(_ x: Int) -> Int { x * 2 }

let f = double          // gán hàm vào biến
print(f(5))             // 10

func apply(_ fn: (Int) -> Int, to value: Int) -> Int {
    fn(value)
}
apply(double, to: 8)    // 16
```

> Đây là cầu nối sang **Closure** — hàm ẩn danh — ở [05-closures.md](05-closures.md).

## Ghi nhớ

- `-> Kiểu` khai báo giá trị trả về; bỏ đi nếu hàm không trả gì.
- Label giúp code dễ đọc; `_` để bỏ label.
- Trả nhiều giá trị → dùng tuple; có thể thất bại → trả Optional; lỗi rõ ràng → `throws`.
- Hàm có thể được truyền như 1 giá trị → nền tảng của closure.
