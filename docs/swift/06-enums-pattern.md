# 06 — Enum & Pattern Matching

**Enum** = kiểu liệt kê 1 tập giá trị cố định (ví dụ: trạng thái, loại, hướng).
**Pattern matching** = khớp mẫu bằng `switch`, cực mạnh trong Swift.

## Enum cơ bản

```swift
enum Direction {
    case north
    case south
    case east
    case west
}

var heading = Direction.north
heading = .south          // đã biết kiểu → dùng .south cho gọn
```

## Switch trên enum (bắt buộc xét đủ mọi case)

```swift
switch heading {
case .north: print("Bắc")
case .south: print("Nam")
case .east:  print("Đông")
case .west:  print("Tây")
}
```

> Swift yêu cầu `switch` phải **exhaustive** (xét hết mọi trường hợp), hoặc có `default`.
> Nhờ vậy thêm case mới → compiler báo chỗ nào quên xử lý.

## Raw value — gán giá trị "thô" cho mỗi case

```swift
enum Planet: Int {
    case mercury = 1, venus, earth, mars   // tự tăng: 2, 3, 4
}
Planet.earth.rawValue          // 3
Planet(rawValue: 4)            // Optional(.mars) — khởi tạo từ raw

enum Weekday: String {
    case mon = "Thứ 2", tue = "Thứ 3"
}
Weekday.mon.rawValue           // "Thứ 2"
```

## Associated value — mỗi case mang dữ liệu kèm theo (RẤT mạnh)

```swift
enum NetworkResult {
    case success(data: String)
    case failure(code: Int, message: String)
    case loading
}

let result = NetworkResult.failure(code: 404, message: "Not Found")

switch result {
case .success(let data):
    print("OK: \(data)")
case .failure(let code, let message):        // rút giá trị kèm ra
    print("Lỗi \(code): \(message)")
case .loading:
    print("Đang tải...")
}
```

Đây là mẫu cực phổ biến để mô hình hóa trạng thái màn hình (loading / có dữ liệu / lỗi).

## Enum có method & computed property

```swift
enum Direction {
    case north, south, east, west

    var symbol: String {
        switch self {
        case .north: return "↑"
        case .south: return "↓"
        case .east:  return "→"
        case .west:  return "←"
        }
    }

    func opposite() -> Direction {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east:  return .west
        case .west:  return .east
        }
    }
}
Direction.north.symbol          // "↑"
Direction.east.opposite()       // .west
```

## Pattern matching nâng cao

### `where` — thêm điều kiện

```swift
let score = 85
switch score {
case let x where x >= 90: print("Xuất sắc")
case let x where x >= 70: print("Khá")
default: print("Cần cố gắng")
}
```

### Khớp khoảng & nhiều giá trị

```swift
switch score {
case 0..<50:   print("Rớt")
case 50..<80:  print("Đạt")
case 80...100: print("Giỏi")
default:       print("Điểm không hợp lệ")
}

let ch: Character = "e"
switch ch {
case "a", "e", "i", "o", "u": print("Nguyên âm")
default: print("Phụ âm")
}
```

### Khớp tuple

```swift
let point = (2, 0)
switch point {
case (0, 0):        print("Gốc tọa độ")
case (_, 0):        print("Trên trục X")
case (0, _):        print("Trên trục Y")
case let (x, y):    print("Điểm (\(x), \(y))")
}
```

### `if case` — khớp 1 mẫu duy nhất (không cần switch đầy đủ)

```swift
let r = NetworkResult.success(data: "xong")

if case .success(let data) = r {
    print("Thành công với \(data)")
}
```

## Ví dụ thực tế: mô hình trạng thái tải dữ liệu

```swift
enum LoadState<T> {
    case idle
    case loading
    case loaded(T)
    case failed(Error)
}

func render(_ state: LoadState<[String]>) {
    switch state {
    case .idle:            print("Chưa bắt đầu")
    case .loading:         print("Đang tải...")
    case .loaded(let items): print("Có \(items.count) mục")
    case .failed(let error): print("Lỗi: \(error)")
    }
}
```

## Ghi nhớ

- Enum liệt kê tập giá trị cố định; `switch` phải xét đủ mọi case.
- **Raw value** = giá trị thô cố định; **associated value** = dữ liệu kèm động.
- `switch` hỗ trợ `where`, khoảng, tuple, binding `let` → pattern matching mạnh.
- `if case` để khớp nhanh 1 mẫu.
- Enum + associated value là cách chuẩn để mô hình trạng thái (rất hợp với ViewModel).
