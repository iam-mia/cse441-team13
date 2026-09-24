import 'package:budget/database/tables.dart';

/// Kết quả phân tích cú pháp từ câu nhập tự nhiên của người dùng
class ParsedQuickTransaction {
  final String rawText;
  final String title;
  final double amount;
  final bool isIncome;
  final String matchedCategoryKey;
  final TransactionCategory? matchedCategory;

  const ParsedQuickTransaction({
    required this.rawText,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.matchedCategoryKey,
    this.matchedCategory,
  });

  @override
  String toString() {
    return 'ParsedQuickTransaction(title: $title, amount: $amount, isIncome: $isIncome, category: ${matchedCategory?.name ?? matchedCategoryKey})';
  }
}

/// Bộ phân tích ngôn ngữ tự nhiên (NLP) dựa trên Regex & Từ điển tiếng Việt
class QuickTransactionParser {
  /// Loại bỏ dấu tiếng Việt để so khớp không phân biệt dấu
  static String removeDiacritics(String str) {
    var withDiacritics =
        'áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ'
        'ÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴĐ';
    var withoutDiacritics =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd'
        'AAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';

    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str.toLowerCase();
  }

  /// Từ khóa thu nhập
  static final List<String> _incomeKeywords = [
    'luong',
    'thoa',
    'thuong',
    'nhan',
    'thu',
    'ban',
    'hoan tien',
    'duoc cho',
    'duoc tang',
    'lai',
    'co tuc',
    'bonus',
    'salary',
    'income',
    'tien ve',
    'trung thuong',
    'freelance',
    'hoa hong',
  ];

  /// Từ điển phân loại danh mục theo từ khóa
  static final Map<String, List<String>> _categoryKeywords = {
    // 1: Dining / Ăn uống
    'dining': [
      'an',
      'uong',
      'bun',
      'pho',
      'com',
      'banh',
      'rieu',
      'bo',
      'ga',
      'thit',
      'ca',
      'rau',
      'cafe',
      'ca phe',
      'tra',
      'tra sua',
      'lau',
      'nuong',
      'pizza',
      'kfc',
      'lotteria',
      'mi',
      'mien',
      'chao',
      'che',
      'bua sang',
      'bua trua',
      'bua toi',
      'nhau',
      'an vat',
      'snack',
      'kem',
      'food',
      'dining',
      'coffee',
      'drink',
      'buffet',
      'bia',
      'ruou',
      'quan',
      'banh mi',
      'highlands',
      'phuc long',
      'starbucks',
    ],
    // 2: Groceries / Đi chợ, Thực phẩm
    'groceries': [
      'cho',
      'di cho',
      'sieu thi',
      'bach hoa',
      'mua do an',
      'thit heo',
      'trung',
      'sua',
      'rau cu',
      'gia vi',
      'gao',
      'groceries',
      'market',
      'winmart',
      'coopmart',
    ],
    // 3: Shopping / Mua sắm
    'shopping': [
      'mua',
      'ao',
      'quan',
      'giay',
      'dep',
      'tui',
      'vi',
      'my pham',
      'son',
      'shopee',
      'lazada',
      'tiki',
      'do dung',
      'shopping',
      'quan ao',
      'vay',
      'store',
      'order',
      'dong ho',
      'phu kien',
    ],
    // 4: Transit / Giao thông, Di chuyển
    'transit': [
      'xang',
      'do xang',
      'xe',
      'gui xe',
      'grab',
      'be',
      'gojek',
      'taxi',
      'xe bus',
      'xe buyt',
      've xe',
      'rua xe',
      'sua xe',
      'bao duong',
      'thay nhot',
      'cau duong',
      'bot',
      'transit',
      'transport',
      'petrol',
    ],
    // 5: Entertainment / Giải trí
    'entertainment': [
      'xem phim',
      'cinema',
      'rap',
      've phim',
      'cgv',
      'bhd',
      'lotte',
      'netflix',
      'spotify',
      'game',
      'nap game',
      'du lich',
      'karaoke',
      'bida',
      'entertainment',
      'boardgame',
    ],
    // 6: Bills & Fees / Hóa đơn & Tiện ích
    'bills-fees': [
      'tien dien',
      'dien',
      'tien nuoc',
      'nuoc',
      'tien mang',
      'internet',
      'wifi',
      'tien nha',
      'thue nha',
      'tien phong',
      'nap dien thoai',
      'cuoc',
      'gas',
      'bills',
      'fee',
      'hoa don',
      'chung cu',
      'dich vu',
      'nap the',
    ],
    // 7: Gifts / Quà tặng & Hiếu hỷ
    'gifts': [
      'qua',
      'mung cuoi',
      'dam cuoi',
      'sinh nhat',
      'li xi',
      'bieu',
      'gift',
      'tu thien',
      'ung ho',
    ],
    // 8: Beauty / Làm đẹp & Sức khỏe
    'beauty': [
      'cat toc',
      'spa',
      'lam mong',
      'nail',
      'massage',
      'skincare',
      'thuoc',
      'kham benh',
      'benh vien',
      'bac si',
      'nha khoa',
      'gym',
      'yoga',
      'beauty',
      'health',
    ],
    // 9: Work / Công việc
    'work': [
      'cong viec',
      'van phong',
      'in an',
      'photo',
      'work',
      'van phong pham',
      'office',
    ],
    // 10: Travel / Du lịch
    'travel': [
      'du lich',
      'khach san',
      've may bay',
      'homestay',
      'resort',
      'travel',
      'tour',
      've tau',
    ],
    // 11: Income / Lương & Thu nhập
    'income': [
      'luong',
      'thuong',
      'tien luong',
      'freelance',
      'ban hang',
      'co tuc',
      'salary',
      'income',
      'hoa hong',
      'part-time',
    ],
  };

  /// Phân tích văn bản tự nhiên thành thông tin giao dịch
  static ParsedQuickTransaction? parse(
    String rawInput,
    List<TransactionCategory> availableCategories,
  ) {
    final text = rawInput.trim();
    if (text.isEmpty) return null;

    // 1. REGEX TÌM SỐ TIỀN VÀ ĐƠN VỊ
    // Hỗ trợ: 35k, 35.5k, 35,5k, 35000, 35.000, 15tr, 15 triệu, 50 nghìn, 50k đ, 50000 vnd...
    final RegExp amountRegex = RegExp(
      r'(?:\b|\s|^)(\d+(?:[.,]\d+)?)\s*(k|nghìn|ngàn|ng|tr|triệu|trieu|m|củ|cu|lít|lit|vnd|đồng|dong|đ)?(?:\b|\s|$)',
      caseSensitive: false,
    );

    final Iterable<RegExpMatch> matches = amountRegex.allMatches(text);
    if (matches.isEmpty) return null;

    // Ưu tiên match có đơn vị tiền tệ rõ ràng, hoặc match cuối cùng
    RegExpMatch match = matches.last;
    for (final m in matches) {
      final u = m.group(2);
      if (u != null && u.trim().isNotEmpty) {
        match = m;
        break;
      }
    }

    final String rawNumber = match.group(1) ?? '0';
    final String unit = (match.group(2) ?? '').toLowerCase().trim();

    double calculatedAmount = 0;
    final normalizedNumberStr = rawNumber.replaceAll(',', '.');

    if (unit == 'k' || unit == 'nghìn' || unit == 'ngàn' || unit == 'ng') {
      final val = double.tryParse(normalizedNumberStr) ?? 0;
      calculatedAmount = val * 1000;
    } else if (unit == 'tr' ||
        unit == 'triệu' ||
        unit == 'trieu' ||
        unit == 'm' ||
        unit == 'củ' ||
        unit == 'cu') {
      final val = double.tryParse(normalizedNumberStr) ?? 0;
      calculatedAmount = val * 1000000;
    } else if (unit == 'lít' || unit == 'lit') {
      final val = double.tryParse(normalizedNumberStr) ?? 0;
      calculatedAmount = val * 100000;
    } else {
      // Không có đơn vị rõ ràng hoặc là vnd/đ
      if (rawNumber.contains('.') || rawNumber.contains(',')) {
        final clean = rawNumber.replaceAll('.', '').replaceAll(',', '');
        calculatedAmount = double.tryParse(clean) ?? 0;
      } else {
        final val = double.tryParse(rawNumber) ?? 0;
        // Nếu số nhỏ hơn 500 và > 0 trong ngữ cảnh người Việt nói tắt (vd: "bún riêu 35")
        if (val > 0 && val < 500) {
          calculatedAmount = val * 1000;
        } else {
          calculatedAmount = val;
        }
      }
    }

    // 2. TRÍCH XUẤT TÊN GIAO DỊCH (LOẠI BỎ PHẦN SỐ TIỀN)
    final int start = match.start;
    final int end = match.end;
    String title =
        ('${text.substring(0, start)} ${text.substring(end)}').trim();

    // Làm sạch ký tự thừa: dấu gạch ngang, hai chấm, khoảng trắng thừa
    title = title.replaceAll(RegExp(r'\s+'), ' ').trim();
    title = title.replaceAll(RegExp(r'^[-:,]+|[-:,]+$'), '').trim();

    if (title.isEmpty) {
      title = 'Giao dịch';
    } else {
      // Viết hoa chữ cái đầu tiên
      title = title[0].toUpperCase() + title.substring(1);
    }

    // 3. XÁC ĐỊNH LOẠI THU NHẬP (INCOME) HAY CHI PHÍ (EXPENSE)
    final String normalizedTitle = removeDiacritics(title);
    bool isIncome = false;
    for (final kw in _incomeKeywords) {
      if (RegExp(r'\b' + kw + r'\b').hasMatch(normalizedTitle)) {
        isIncome = true;
        break;
      }
    }

    // 4. TỪ ĐIỂN PHÂN LOẠI DANH MỤC (CATEGORY MAPPING)
    String bestCategoryKey = isIncome ? 'income' : 'dining';
    int maxKeywordScore = 0;

    for (final entry in _categoryKeywords.entries) {
      final categoryKey = entry.key;
      final keywords = entry.value;

      // Nếu đang là thu nhập, ưu tiên tìm nhóm income
      if (isIncome && categoryKey != 'income') continue;

      int score = 0;
      for (final kw in keywords) {
        if (RegExp(r'\b' + kw + r'\b').hasMatch(normalizedTitle)) {
          // Từ khóa dài hơn cho điểm cao hơn (ví dụ "bun rieu" > "an")
          score += kw.length;
        }
      }

      if (score > maxKeywordScore) {
        maxKeywordScore = score;
        bestCategoryKey = categoryKey;
      }
    }

    // 5. KHỚP VỚI DANH MỤC TRONG DATABASE (TransactionCategory)
    TransactionCategory? matchedCategory;

    // Bước 5.1: Tìm danh mục trong DB có tên khớp trực tiếp với từ trong title
    for (final cat in availableCategories) {
      final normCatName = removeDiacritics(cat.name);
      if (normCatName.isNotEmpty &&
          normalizedTitle.contains(normCatName) &&
          cat.income == isIncome) {
        matchedCategory = cat;
        break;
      }
    }

    // Bước 5.2: Khớp theo từ điển với categoryPk chuẩn của Cashew
    if (matchedCategory == null) {
      final Map<String, String> keyToPk = {
        'dining': '1',
        'groceries': '2',
        'shopping': '3',
        'transit': '4',
        'entertainment': '5',
        'bills-fees': '6',
        'gifts': '7',
        'beauty': '8',
        'work': '9',
        'travel': '10',
        'income': '11',
      };

      final targetPk = keyToPk[bestCategoryKey];
      if (targetPk != null) {
        for (final cat in availableCategories) {
          if (cat.categoryPk == targetPk) {
            matchedCategory = cat;
            break;
          }
        }
      }
    }

    // Bước 5.3: Khớp theo tên nhóm danh mục tiếng Việt thông dụng
    if (matchedCategory == null) {
      final Map<String, List<String>> vnAliases = {
        'dining': ['ăn uống', 'an uong', 'ăn', 'dining', 'food'],
        'groceries': ['thực phẩm', 'đi chợ', 'di cho', 'groceries'],
        'shopping': ['mua sắm', 'mua sam', 'shopping'],
        'transit': ['di chuyển', 'giao thông', 'xe', 'transit', 'transport'],
        'bills-fees': ['hóa đơn', 'hoa don', 'tiện ích', 'bills', 'fees'],
        'entertainment': ['giải trí', 'giai tri', 'entertainment'],
        'gifts': ['quà tặng', 'qua tang', 'quà', 'gifts'],
        'beauty': ['làm đẹp', 'sức khỏe', 'beauty', 'health'],
        'income': ['thu nhập', 'thu nhap', 'lương', 'salary', 'income'],
      };

      final aliases = vnAliases[bestCategoryKey] ?? [];
      for (final cat in availableCategories) {
        final normCatName = removeDiacritics(cat.name);
        for (final alias in aliases) {
          if (normCatName.contains(removeDiacritics(alias))) {
            matchedCategory = cat;
            break;
          }
        }
        if (matchedCategory != null) break;
      }
    }

    // Bước 5.4: Fallback
    if (matchedCategory == null && availableCategories.isNotEmpty) {
      try {
        matchedCategory = availableCategories.firstWhere(
          (c) => c.income == isIncome && c.categoryPk != '0',
          orElse: () => availableCategories.first,
        );
      } catch (_) {
        matchedCategory = availableCategories.first;
      }
    }

    return ParsedQuickTransaction(
      rawText: text,
      title: title,
      amount: calculatedAmount,
      isIncome: isIncome,
      matchedCategoryKey: bestCategoryKey,
      matchedCategory: matchedCategory,
    );
  }
}
