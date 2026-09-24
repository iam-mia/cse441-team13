# CSE441 - Lập Trình Mobile (Flutter) - Nhóm 13

## 📱 Giới thiệu

Repository chung của **Nhóm 13** môn **CSE441 - Lập Trình Di Động**.  
Đây là nơi lưu trữ và quản lý tất cả các bài tập nhóm trong suốt học kỳ.

- **Môn học**: CSE441 - Lập Trình Di Động
- **Framework**: Flutter & Dart
- **Mô hình repo**: Monorepo — mỗi bài tập là một thư mục chứa Flutter project chung, các thành viên cùng phát triển trên cùng codebase

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
├── README.md                         # Thông tin dự án (file này)
├── CONTRIBUTING.md                   # Quy trình làm việc & hướng dẫn cho AI Agent
├── .gitignore                        # Loại bỏ tệp không cần thiết
│
├── bai-tap-1/                        # Bài tập 1 — Cashew (1 Flutter project chung)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   ├── screens/
│   │   ├── widgets/
│   │   ├── services/
│   │   ├── utils/
│   │   └── theme/
│   ├── test/
│   ├── assets/
│   └── pubspec.yaml
│
├── bai-tap-2/                        # Bài tập 2 (sắp tới)
│   └── ...
│
└── ...
```

> Mỗi thư mục `bai-tap-X/` là **1 Flutter project chung** — tất cả thành viên cùng làm việc trên cùng codebase, mỗi người phụ trách chức năng riêng.

## 📝 Danh sách bài tập

| # | Tên bài tập | Mô tả | Trạng thái |
|---|-------------|-------|------------|
| 1 | **Cashew** | Ứng dụng quản lý tài chính cá nhân | 🟡 Đang thực hiện |
| 2 | *(Cập nhật sau)* | — | 🔲 Chưa bắt đầu |
| 3 | *(Cập nhật sau)* | — | 🔲 Chưa bắt đầu |

---

### 📌 Bài tập 1 — Cashew

**Cashew** là ứng dụng quản lý tài chính cá nhân được xây dựng bằng Flutter. App giúp người dùng theo dõi chi tiêu, lập ngân sách, quản lý các tài khoản và đặt mục tiêu tiết kiệm.

- **Thư mục**: [`bai-tap-1/`](./bai-tap-1/)
- **Kiểu làm việc**: 1 project chung — mỗi thành viên phụ trách 1 nhóm chức năng

#### 🔧 Phân chia chức năng theo thành viên

| Thành viên | MSSV | Chức năng phụ trách | Mô tả chi tiết |
|------------|------|---------------------|-----------------|
| **Phùng Minh Anh** | 2351170574 | 🏠 **Trang chủ & Giao dịch** | Màn hình chính (dashboard), thêm/sửa/xóa giao dịch thu chi, danh sách giao dịch, tìm kiếm & lọc giao dịch |
| **Phạm Văn Phước** | 2251172456 | 💰 **Ngân sách (Budgets)** | Tạo/sửa/xóa ngân sách theo kỳ (tuần/tháng), đặt giới hạn chi tiêu theo danh mục, theo dõi tiến độ ngân sách, lịch sử ngân sách |
| **Ngô Tuấn Anh** | 2351170570 | 🏦 **Tài khoản & Mục tiêu tiết kiệm** | Quản lý tài khoản (ngân hàng, tiền mặt, thẻ tín dụng), chuyển khoản giữa tài khoản, tạo/theo dõi mục tiêu tiết kiệm, tổng quan tài sản ròng |
| **Nguyễn Đình Tuấn Sơn** | 2351170616 | 📊 **Thống kê & Cài đặt** | Biểu đồ thống kê (pie chart, bar chart), so sánh chi tiêu theo thời gian, quản lý danh mục giao dịch, cài đặt app (theme, tiền tệ, sao lưu dữ liệu) |

#### 📁 Phân chia file/thư mục theo chức năng

```text
bai-tap-1/lib/
├── main.dart                              # [Chung] Entry point
├── models/
│   ├── transaction_model.dart             # [Minh Anh] Model giao dịch
│   ├── budget_model.dart                  # [Văn Phước] Model ngân sách
│   ├── account_model.dart                 # [Tuấn Anh] Model tài khoản
│   ├── goal_model.dart                    # [Tuấn Anh] Model mục tiêu tiết kiệm
│   └── category_model.dart               # [Tuấn Sơn] Model danh mục
│
├── screens/
│   ├── home_screen.dart                   # [Minh Anh] Dashboard trang chủ
│   ├── transaction_screen.dart            # [Minh Anh] Danh sách giao dịch
│   ├── add_transaction_screen.dart        # [Minh Anh] Thêm/sửa giao dịch
│   ├── budget_screen.dart                 # [Văn Phước] Danh sách ngân sách
│   ├── add_budget_screen.dart             # [Văn Phước] Thêm/sửa ngân sách
│   ├── budget_detail_screen.dart          # [Văn Phước] Chi tiết ngân sách
│   ├── account_screen.dart                # [Tuấn Anh] Danh sách tài khoản
│   ├── account_detail_screen.dart         # [Tuấn Anh] Chi tiết tài khoản
│   ├── goal_screen.dart                   # [Tuấn Anh] Mục tiêu tiết kiệm
│   ├── statistics_screen.dart             # [Tuấn Sơn] Thống kê & biểu đồ
│   ├── category_screen.dart               # [Tuấn Sơn] Quản lý danh mục
│   └── settings_screen.dart               # [Tuấn Sơn] Cài đặt
│
├── widgets/                               # [Chung] Widget tái sử dụng
│   ├── transaction_card.dart              # [Minh Anh]
│   ├── budget_progress_bar.dart           # [Văn Phước]
│   ├── account_card.dart                  # [Tuấn Anh]
│   ├── chart_widget.dart                  # [Tuấn Sơn]
│   └── ...
│
├── services/
│   ├── transaction_service.dart           # [Minh Anh] CRUD giao dịch
│   ├── budget_service.dart                # [Văn Phước] CRUD ngân sách
│   ├── account_service.dart               # [Tuấn Anh] CRUD tài khoản
│   ├── statistics_service.dart            # [Tuấn Sơn] Tính toán thống kê
│   └── backup_service.dart                # [Tuấn Sơn] Sao lưu dữ liệu
│
├── utils/
│   ├── constants.dart                     # [Chung] Hằng số
│   ├── helpers.dart                       # [Chung] Tiện ích
│   └── currency_formatter.dart            # [Chung] Format tiền tệ
│
└── theme/
    └── app_theme.dart                     # [Tuấn Sơn] Theme & styling
```

#### ⚠️ Lưu ý khi làm việc

- Mỗi thành viên **chỉ chỉnh sửa file trong phạm vi chức năng** của mình
- File **`[Chung]`** (main.dart, constants, helpers...): trao đổi trước khi sửa, tránh conflict
- Tạo nhánh theo format: `bai-tap-1/<MSSV>` (ví dụ: `bai-tap-1/2351170574`)
- Đọc [CONTRIBUTING.md](./CONTRIBUTING.md) để nắm quy trình PR & commit convention

---

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

### 3. Chạy bài tập

```bash
cd bai-tap-1
flutter pub get
flutter run
```

> ⚠️ **Lưu ý**: Luôn `cd` vào thư mục bài tập trước khi chạy lệnh Flutter. **KHÔNG** chạy `flutter` ở thư mục root.

## 📋 Quy trình làm việc

> **Bắt buộc đọc** [CONTRIBUTING.md](./CONTRIBUTING.md) trước khi bắt đầu code.

Tóm tắt quy trình:

1. Cập nhật `main` mới nhất
2. Tạo nhánh mới theo format: `bai-tap-X/<MSSV>`
3. Code trong đúng phạm vi chức năng được phân công
4. Commit theo convention, push nhánh
5. Tạo Pull Request → Chờ review → Merge

## 📄 License

Dự án này phục vụ mục đích học tập tại trường Đại học.

---

*Nhóm 13 - CSE441 - Lập Trình Di Động*
