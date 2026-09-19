# CSE441 - Lập Trình Mobile (Flutter) - Nhóm 13

## 📱 Giới thiệu

Repository chung của **Nhóm 13** môn **CSE441 - Lập Trình Di Động**, sử dụng **Flutter** framework.  
Đây là nơi lưu trữ và quản lý các bài tập nhóm trong suốt học kỳ.

## 👥 Thành viên nhóm

| MSSV | Họ và Tên | Vai trò |
|------|-----------|---------|
| 2351170574 | Phùng Minh Anh | 🎯 Nhóm trưởng |
| 2251172456 | Phạm Văn Phước | Thành viên |
| 2351170570 | Ngô Tuấn Anh | Thành viên |
| 2351170616 | Nguyễn Đình Tuấn Sơn | Thành viên |

## 📂 Cấu trúc thư mục

```
cse441-team13/
├── README.md                  # Mô tả dự án
├── .gitignore                 # Loại bỏ tệp không cần thiết
├── CONTRIBUTING.md            # Quy trình đóng góp code & Pull Request
└── <tên_bài_tập>/            # Thư mục cho từng bài tập
    ├── lib/                   # Source code chính
    ├── test/                  # Unit test
    ├── pubspec.yaml           # Dependencies
    └── ...
```

## 🛠️ Yêu cầu hệ thống

- **Flutter SDK**: >= 3.x
- **Dart SDK**: >= 3.x
- **IDE**: Android Studio / VS Code (có cài Flutter & Dart extension)
- **Git**: >= 2.x

## 🚀 Hướng dẫn cài đặt

### 1. Cài đặt Flutter SDK

Tải và cài đặt Flutter SDK từ [flutter.dev](https://flutter.dev/docs/get-started/install).

Kiểm tra cài đặt:
```bash
flutter doctor
```

### 2. Clone repository

```bash
git clone https://github.com/<username>/cse441-team13.git
cd cse441-team13
```

### 3. Cài đặt dependencies cho từng bài tập

```bash
cd <tên_bài_tập>
flutter pub get
```

### 4. Chạy ứng dụng

```bash
flutter run
```

## 📋 Quy trình làm việc

> ⚠️ **Bắt buộc đọc** [CONTRIBUTING.md](./CONTRIBUTING.md) trước khi bắt đầu code.

1. **Tạo nhánh mới** từ `main` theo quy tắc đặt tên
2. **Code & commit** theo convention
3. **Tạo Pull Request** và chờ review
4. **Merge** sau khi được approve

## 📝 Commit Convention

```
<type>(<scope>): <mô tả ngắn>

Ví dụ:
feat(bai-tap-1): thêm màn hình đăng nhập
fix(bai-tap-2): sửa lỗi crash khi nhấn nút submit
docs: cập nhật README
```

| Type | Mô tả |
|------|-------|
| `feat` | Tính năng mới |
| `fix` | Sửa lỗi |
| `docs` | Thay đổi tài liệu |
| `style` | Format code, không ảnh hưởng logic |
| `refactor` | Tái cấu trúc code |
| `test` | Thêm/sửa test |
| `chore` | Cập nhật build, config |

## 📄 License

Dự án này phục vụ mục đích học tập tại trường Đại học.

---

*Nhóm 13 - CSE441 - Lập Trình Di Động*
