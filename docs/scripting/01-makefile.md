# 01 — Makefile

`Makefile` giúp gom các lệnh dài (ví dụ `xcodebuild ...`) thành **target** ngắn:
gõ `make build` thay vì nhớ cả dòng lệnh dài.

## Cấu trúc cơ bản

```makefile
target: prerequisites
<TAB>recipe (lệnh shell)
```

- **target**: tên bạn gõ sau `make` (vd `build`).
- **prerequisites**: target khác cần chạy trước (tùy chọn).
- **recipe**: lệnh shell — **BẮT BUỘC thụt đầu dòng bằng TAB thật**, không phải dấu cách.

> ⚠️ Lỗi kinh điển: `Makefile:5: *** missing separator`. Nguyên nhân gần như luôn là
> dùng **dấu cách** thay vì **TAB** ở dòng recipe. Cấu hình editor hiển thị tab để tránh.

## Ví dụ cho project AppIos (macOS/Xcode)

```makefile
# Cấu hình dùng chung (biến)
PROJECT := AppIos.xcodeproj
SCHEME  := AppIos
DEST    := 'platform=iOS Simulator,name=iPhone 17'

# .PHONY = các target KHÔNG phải tên file thật (luôn chạy lại)
.PHONY: help build test clean

# Target đầu tiên = mặc định khi gõ 'make' không tham số
help:                      ## Hiện danh sách lệnh
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	 awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

build:                     ## Build app cho simulator
	xcodebuild build -project $(PROJECT) -scheme $(SCHEME) -destination $(DEST)

test:                      ## Chạy unit test
	xcodebuild test -project $(PROJECT) -scheme $(SCHEME) -destination $(DEST)

clean:                     ## Xóa dữ liệu build
	xcodebuild clean -project $(PROJECT) -scheme $(SCHEME)
```

Chạy:
```bash
make          # = make help (target đầu tiên)
make build
make test
```

## Khái niệm hay dùng

| Cú pháp | Ý nghĩa |
|---------|---------|
| `VAR := value` | Gán biến (dùng lại bằng `$(VAR)`) |
| `.PHONY: build` | Báo "build không phải file" → luôn chạy, không bị bỏ qua |
| `@lệnh` | Dấu `@` = không in dòng lệnh ra, chỉ in kết quả |
| `target: dep` | `dep` chạy trước `target` |
| `$$` | Dấu `$` thật trong recipe (vì Make dùng `$` cho biến của nó) |

## Pitfalls (lỗi thường gặp)

1. **TAB vs dấu cách** — recipe phải bắt đầu bằng TAB (xem cảnh báo trên).
2. **Mỗi dòng recipe chạy trong 1 shell riêng** — `cd a` ở dòng này KHÔNG còn hiệu lực ở dòng sau. Nối bằng `&&` trên cùng 1 dòng: `cd a && ls`.
3. **Target trùng tên file/thư mục** (vd có thư mục tên `test`) → Make tưởng đã "build xong". Khai báo `.PHONY` để tránh.
