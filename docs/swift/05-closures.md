# 05 — Closures (Hàm ẩn danh)

**Closure** = khối code không tên, có thể gán vào biến và truyền đi. Giống lambda/arrow function.
Đây là thứ bạn gặp liên tục trong SwiftUI (action của Button, `.onTapGesture`, `map`, `filter`...).

## Cú pháp đầy đủ

```swift
let greet = { (name: String) -> String in
    return "Xin chào \(name)"
}
print(greet("An"))      // Xin chào An
```

Cấu trúc: `{ (tham số) -> KiểuTrả về in thân_hàm }`. Từ khóa `in` ngăn cách phần khai báo và thân.

## Rút gọn dần

```swift
let numbers = [5, 2, 8, 1]

// 1. Đầy đủ
let s1 = numbers.sorted(by: { (a: Int, b: Int) -> Bool in return a < b })

// 2. Bỏ kiểu (Swift tự suy) + bỏ return
let s2 = numbers.sorted(by: { a, b in a < b })

// 3. Dùng tham số ẩn $0, $1
let s3 = numbers.sorted(by: { $0 < $1 })

// 4. Toán tử luôn (gọn nhất)
let s4 = numbers.sorted(by: <)
```

## Trailing closure — closure là tham số cuối

Nếu closure là tham số **cuối cùng**, đưa nó ra ngoài `()`:

```swift
// Thay vì:
numbers.sorted(by: { $0 > $1 })
// Viết:
numbers.sorted { $0 > $1 }
```

> Đây là lý do Button trong SwiftUI viết được `Button("Bấm") { ... }` — phần `{ }` là trailing closure.

## 3 hàm bậc cao quan trọng nhất: map / filter / reduce

```swift
let nums = [1, 2, 3, 4, 5]

// map: biến đổi TỪNG phần tử → mảng mới cùng số lượng
let doubled = nums.map { $0 * 2 }          // [2, 4, 6, 8, 10]
let strings = nums.map { "Số \($0)" }      // ["Số 1", ...]

// filter: GIỮ LẠI phần tử thỏa điều kiện
let evens = nums.filter { $0 % 2 == 0 }    // [2, 4]

// reduce: GỘP tất cả thành 1 giá trị
let sum = nums.reduce(0) { $0 + $1 }       // 15
let product = nums.reduce(1, *)            // 120

// Nối chuỗi các thao tác (chaining)
let result = nums
    .filter { $0 % 2 == 1 }    // [1, 3, 5]
    .map { $0 * 10 }           // [10, 30, 50]
    .reduce(0, +)              // 90
```

Vài hàm hữu ích khác:

```swift
nums.forEach { print($0) }                 // lặp (không trả về)
nums.first { $0 > 3 }                       // Optional(4) — phần tử đầu thỏa
nums.contains { $0 > 4 }                    // true
nums.compactMap { Int("\($0)") }            // map + loại bỏ nil
nums.sorted { $0 > $1 }                     // giảm dần
```

## Capturing — closure "nhớ" biến bên ngoài

Closure giữ tham chiếu đến biến ở phạm vi bao quanh:

```swift
func makeCounter() -> () -> Int {
    var count = 0
    return {
        count += 1       // closure "bắt" và nhớ biến count
        return count
    }
}
let next = makeCounter()
print(next())    // 1
print(next())    // 2  (count được giữ lại giữa các lần gọi)
```

## `@escaping` — closure sống lâu hơn hàm

Khi closure được lưu lại để gọi **sau** (ví dụ callback mạng), phải đánh dấu `@escaping`:

```swift
func fetchData(completion: @escaping (String) -> Void) {
    DispatchQueue.global().async {
        // ... tải dữ liệu ...
        let data = "kết quả"
        completion(data)     // gọi sau, khi hàm đã return
    }
}

fetchData { result in
    print("Nhận: \(result)")
}
```

> `@escaping` báo cho Swift biết closure "thoát" khỏi hàm và chạy về sau. Callback API kiểu cũ hay dùng cái này.
> (Cách hiện đại hơn là `async/await` — xem [08-concurrency.md](08-concurrency.md).)

## Ví dụ thực tế: xử lý danh sách sản phẩm

```swift
struct Product { let name: String; let price: Int; let inStock: Bool }

let products = [
    Product(name: "Áo", price: 200, inStock: true),
    Product(name: "Quần", price: 350, inStock: false),
    Product(name: "Mũ", price: 120, inStock: true)
]

// Tên các sản phẩm còn hàng, sắp theo giá tăng dần
let available = products
    .filter { $0.inStock }
    .sorted { $0.price < $1.price }
    .map { $0.name }
print(available)     // ["Mũ", "Áo"]

// Tổng giá trị kho còn hàng
let totalValue = products
    .filter { $0.inStock }
    .reduce(0) { $0 + $1.price }
print(totalValue)    // 320
```

## Ghi nhớ

- Closure = `{ tham số in thân }`, hàm không tên có thể truyền đi.
- `$0`, `$1` là tham số ẩn; trailing closure đưa `{ }` ra ngoài `()`.
- **map** biến đổi · **filter** lọc · **reduce** gộp — học thuộc 3 cái này.
- `@escaping` cho closure gọi về sau (callback bất đồng bộ).
