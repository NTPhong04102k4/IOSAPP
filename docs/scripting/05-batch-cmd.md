# 05 — Batch script (`.cmd` / `.bat`)

Batch là script **cũ, đơn giản** của Windows (Command Prompt). `.cmd` và `.bat` gần như
giống nhau; nên dùng `.cmd` cho script mới. Dùng khi cần script Windows tối giản, không
muốn phụ thuộc PowerShell.

> Với project iOS, phần này chỉ để tham khảo khi làm việc đa nền tảng.

## Bộ khung cơ bản

```bat
@echo off
REM build.cmd — ví dụ script batch
setlocal

echo ==> Bat dau...
```

- **`@echo off`** — tắt việc in lại từng dòng lệnh (dòng đầu tiên nên có).
- **`REM`** hoặc `::` — dòng ghi chú (comment).
- **`setlocal`** — giới hạn phạm vi biến trong script (không rò ra môi trường ngoài).

## Cú pháp cốt lõi

```bat
@echo off
setlocal

REM Biến: KHONG co dau cach quanh =
set NAME=AppIos
echo Building %NAME%               REM dung bien bang %NAME%

REM Dieu kien
if exist build (
    echo da co build
) else (
    echo chua co
)

REM Vong lap qua cac file .txt
for %%f in (*.txt) do (
    echo found %%f
)

REM Goi "ham" bang nhan (label)
call :build AppIos
goto :eof

:build
echo Building %~1
goto :eof
```

- Biến dùng bằng `%TEN%`. Trong vòng lặp, biến chạy là `%%f` (trong file script) hoặc `%f` (gõ trực tiếp).
- `%~1` = tham số thứ nhất truyền vào (bỏ dấu ngoặc kép).
- `:eof` = nhãn kết thúc file có sẵn; `goto :eof` để thoát.

## Cách chạy

```bat
build.cmd
REM hoac double-click trong Explorer
```

## Biến & kiểm tra hay dùng

| Cú pháp | Ý nghĩa |
|---------|---------|
| `%CD%` | Thư mục hiện tại |
| `%~dp0` | Đường dẫn thư mục chứa chính script |
| `if exist "x"` | File/thư mục tồn tại? |
| `if "%A%"=="B"` | So sánh chuỗi (nhớ bọc `"..."`) |
| `%ERRORLEVEL%` | Mã lỗi lệnh vừa chạy (0 = OK) |

## Pitfalls (lỗi thường gặp)

1. **Dấu cách quanh `=`** — `set NAME = AppIos` ❌ sẽ tạo biến tên `NAME ` (có dấu cách). Phải `set NAME=AppIos`.
2. **`%%` vs `%`** — trong file `.cmd` dùng `%%f` cho biến vòng lặp; gõ trực tiếp ngoài terminal thì `%f`.
3. **Không kiểm tra `%ERRORLEVEL%`** — batch không tự dừng khi lỗi; phải tự kiểm tra: `if %ERRORLEVEL% neq 0 exit /b 1`.
4. **Tiếng Việt có dấu** — Command Prompt cũ hay hiển thị sai; nên viết comment không dấu như ví dụ trên.
