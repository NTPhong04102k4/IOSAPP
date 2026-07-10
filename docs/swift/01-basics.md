# 01 — Cơ bản: Biến, Kiểu, Tuple, Typealias

## Biến & hằng: `var` và `let`

```swift
let name = "An"      // hằng — KHÔNG đổi được
var age = 25         // biến — đổi được
age = 26             // OK
// name = "Bình"     // ❌ lỗi: 'name' là let
```

> Quy tắc: **luôn dùng `let` trước**, chỉ đổi sang `var` khi thật sự cần thay đổi.

## Kiểu dữ liệu cơ bản

```swift
let i: Int = 42            // số nguyên
let d: Double = 3.14       // số thực
let flag: Bool = true      // đúng/sai
let s: String = "Xin chào" // chuỗi
let c: Character = "A"      // 1 ký tự
```

**Type inference** (tự suy kiểu) — không cần ghi kiểu nếu gán ngay:

```swift
let x = 10          // Swift hiểu Int
let y = 3.5         // Swift hiểu Double
let z = "hi"        // Swift hiểu String
```

**Ép kiểu** (conversion) phải làm rõ ràng — Swift không tự chuyển ngầm:

```swift
let a = 5
let b = 2.0
let result = Double(a) + b     // phải Double(a); 7.0
let text = "Tuổi: " + String(a) // số → chuỗi
```

## String — chuỗi

```swift
let first = "An"
let last = "Nguyễn"

// Nối chuỗi
let full = first + " " + last

// Nội suy (interpolation) — cách hay dùng nhất
let msg = "Tôi tên \(first), \(age) tuổi"

// Chuỗi nhiều dòng
let paragraph = """
Dòng 1
Dòng 2
"""

// Thuộc tính hữu ích
full.count            // số ký tự
full.uppercased()     // "AN NGUYỄN"
full.lowercased()
full.isEmpty          // false
full.contains("An")   // true
full.hasPrefix("An")  // true
```

## Toán tử

```swift
// Số học: + - * / %
let sum = 10 + 3          // 13
let rem = 10 % 3          // 1 (chia lấy dư)

// So sánh: == != < > <= >=  → trả về Bool
let equal = (5 == 5)      // true

// Logic: && (và) || (hoặc) ! (phủ định)
let ok = (age > 18) && flag

// Toán tử 3 ngôi (ternary)
let label = age >= 18 ? "Người lớn" : "Trẻ em"
```

## Tuple — gộp nhiều giá trị thành 1

Tuple gom vài giá trị (có thể khác kiểu) lại mà không cần tạo struct.

```swift
// Tạo tuple
let point = (x: 10, y: 20)
print(point.x)        // 10  (truy cập bằng tên)
print(point.0)        // 10  (hoặc bằng chỉ số)

// Không đặt tên
let pair = (1, "một")
print(pair.0, pair.1) // 1 một

// Tách (destructuring) ra biến riêng
let (px, py) = point
print(px, py)         // 10 20

// Bỏ qua phần không cần bằng _
let (_, second) = pair
print(second)         // một
```

**Dùng tuple để hàm trả về nhiều giá trị** (rất phổ biến):

```swift
func minMax(_ numbers: [Int]) -> (min: Int, max: Int) {
    return (numbers.min() ?? 0, numbers.max() ?? 0)
}

let r = minMax([3, 1, 8, 2])
print("Nhỏ nhất \(r.min), lớn nhất \(r.max)")   // 1 ... 8
```

> Tuple phù hợp cho nhóm giá trị tạm thời (2–3 phần tử). Nếu dùng nhiều/lâu dài,
> hãy tạo `struct` (xem [07-struct-class-protocol.md](07-struct-class-protocol.md)).

## Typealias — đặt tên khác cho 1 kiểu

Giúp code dễ đọc hơn khi kiểu dài hoặc mang ý nghĩa cụ thể.

```swift
typealias UserID = Int
typealias Meters = Double

let myID: UserID = 1024        // vẫn là Int, chỉ đọc rõ nghĩa hơn
let distance: Meters = 42.195

// Đặt tên cho tuple / closure phức tạp
typealias Coordinate = (lat: Double, lng: Double)
let hcm: Coordinate = (10.76, 106.66)

typealias CompletionHandler = (Bool, String) -> Void
func login(done: CompletionHandler) { done(true, "OK") }
```

## Điều khiển luồng cơ bản

```swift
// if / else
if age >= 18 {
    print("Đủ tuổi")
} else {
    print("Chưa đủ")
}

// Vòng lặp for trên khoảng (range)
for i in 1...5 { print(i) }     // 1 2 3 4 5 (bao gồm 5)
for i in 0..<5 { print(i) }     // 0 1 2 3 4 (không gồm 5)

// while
var n = 3
while n > 0 { n -= 1 }

// Lặp trên collection
for name in ["An", "Bình", "Chi"] { print(name) }
```

## Ghi nhớ

- `let` mặc định, `var` khi cần đổi.
- `\(...)` để nhúng giá trị vào chuỗi.
- **Tuple** = gộp giá trị tạm; **typealias** = đặt tên thân thiện cho 1 kiểu.
- Swift không ép kiểu ngầm → phải `Double(x)`, `String(x)`... khi trộn kiểu.
