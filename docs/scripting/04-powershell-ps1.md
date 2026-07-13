# 04 — PowerShell (`.ps1`)

PowerShell là shell/script **hiện đại của Windows** (cũng chạy được trên macOS/Linux qua
`pwsh`). Khác shell Unix ở chỗ nó truyền **object** giữa các lệnh, không chỉ text.

> Với project iOS, bạn hầu như không cần `.ps1`. Nó hữu ích khi: viết script cho đồng nghiệp
> dùng Windows, hoặc bước CI chạy trên máy Windows.

## Bộ khung cơ bản

```powershell
# bootstrap.ps1 — setup môi trường (Windows)
$ErrorActionPreference = "Stop"   # gặp lỗi thì dừng (giống 'set -e')

Write-Host "==> Đang kiểm tra..."
```

- Không cần shebang. File `.ps1` chạy bằng PowerShell.
- `$ErrorActionPreference = "Stop"` = dừng ngay khi có lỗi (nên đặt ở đầu).

## Cú pháp cốt lõi

```powershell
# Biến bắt đầu bằng $
$name = "AppIos"
Write-Host "Building $name"          # nội suy biến trong "..."

# Cmdlet theo cú pháp Verb-Noun (Động từ-Danh từ)
Get-ChildItem                        # ~ ls
Copy-Item a.txt b.txt                # ~ cp
Remove-Item build -Recurse           # ~ rm -r

# Điều kiện
if (Test-Path "build") {
    Write-Host "đã có build"
} else {
    Write-Host "chưa có"
}

# Vòng lặp
foreach ($f in Get-ChildItem *.txt) {
    Write-Host $f.Name
}

# Hàm & tham số
function Invoke-Build {
    param([string]$Scheme = "AppIos")
    Write-Host "Building $Scheme"
}
Invoke-Build -Scheme "AppIos"
```

## Cách chạy & Execution Policy

Windows mặc định **chặn** chạy script `.ps1` (bảo mật). Mở PowerShell và cho phép:

```powershell
# Cho phép cho phiên hiện tại (an toàn, không đổi hệ thống)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Rồi chạy
.\bootstrap.ps1
```

## Toán tử so sánh (khác kiểu Unix!)

| PowerShell | Ý nghĩa |
|------------|---------|
| `-eq` / `-ne` | bằng / khác |
| `-gt` / `-lt` | lớn hơn / nhỏ hơn |
| `-and` / `-or` / `-not` | và / hoặc / phủ định |

> ⚠️ KHÔNG dùng `==`, `>`, `<` để so sánh — `>` trong PowerShell nghĩa là **ghi ra file**.

## Pitfalls (lỗi thường gặp)

1. **Không chạy được** — do Execution Policy chặn. Xem lệnh `Set-ExecutionPolicy` ở trên.
2. **Nhầm toán tử** — dùng `-eq` chứ không phải `==`; `>` là redirect chứ không phải "lớn hơn".
3. **Đường dẫn có dấu cách** — bọc trong `"..."`.
4. **Encoding** — lưu file dạng UTF-8; ký tự lạ có thể gây lỗi phân tích.
