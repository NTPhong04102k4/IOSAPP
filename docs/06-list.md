# 06 — List & ForEach

Hiển thị danh sách cuộn được. `List` = danh sách kiểu bảng; `ForEach` = lặp qua dữ liệu để tạo view.

## List tĩnh

```swift
List {
    Text("Mục 1")
    Text("Mục 2")
    Text("Mục 3")
}
```

## List từ mảng dữ liệu

```swift
struct Demo: View {
    let fruits = ["Táo", "Cam", "Chuối", "Xoài"]

    var body: some View {
        List(fruits, id: \.self) { fruit in
            Text(fruit)
        }
    }
}
```

- `id: \.self` bảo SwiftUI dùng chính giá trị để phân biệt từng dòng.
- Với `String`/`Int` thì `\.self` ổn; với struct nên dùng `Identifiable` (bên dưới).

## Dùng struct + Identifiable (khuyến nghị)

```swift
struct Product: Identifiable {
    let id = UUID()        // Identifiable cần có 'id'
    let name: String
    let price: Int
}

struct Demo: View {
    let products = [
        Product(name: "iPhone", price: 25000000),
        Product(name: "iPad", price: 18000000),
        Product(name: "MacBook", price: 45000000)
    ]

    var body: some View {
        List(products) { product in     // không cần id: vì đã Identifiable
            HStack {
                Text(product.name)
                Spacer()
                Text("\(product.price)đ")
                    .foregroundColor(.secondary)
            }
        }
    }
}
```

## ForEach — lặp bên trong Stack hoặc List

`ForEach` không tự cuộn, nó chỉ tạo nhiều view. Đặt trong `List`, `VStack`, `ScrollView`...

```swift
ScrollView {
    VStack(spacing: 12) {
        ForEach(products) { product in
            Text(product.name)
        }
    }
}
```

## Section — nhóm các dòng có tiêu đề

```swift
List {
    Section("Trái cây") {
        Text("Táo")
        Text("Cam")
    }
    Section("Rau củ") {
        Text("Cà rốt")
        Text("Bắp cải")
    }
}
```

## Xóa & di chuyển dòng

```swift
struct Demo: View {
    @State private var items = ["A", "B", "C", "D"]

    var body: some View {
        List {
            ForEach(items, id: \.self) { Text($0) }
                .onDelete { indexSet in
                    items.remove(atOffsets: indexSet)   // vuốt để xóa
                }
                .onMove { from, to in
                    items.move(fromOffsets: from, toOffset: to)
                }
        }
        .toolbar { EditButton() }   // nút Edit để bật chế độ sửa
    }
}
```

## Điều hướng khi bấm dòng (NavigationStack — iOS 16+)

```swift
NavigationStack {
    List(products) { product in
        NavigationLink(product.name) {
            Text("Chi tiết: \(product.name)")   // màn hình đích
        }
    }
    .navigationTitle("Sản phẩm")
}
```

## Kiểu hiển thị List

```swift
List { ... }
    .listStyle(.plain)      // .insetGrouped (mặc định), .grouped, .sidebar
```

## Ví dụ hoàn chỉnh

```swift
import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    let title: String
    var done: Bool
}

struct ListDemo: View {
    @State private var tasks = [
        Task(title: "Học SwiftUI", done: true),
        Task(title: "Làm màn Login", done: false),
        Task(title: "Viết docs", done: false)
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    HStack {
                        Image(systemName: task.done ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.done ? .green : .gray)
                        Text(task.title)
                            .strikethrough(task.done)
                    }
                }
                .onDelete { tasks.remove(atOffsets: $0) }
            }
            .navigationTitle("Công việc")
            .toolbar { EditButton() }
        }
    }
}

#Preview {
    ListDemo()
}
```

## Ghi nhớ

- `List` tự cuộn + có style bảng; `ForEach` chỉ lặp tạo view.
- Dữ liệu nên theo `Identifiable` (có `id`) để SwiftUI theo dõi từng dòng chính xác.
- Muốn danh sách sửa được (xóa/thêm) → data phải là `@State` mảng.
