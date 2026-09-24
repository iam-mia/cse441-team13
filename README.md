# CSE441 - Lập Trình Mobile (Flutter) - Nhóm 13

## 📱 Giới thiệu

Repository chung của **Nhóm 13** môn **CSE441 - Lập Trình Di Động**.  
Đây là nơi lưu trữ và quản lý tất cả các bài tập nhóm trong suốt học kỳ.

- **Môn học**: CSE441 - Lập Trình Di Động
- **Framework**: Flutter & Dart
- **Mô hình repo**: Monorepo — mỗi bài tập là một thư mục riêng, mỗi thành viên có workspace độc lập bên trong

## 👥 Thành viên nhóm

| MSSV | Họ và Tên | Vai trò |
|------|-----------|---------|
| 2351170574 | Phùng Minh Anh | 🎯 Nhóm trưởng |
| 2251172456 | Phạm Văn Phước | Thành viên |
| 2351170570 | Ngô Tuấn Anh | Thành viên |
| 2351170616 | Nguyễn Đình Tuấn Sơn | Thành viên |

## 📂 Cấu trúc thư mục

```text
cse441-team13/
├── README.md                     # Thông tin dự án (file này)
├── CONTRIBUTING.md               # Quy trình làm việc & hướng dẫn cho AI Agent
├── .gitignore                    # Loại bỏ tệp không cần thiết
│
├── bai-tap-1/                    # Bài tập 1 — Cashew
│   ├── 2351170574/               # Phùng Minh Anh
│   ├── 2251172456/               # Phạm Văn Phước
│   ├── 2351170570/               # Ngô Tuấn Anh
│   └── 2351170616/               # Nguyễn Đình Tuấn Sơn
│
├── bai-tap-2/                    # Bài tập 2 (sắp tới)
│   └── ...
│
└── ...                           # Các bài tập tiếp theo
```

> Mỗi thư mục `bai-tap-X/<MSSV>/` là một **Flutter project độc lập** với cấu trúc chuẩn (`lib/`, `test/`, `pubspec.yaml`...).

## 📝 Danh sách bài tập

| # | Tên bài tập | Mô tả | Trạng thái |
|---|-------------|-------|------------|
| 1 | **Cashew** | Ứng dụng quản lý tài chính cá nhân | 🟡 Đang thực hiện |
| 2 | *(Cập nhật sau)* | — | 🔲 Chưa bắt đầu |
| 3 | *(Cập nhật sau)* | — | 🔲 Chưa bắt đầu |

### 📌 Bài tập 1 — Cashew

- **Tên**: Cashew
- **Thư mục**: [`bai-tap-1/`](./bai-tap-1/)
- **Mỗi thành viên** tạo Flutter project trong thư mục MSSV của mình:
  - `bai-tap-1/2351170574/` — Phùng Minh Anh
  - `bai-tap-1/2251172456/` — Phạm Văn Phước
  - `bai-tap-1/2351170570/` — Ngô Tuấn Anh
  - `bai-tap-1/2351170616/` — Nguyễn Đình Tuấn Sơn

## 🛠️ Yêu cầu hệ thống

| Công cụ | Phiên bản |
|---------|-----------|
| Flutter SDK | >= 3.x |
| Dart SDK | >= 3.x |
| IDE | Android Studio / VS Code (cài Flutter & Dart extension) |
| Git | >= 2.x |

## 🚀 Hướng dẫn cài đặt & chạy

### 1. Cài đặt Flutter SDK

Tải và cài đặt từ [flutter.dev](https://flutter.dev/docs/get-started/install), sau đó kiểm tra:

```bash
flutter doctor
```

### 2. Clone repository

```bash
git clone https://github.com/iam-mia/cse441-team13.git
cd cse441-team13
```

### 3. Chạy bài tập của một thành viên

```bash
cd bai-tap-1/2351170574       # Ví dụ: bài tập 1, thành viên Phùng Minh Anh
flutter pub get
flutter run
```

> ⚠️ **Lưu ý**: Luôn `cd` vào đúng thư mục thành viên trước khi chạy lệnh Flutter. **KHÔNG** chạy `flutter` ở thư mục root.

## 📋 Quy trình làm việc

> **Bắt buộc đọc** [CONTRIBUTING.md](./CONTRIBUTING.md) trước khi bắt đầu code.

Tóm tắt quy trình:

1. Cập nhật `main` mới nhất
2. Tạo nhánh mới theo format: `<bai-tap-X>/<MSSV>`
3. Code trong đúng workspace của mình: `bai-tap-X/<MSSV>/`
4. Commit theo convention, push nhánh
5. Tạo Pull Request → Chờ review → Merge

## 📄 License

Dự án này phục vụ mục đích học tập tại trường Đại học.

---

*Nhóm 13 - CSE441 - Lập Trình Di Động*
