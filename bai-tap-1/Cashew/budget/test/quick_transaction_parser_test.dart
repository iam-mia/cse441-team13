import 'package:flutter_test/flutter_test.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/struct/quick_transaction_parser.dart';

void main() {
  final List<TransactionCategory> testCategories = [
    TransactionCategory(
      categoryPk: '1',
      name: 'Ăn uống',
      colour: null,
      iconName: null,
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 0,
      income: false,
    ),
    TransactionCategory(
      categoryPk: '2',
      name: 'Đi chợ',
      colour: null,
      iconName: null,
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 1,
      income: false,
    ),
    TransactionCategory(
      categoryPk: '3',
      name: 'Mua sắm',
      colour: null,
      iconName: null,
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 2,
      income: false,
    ),
    TransactionCategory(
      categoryPk: '4',
      name: 'Di chuyển',
      colour: null,
      iconName: null,
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 3,
      income: false,
    ),
    TransactionCategory(
      categoryPk: '6',
      name: 'Hóa đơn',
      colour: null,
      iconName: null,
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 5,
      income: false,
    ),
    TransactionCategory(
      categoryPk: '11',
      name: 'Lương & Thu nhập',
      colour: null,
      iconName: null,
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 10,
      income: true,
    ),
  ];

  group('QuickTransactionParser Tests', () {
    test('Ăn bún riêu 35k', () {
      final res = QuickTransactionParser.parse('ăn bún riêu 35k', testCategories);
      expect(res, isNotNull);
      expect(res!.amount, 35000);
      expect(res.title, 'Ăn bún riêu');
      expect(res.isIncome, false);
      expect(res.matchedCategory?.categoryPk, '1'); // Dining / Ăn uống
    });

    test('35k ăn bún riêu (số tiền đứng đầu)', () {
      final res = QuickTransactionParser.parse('35k ăn bún riêu', testCategories);
      expect(res, isNotNull);
      expect(res!.amount, 35000);
      expect(res.title, 'Ăn bún riêu');
      expect(res.isIncome, false);
      expect(res.matchedCategory?.categoryPk, '1');
    });

    test('Đổ xăng 50.000', () {
      final res = QuickTransactionParser.parse('đổ xăng 50.000', testCategories);
      expect(res, isNotNull);
      expect(res!.amount, 50000);
      expect(res.title, 'Đổ xăng');
      expect(res.isIncome, false);
      expect(res.matchedCategory?.categoryPk, '4'); // Transit
    });

    test('Mua áo sơ mi 250k', () {
      final res = QuickTransactionParser.parse('mua áo sơ mi 250k', testCategories);
      expect(res, isNotNull);
      expect(res!.amount, 250000);
      expect(res.title, 'Mua áo sơ mi');
      expect(res.isIncome, false);
      expect(res.matchedCategory?.categoryPk, '3'); // Shopping
    });

    test('Nhận lương 15tr', () {
      final res = QuickTransactionParser.parse('nhận lương 15tr', testCategories);
      expect(res, isNotNull);
      expect(res!.amount, 15000000);
      expect(res.title, 'Nhận lương');
      expect(res.isIncome, true);
      expect(res.matchedCategory?.categoryPk, '11'); // Income
    });

    test('Tiền điện 650 ngàn', () {
      final res = QuickTransactionParser.parse('tiền điện 650 ngàn', testCategories);
      expect(res, isNotNull);
      expect(res!.amount, 650000);
      expect(res.title, 'Tiền điện');
      expect(res.isIncome, false);
      expect(res.matchedCategory?.categoryPk, '6'); // Bills & Fees
    });
  });
}
