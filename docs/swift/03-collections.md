# 03 — Collections: Array (List), Set, Dictionary (Map)

3 kiểu tập hợp cơ bản của Swift. Tất cả đều là **value type** (copy khi gán).

| Ngôn ngữ khác | Swift | Đặc điểm |
|--------------|-------|----------|
| List / mảng | `Array` | Có thứ tự, cho phép trùng, truy cập theo chỉ số |
| Set / tập hợp | `Set` | Không thứ tự, **không** trùng, kiểm tra tồn tại rất nhanh |
| Map / từ điển | `Dictionary` | Cặp key–value, key duy nhất |

---

## 1. Array — mảng (List)

```swift
var fruits = ["Táo", "Cam", "Chuối"]     // [String]
var numbers: [Int] = [1, 2, 3]
var empty: [String] = []                  // mảng rỗng
```

### Truy cập & sửa

```swift
fruits[0]                 // "Táo" (chỉ số bắt đầu từ 0)
fruits.first              // Optional("Táo")
fruits.last               // Optional("Chuối")
fruits.count              // 3
fruits.isEmpty            // false

fruits.append("Xoài")             // thêm cuối
fruits.insert("Lê", at: 1)        // chèn vào vị trí 1
fruits[0] = "Bơ"                  // sửa
fruits.remove(at: 2)              // xóa theo chỉ số
fruits.removeLast()
fruits.contains("Cam")            // true
```

### Duyệt mảng

```swift
for fruit in fruits {
    print(fruit)
}

// Kèm chỉ số
for (index, fruit) in fruits.enumerated() {
    print("\(index): \(fruit)")
}
```

### Các thao tác hữu ích

```swift
let nums = [5, 2, 8, 1]
nums.sorted()              // [1, 2, 5, 8] (trả mảng mới)
nums.reversed()            // 8,1,2,5
nums.max()                 // Optional(8)
nums.min()                 // Optional(1)
nums.reduce(0, +)          // 16 (tổng)
Array(1...5)               // [1,2,3,4,5]
```

> `map`, `filter` sẽ học ở [05-closures.md](05-closures.md).

---

## 2. Set — tập hợp không trùng

```swift
var tags: Set<String> = ["swift", "ios", "swift"]  // "swift" chỉ còn 1
print(tags.count)          // 2

tags.insert("xcode")
tags.remove("ios")
tags.contains("swift")     // true (kiểm tra RẤT nhanh)
```

### Phép toán tập hợp

```swift
let a: Set = [1, 2, 3, 4]
let b: Set = [3, 4, 5, 6]

a.union(b)              // {1,2,3,4,5,6} — hợp
a.intersection(b)       // {3,4} — giao
a.subtracting(b)        // {1,2} — hiệu (a trừ b)
a.isSubset(of: b)       // false
```

> Dùng Set khi cần: **loại trùng**, hoặc **kiểm tra tồn tại nhanh**, và **không quan tâm thứ tự**.

---

## 3. Dictionary — từ điển (Map)

Lưu cặp **key → value**. Key phải duy nhất.

```swift
var scores: [String: Int] = ["An": 9, "Bình": 7]
var empty: [String: Int] = [:]         // rỗng
```

### Truy cập & sửa

```swift
scores["An"]                // Optional(9) — LUÔN là Optional
scores["An"] ?? 0           // 9 (giá trị mặc định nếu không có)

scores["Chi"] = 8           // thêm mới
scores["An"] = 10           // sửa (key đã tồn tại)
scores["Bình"] = nil        // xóa key
scores.count                // số cặp
scores.keys                 // tất cả key
scores.values               // tất cả value
```

> ⚠️ Truy cập `dict[key]` **luôn trả Optional** vì key có thể không tồn tại → nhớ dùng `??` hoặc `if let`.

### Duyệt dictionary

```swift
for (name, score) in scores {
    print("\(name): \(score)")
}

// Chỉ key hoặc chỉ value
for name in scores.keys { print(name) }
```

### Cập nhật an toàn

```swift
// Cộng dồn: nếu chưa có thì bắt đầu từ 0
scores["An", default: 0] += 1
```

---

## Ví dụ tổng hợp: đếm số lần xuất hiện của từ

```swift
let words = ["táo", "cam", "táo", "lê", "cam", "táo"]

// Dùng Dictionary để đếm
var count: [String: Int] = [:]
for word in words {
    count[word, default: 0] += 1
}
print(count)     // ["táo": 3, "cam": 2, "lê": 1]

// Dùng Set để lấy danh sách từ duy nhất
let unique = Set(words)
print(unique.count)   // 3
```

## Ghi nhớ

- **Array** `[T]`: có thứ tự, truy cập `[i]`, cho trùng.
- **Set** `Set<T>`: không trùng, không thứ tự, kiểm tra tồn tại nhanh.
- **Dictionary** `[K: V]`: cặp key–value, truy cập trả **Optional**.
- Tất cả là value type → gán = copy. Cần sửa thì khai báo `var`, không sửa thì `let`.
