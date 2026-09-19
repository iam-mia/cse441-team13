# 📋 CONTRIBUTING.md — Quy Trình Đóng Góp Code & Kiểm Soát Chất Lượng

> **⚠️ QUAN TRỌNG**: Tất cả thành viên (và AI code assistant) **BẮT BUỘC** phải đọc và tuân thủ tài liệu này trước khi viết bất kỳ dòng code nào.

---

## 📌 Mục lục

1. [Quy tắc chung](#1-quy-tắc-chung)
2. [Quy trình làm việc với Git](#2-quy-trình-làm-việc-với-git)
3. [Quy tắc đặt tên nhánh](#3-quy-tắc-đặt-tên-nhánh)
4. [Quy tắc commit](#4-quy-tắc-commit)
5. [Quy trình Pull Request](#5-quy-trình-pull-request)
6. [Checklist trước khi tạo PR](#6-checklist-trước-khi-tạo-pr)
7. [Quy tắc code Flutter / Dart](#7-quy-tắc-code-flutter--dart)
8. [Hướng dẫn cho AI Code Assistant](#8-hướng-dẫn-cho-ai-code-assistant)
9. [Review & Merge](#9-review--merge)
10. [Xử lý conflict](#10-xử-lý-conflict)

---

## 1. Quy tắc chung

- **KHÔNG push trực tiếp lên nhánh `main`**. Mọi thay đổi phải thông qua Pull Request.
- **KHÔNG commit các file được liệt kê trong `.gitignore`** (build, IDE config, secrets...).
- **Mỗi PR chỉ giải quyết MỘT vấn đề** (1 feature / 1 bug fix / 1 refactor).
- **Code phải build thành công** (`flutter build`) trước khi tạo PR.
- **Viết comment bằng tiếng Việt hoặc tiếng Anh** — nhất quán trong cùng một file.

---

## 2. Quy trình làm việc với Git

```
main (nhánh chính, luôn ổn định)
 │
 ├── feature/bai-tap-1/login-screen    (Nhánh tính năng)
 ├── fix/bai-tap-1/null-pointer        (Nhánh sửa lỗi)
 └── docs/update-readme                (Nhánh tài liệu)
```

### Quy trình từng bước:

```bash
# 1. Cập nhật main mới nhất
git checkout main
git pull origin main

# 2. Tạo nhánh mới
git checkout -b feature/bai-tap-X/ten-tinh-nang

# 3. Code và commit theo từng phần nhỏ
git add .
git commit -m "feat(bai-tap-X): mô tả ngắn gọn"

# 4. Push nhánh lên remote
git push origin feature/bai-tap-X/ten-tinh-nang

# 5. Tạo Pull Request trên GitHub
# 6. Chờ review → fix feedback → merge
```

---

## 3. Quy tắc đặt tên nhánh

**Format**: `<type>/<scope>/<mô-tả-ngắn>`

| Type | Mục đích | Ví dụ |
|------|----------|-------|
| `feature/` | Tính năng mới | `feature/bai-tap-1/login-screen` |
| `fix/` | Sửa lỗi | `fix/bai-tap-2/crash-on-submit` |
| `refactor/` | Tái cấu trúc | `refactor/bai-tap-1/clean-up-widgets` |
| `docs/` | Tài liệu | `docs/update-contributing` |
| `test/` | Viết test | `test/bai-tap-1/unit-test-login` |

**Lưu ý**:
- Dùng chữ thường, phân cách bằng dấu gạch ngang `-`
- Không dùng ký tự đặc biệt, dấu tiếng Việt
- Tên nhánh phải mô tả rõ công việc đang làm

---

## 4. Quy tắc commit

### Format

```
<type>(<scope>): <mô tả ngắn gọn>

[Body - tùy chọn: giải thích chi tiết]

[Footer - tùy chọn: breaking changes, issue references]
```

### Các type được sử dụng

| Type | Ý nghĩa | Ví dụ |
|------|----------|-------|
| `feat` | Thêm tính năng mới | `feat(bai-tap-1): thêm form đăng nhập` |
| `fix` | Sửa lỗi | `fix(bai-tap-1): sửa lỗi validate email` |
| `docs` | Cập nhật tài liệu | `docs: thêm hướng dẫn cài đặt` |
| `style` | Format code (không thay đổi logic) | `style(bai-tap-1): format theo lint rules` |
| `refactor` | Tái cấu trúc (không thay đổi behavior) | `refactor(bai-tap-2): tách widget` |
| `test` | Thêm hoặc sửa test | `test(bai-tap-1): unit test cho AuthService` |
| `chore` | Config, build, dependencies | `chore: cập nhật pubspec.yaml` |

### Quy tắc:
- Mô tả ngắn gọn, không quá 72 ký tự
- Viết ở thì hiện tại: "thêm" (không phải "đã thêm")
- Không kết thúc bằng dấu chấm

---

## 5. Quy trình Pull Request

### Tiêu đề PR

```
[<Type>] <Bài tập> - <Mô tả ngắn>

Ví dụ:
[Feature] Bài tập 1 - Màn hình đăng nhập
[Fix] Bài tập 2 - Sửa lỗi crash khi submit form
[Refactor] Bài tập 1 - Tách widget cho màn hình chính
```

### Template mô tả PR

Khi tạo PR, điền đầy đủ theo template sau:

```markdown
## 📝 Mô tả
<!-- Mô tả ngắn gọn thay đổi của bạn -->

## 🔗 Liên kết
<!-- Issue hoặc task liên quan (nếu có) -->

## 📸 Screenshots / Video
<!-- Đính kèm ảnh/video demo nếu có thay đổi UI -->

## ✅ Checklist
- [ ] Code build thành công (`flutter build`)
- [ ] Đã test trên emulator/thiết bị thật
- [ ] Không có warning từ `flutter analyze`
- [ ] Commit message theo đúng convention
- [ ] Tên nhánh đúng format
- [ ] Không chứa file thừa (build, IDE config...)
- [ ] Đã viết comment cho các hàm phức tạp
- [ ] (Nếu thay đổi UI) Đã đính kèm screenshot

## 🧪 Cách test
<!-- Hướng dẫn cụ thể để reviewer có thể test -->
1. Chạy `flutter pub get`
2. Chạy `flutter run`
3. ...

## 📌 Ghi chú
<!-- Bất kỳ ghi chú nào cho reviewer -->
```

---

## 6. Checklist trước khi tạo PR

Trước khi tạo PR, **BẮT BUỘC** kiểm tra:

```bash
# 1. Kiểm tra code analysis
flutter analyze

# 2. Đảm bảo build thành công
flutter build apk --debug   # Android
# hoặc
flutter build ios --debug    # iOS (macOS only)

# 3. Format code
dart format .

# 4. Chạy test (nếu có)
flutter test

# 5. Kiểm tra không có file thừa
git status
git diff --stat
```

### ❌ PR sẽ bị REJECT nếu:
- Push trực tiếp lên `main`
- Code không build được
- Có warning/error từ `flutter analyze`
- Commit message không đúng convention
- PR chứa nhiều feature không liên quan
- Không có mô tả hoặc mô tả quá sơ sài
- Chứa file không cần thiết (build, .idea, .vscode...)
- Code không được format (`dart format`)

---

## 7. Quy tắc code Flutter / Dart

### 7.1 Cấu trúc thư mục cho mỗi bài tập

```
bai_tap_X/
├── lib/
│   ├── main.dart              # Entry point
│   ├── models/                # Data models
│   │   └── user_model.dart
│   ├── screens/               # Các màn hình
│   │   ├── home_screen.dart
│   │   └── login_screen.dart
│   ├── widgets/               # Widget tái sử dụng
│   │   ├── custom_button.dart
│   │   └── input_field.dart
│   ├── services/              # Logic xử lý (API, DB...)
│   │   └── auth_service.dart
│   ├── utils/                 # Tiện ích, hằng số
│   │   ├── constants.dart
│   │   └── helpers.dart
│   └── theme/                 # Theme & styling
│       └── app_theme.dart
├── test/                      # Unit & widget tests
├── assets/                    # Hình ảnh, fonts...
└── pubspec.yaml
```

### 7.2 Quy tắc đặt tên

| Loại | Convention | Ví dụ |
|------|-----------|-------|
| File | `snake_case` | `login_screen.dart` |
| Class | `PascalCase` | `LoginScreen` |
| Biến, hàm | `camelCase` | `userName`, `getUserData()` |
| Hằng số | `camelCase` hoặc `SCREAMING_SNAKE_CASE` | `maxRetries`, `API_BASE_URL` |
| Widget | `PascalCase` | `CustomButton` |
| Enum | `PascalCase` (value: `camelCase`) | `UserRole.admin` |

### 7.3 Quy tắc viết Widget

```dart
// ✅ TỐT: Widget nhỏ, rõ ràng, tái sử dụng
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// ❌ XẤU: Widget quá lớn, chứa tất cả logic
class MyScreen extends StatefulWidget {
  // ... 500 dòng code trong một widget
}
```

### 7.4 Quy tắc khác

- **Mỗi file chỉ chứa 1 widget/class chính** (có thể có private helper class)
- **Tối đa 300 dòng / file**. Nếu vượt quá, tách thành widget nhỏ hơn
- **Dùng `const` constructor** khi có thể
- **Tránh magic numbers** — dùng hằng số có tên rõ ràng
- **Comment cho logic phức tạp**, không comment cho code hiển nhiên
- **Sử dụng `final`** cho biến không thay đổi
- **Tránh nested widget quá sâu** (tối đa 4-5 cấp)

---

## 8. Hướng dẫn cho AI Code Assistant

> 🤖 **Phần này dành cho AI tools (GitHub Copilot, Gemini, ChatGPT, Claude, Cursor, v.v.).**
> Khi thành viên sử dụng AI để sinh code, AI **PHẢI** tuân thủ các quy tắc sau:

### 8.1 Quy tắc BẮT BUỘC cho AI

1. **Đọc CONTRIBUTING.md trước khi code**
   - AI phải hiểu quy trình, convention và cấu trúc thư mục của dự án
   - Không sinh code trái với các quy tắc đã đặt ra

2. **Tuân thủ cấu trúc thư mục**
   - Đặt file đúng thư mục: `models/`, `screens/`, `widgets/`, `services/`, `utils/`
   - Không tạo file ở vị trí tùy tiện

3. **Tuân thủ naming convention**
   - File: `snake_case.dart`
   - Class: `PascalCase`
   - Variables/Functions: `camelCase`

4. **Sinh code theo module nhỏ**
   - Mỗi lần sinh code chỉ xử lý **1 feature / 1 fix** cụ thể
   - Không sinh toàn bộ ứng dụng trong 1 lần
   - Mỗi file tối đa 300 dòng

5. **Commit message theo convention**
   ```
   <type>(<scope>): <mô tả>
   ```

6. **Không sinh code chứa**:
   - API keys, secrets, passwords hardcode
   - File config IDE (.idea, .vscode)
   - Build artifacts
   - Code thừa, không sử dụng (dead code)
   - `print()` debug — dùng logging thay thế

7. **Luôn kiểm tra trước khi suggest push**:
   ```bash
   flutter analyze    # Không error/warning
   dart format .      # Code đã format
   flutter build      # Build thành công
   flutter test       # Test pass (nếu có)
   ```

### 8.2 Quy trình AI sinh code → Push

```
┌─────────────────────────────────────────────────┐
│  BƯỚC 1: Hiểu yêu cầu                          │
│  - Đọc CONTRIBUTING.md                          │
│  - Xác định scope (bài tập nào, feature nào)    │
│  - Xác định các file cần tạo/sửa               │
└─────────────────┬───────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────┐
│  BƯỚC 2: Cập nhật nhánh                         │
│  git checkout main && git pull origin main       │
│  git checkout -b <type>/<scope>/<mô-tả>         │
└─────────────────┬───────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────┐
│  BƯỚC 3: Sinh code                              │
│  - Tuân thủ cấu trúc thư mục                   │
│  - Tuân thủ naming convention                   │
│  - Mỗi file ≤ 300 dòng                         │
│  - Tách widget, tách logic rõ ràng              │
└─────────────────┬───────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────┐
│  BƯỚC 4: Kiểm tra chất lượng                    │
│  flutter analyze   ← Không error/warning        │
│  dart format .     ← Code đã format             │
│  flutter build     ← Build thành công            │
│  flutter test      ← Test pass                   │
└─────────────────┬───────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────┐
│  BƯỚC 5: Commit & Push                          │
│  git add <specific-files>  ← KHÔNG dùng git add .│
│  git commit -m "<type>(<scope>): <mô tả>"       │
│  git push origin <tên-nhánh>                     │
└─────────────────┬───────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────┐
│  BƯỚC 6: Tạo Pull Request                       │
│  - Điền đầy đủ theo PR template                 │
│  - Đính kèm screenshot nếu thay đổi UI         │
│  - Chờ review từ nhóm trưởng/thành viên khác    │
└─────────────────────────────────────────────────┘
```

### 8.3 Template cho AI khi tạo commit

```bash
# Feature mới
git commit -m "feat(bai-tap-X): thêm [tên tính năng]

- Tạo [tên file] với chức năng [mô tả]
- Thêm [widget/service/model] cho [mục đích]
- Tuân thủ CONTRIBUTING.md"

# Sửa lỗi
git commit -m "fix(bai-tap-X): sửa lỗi [mô tả lỗi]

- Nguyên nhân: [giải thích]
- Giải pháp: [mô tả cách sửa]"
```

### 8.4 Những điều AI KHÔNG ĐƯỢC làm

| ❌ Không được | ✅ Thay vào đó |
|--------------|----------------|
| Push trực tiếp lên `main` | Tạo nhánh mới → PR |
| Commit tất cả bằng `git add .` | `git add <file-cụ-thể>` |
| Sinh toàn bộ app 1 lần | Sinh từng module nhỏ |
| Bỏ qua lint/analyze | Chạy `flutter analyze` trước |
| Hardcode strings/colors | Dùng constants/theme |
| Nested widget > 5 cấp | Tách thành widget riêng |
| Để `print()` trong code | Dùng `debugPrint()` hoặc logger |
| Tạo file không đúng thư mục | Theo cấu trúc `lib/` đã quy định |
| Commit message tiếng Việt không dấu lộn xộn | Theo convention đã quy định |

---

## 9. Review & Merge

### Ai review?
- **Nhóm trưởng (Phùng Minh Anh)**: Review và approve tất cả PR
- **Thành viên khác**: Có thể review nhưng cần ít nhất **1 approval từ nhóm trưởng** để merge

### Tiêu chí review
- [ ] Code đúng convention
- [ ] Cấu trúc thư mục hợp lý
- [ ] Không có code thừa
- [ ] `flutter analyze` không có warning
- [ ] Commit message đúng format
- [ ] PR description đầy đủ
- [ ] UI hiển thị đúng (nếu có thay đổi UI)
- [ ] Không ảnh hưởng code của bài tập khác

### Quy trình merge
1. PR được tạo → Assign reviewer (nhóm trưởng)
2. Reviewer kiểm tra theo tiêu chí trên
3. Nếu cần sửa → Comment cụ thể → Author fix → Push lại
4. Khi đạt yêu cầu → Approve → **Squash and Merge**
5. Xóa nhánh sau khi merge

---

## 10. Xử lý conflict

```bash
# 1. Cập nhật main
git checkout main
git pull origin main

# 2. Quay lại nhánh của bạn
git checkout <tên-nhánh-của-bạn>

# 3. Rebase lên main
git rebase main

# 4. Xử lý conflict (nếu có)
# - Mở file conflict
# - Giữ code đúng, xóa markers (<<<<, ====, >>>>)
# - git add <file-đã-resolve>
# - git rebase --continue

# 5. Push lại (force push vì đã rebase)
git push origin <tên-nhánh> --force-with-lease
```

> ⚠️ **Lưu ý**: Luôn dùng `--force-with-lease` thay vì `--force` để tránh ghi đè code của người khác.

---

*Cập nhật lần cuối: Tháng 9/2026*
