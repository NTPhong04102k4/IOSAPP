# 07 — Form Controls (Toggle, Picker, Slider, Stepper, DatePicker)

Các control cho người dùng chọn/điều chỉnh giá trị. Tất cả đều cần 1 biến `@State` + binding `$`.

## Toggle — công tắc bật/tắt (Bool)

```swift
@State private var isOn = false

Toggle("Nhận thông báo", isOn: $isOn)
    .tint(.green)      // màu khi bật
```

## Picker — chọn 1 trong nhiều lựa chọn

```swift
@State private var selected = "Nam"
let options = ["Nam", "Nữ", "Khác"]

Picker("Giới tính", selection: $selected) {
    ForEach(options, id: \.self) { option in
        Text(option).tag(option)   // tag phải khớp kiểu của selection
    }
}
.pickerStyle(.segmented)   // .menu, .wheel, .inline
```

Các `pickerStyle`:
- `.segmented` — thanh chia đoạn (như UISegmentedControl).
- `.menu` — bấm hiện menu thả xuống.
- `.wheel` — bánh xe cuộn.
- `.inline` — hiển thị thẳng trong List/Form.

## Slider — kéo chọn số trong khoảng

```swift
@State private var volume = 50.0

Slider(value: $volume, in: 0...100, step: 1)
Text("Âm lượng: \(Int(volume))")
```

## Stepper — tăng/giảm bằng nút +/−

```swift
@State private var quantity = 1

Stepper("Số lượng: \(quantity)", value: $quantity, in: 1...10)
```

## DatePicker — chọn ngày/giờ

```swift
@State private var date = Date()

DatePicker("Ngày sinh", selection: $date, displayedComponents: .date)
    .datePickerStyle(.compact)   // .graphical (lịch), .wheel
```

`displayedComponents`: `.date`, `.hourAndMinute`, hoặc cả hai `[.date, .hourAndMinute]`.

## Form — container gom các control lại (giao diện Settings)

`Form` tự tạo giao diện dạng "cài đặt" đẹp, gộp control thành từng nhóm:

```swift
Form {
    Section("Tài khoản") {
        TextField("Tên", text: $name)
        Toggle("Công khai hồ sơ", isOn: $isPublic)
    }
    Section("Tùy chọn") {
        Picker("Ngôn ngữ", selection: $lang) { ... }
        Stepper("Cỡ chữ: \(size)", value: $size, in: 12...24)
    }
}
```

## Ví dụ: màn hình Cài đặt hoàn chỉnh

```swift
import SwiftUI

struct SettingsDemo: View {
    @State private var name = ""
    @State private var notifications = true
    @State private var gender = "Nam"
    @State private var volume = 60.0
    @State private var quantity = 1
    @State private var birthday = Date()

    let genders = ["Nam", "Nữ", "Khác"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Thông tin") {
                    TextField("Họ tên", text: $name)
                    Picker("Giới tính", selection: $gender) {
                        ForEach(genders, id: \.self) { Text($0) }
                    }
                    DatePicker("Ngày sinh", selection: $birthday,
                               displayedComponents: .date)
                }

                Section("Tùy chọn") {
                    Toggle("Bật thông báo", isOn: $notifications)
                    HStack {
                        Text("Âm lượng")
                        Slider(value: $volume, in: 0...100)
                        Text("\(Int(volume))")
                    }
                    Stepper("Số thiết bị: \(quantity)", value: $quantity, in: 1...5)
                }
            }
            .navigationTitle("Cài đặt")
        }
    }
}

#Preview {
    SettingsDemo()
}
```

## Ghi nhớ

- Mọi control đều cần `@State` + truyền `$biến`.
- `Toggle` ↔ `Bool`; `Slider`/`Stepper` ↔ số; `Picker` ↔ giá trị được chọn; `DatePicker` ↔ `Date`.
- Bọc trong `Form` để có giao diện cài đặt gọn gàng, tự động.
- Picker cần `.tag()` khớp kiểu với `selection` (lỗi hay gặp khi không chọn được).
