# 02 — Shell script (`.sh`)

Shell script là file chứa **các lệnh terminal** chạy tuần tự. Trên macOS thường dùng
để: setup dự án (bootstrap), build, dọn dẹp, chạy nhiều lệnh 1 lượt.

## Bộ khung chuẩn

```bash
#!/usr/bin/env bash
# bootstrap.sh — cài đặt & kiểm tra môi trường cho project AppIos
set -euo pipefail            # dừng ngay khi có lỗi (xem giải thích dưới)

echo "==> Kiểm tra Xcode..."
```

- **Dòng 1 (`#!`)** = *shebang*: chỉ định trình thông dịch. `#!/usr/bin/env bash` là chuẩn, di động nhất.
- **`set -euo pipefail`** — bật "chế độ an toàn":
  - `-e`: gặp lệnh lỗi → dừng ngay.
  - `-u`: dùng biến chưa khai báo → báo lỗi (tránh gõ sai tên biến).
  - `-o pipefail`: trong `a | b`, nếu `a` lỗi thì cả pipe coi như lỗi.

## Cách chạy

```bash
chmod +x Scripts/bootstrap.sh   # cấp quyền chạy (1 lần)
./Scripts/bootstrap.sh          # chạy
# hoặc không cần chmod:
bash Scripts/bootstrap.sh
```

## Cú pháp cốt lõi

```bash
# Biến — KHÔNG có dấu cách quanh dấu =
name="AppIos"
echo "Building $name"           # dùng bằng $name; nên bọc "..."

# Điều kiện
if [[ -d "build" ]]; then       # -d: thư mục tồn tại?
  echo "đã có build"
else
  echo "chưa có"
fi

# Vòng lặp
for file in *.swift; do
  echo "found $file"
done

# Hàm
run_tests() {
  xcodebuild test -scheme AppIos
}
run_tests
```

Vài kiểm tra `[[ ... ]]` hay dùng: `-f` (file tồn tại), `-d` (thư mục), `-z "$x"` (chuỗi rỗng), `-n "$x"` (không rỗng).

## Ví dụ hoàn chỉnh — `Scripts/bootstrap.sh`

```bash
#!/usr/bin/env bash
# Kiểm tra môi trường build cho AppIos
set -euo pipefail

echo "==> Kiểm tra xcodebuild..."
if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "❌ Chưa cài Xcode command line tools. Chạy: xcode-select --install" >&2
  exit 1
fi

echo "==> Build thử..."
xcodebuild build -scheme AppIos -destination 'platform=iOS Simulator,name=iPhone 17'
echo "✅ Xong."
```

## Pitfalls (lỗi thường gặp)

1. **Quên bọc `"..."` quanh biến** — đường dẫn có dấu cách sẽ vỡ: `rm $path` ❌ → `rm "$path"` ✅.
2. **Dấu cách quanh `=`** — `name = "x"` ❌ (shell tưởng `name` là lệnh). Phải `name="x"`.
3. **Không có `set -e`** — script chạy tiếp dù lệnh trước lỗi → hậu quả khó lường.
4. **In lỗi ra stdout** — nên in lỗi ra stderr: `echo "lỗi" >&2` rồi `exit 1`.
5. **CRLF (xuống dòng kiểu Windows)** — file `.sh` phải dùng LF, nếu không sẽ báo `bad interpreter`.
