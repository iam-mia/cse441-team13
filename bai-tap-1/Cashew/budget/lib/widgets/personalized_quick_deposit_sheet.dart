import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/struct/savings_planner_calculator.dart';
import 'package:budget/widgets/globalSnackbar.dart';
import 'package:budget/widgets/openSnackbar.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Bottom sheet nạp nhanh tiền vào mục tiêu tiết kiệm cá nhân hóa
class PersonalizedQuickDepositSheet extends StatefulWidget {
  final Objective objective;
  final VoidCallback? onDepositSuccess;

  const PersonalizedQuickDepositSheet({
    super.key,
    required this.objective,
    this.onDepositSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required Objective objective,
    VoidCallback? onDepositSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PersonalizedQuickDepositSheet(
        objective: objective,
        onDepositSuccess: onDepositSuccess,
      ),
    );
  }

  @override
  State<PersonalizedQuickDepositSheet> createState() =>
      _PersonalizedQuickDepositSheetState();
}

class _PersonalizedQuickDepositSheetState
    extends State<PersonalizedQuickDepositSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  double? _selectedAmount;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectChip(double amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toInt().toString();
    });
  }

  Future<void> _submitDeposit() async {
    final rawText =
        _amountController.text.replaceAll(',', '').replaceAll('.', '').trim();
    final amount = double.tryParse(rawText);

    if (amount == null || amount <= 0) {
      openSnackbar(
        SnackbarMessage(
          title: 'Số tiền không hợp lệ',
          description: 'Vui lòng chọn hoặc nhập số tiền muốn nạp vào mục tiêu.',
          icon: Icons.error_outline_rounded,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final note = _noteController.text.trim();
      final memo = note.isEmpty ? 'Tích lũy: ${widget.objective.name}' : note;
      final categories = await database.getAllCategories();
      final defaultCategoryPk =
          categories.isNotEmpty ? categories.first.categoryPk : '0';

      await database.createOrUpdateTransaction(
        insert: true,
        Transaction(
          transactionPk: '-1',
          name: 'Nạp quỹ: ${widget.objective.name}',
          note: memo,
          amount: amount.abs() * (widget.objective.income ? 1 : -1),
          categoryFk: defaultCategoryPk,
          walletFk: widget.objective.walletFk,
          dateCreated: DateTime.now(),
          income: widget.objective.income,
          paid: true,
          skipPaid: false,
          type: null,
          objectiveFk: widget.objective.objectivePk,
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onDepositSuccess?.call();
        final wallets = Provider.of<AllWallets>(context, listen: false);
        openSnackbar(
          SnackbarMessage(
            title: 'Nạp quỹ thành công! 🎉',
            description:
                'Đã nạp ${convertToMoney(wallets, amount)} vào "${widget.objective.name}".',
            icon: Icons.check_circle_rounded,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        openSnackbar(
          SnackbarMessage(
            title: 'Lỗi khi nạp tiền',
            description: e.toString(),
            icon: Icons.error_outline_rounded,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final wallets = Provider.of<AllWallets>(context);
    final suggestions = SavingsPlannerCalculator.getQuickDepositSuggestions(
      widget.objective.amount,
    );
    final Color accentColor = HexColor(widget.objective.colour,
        defaultColor: theme.colorScheme.primary);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child:
                      Icon(Icons.savings_rounded, color: accentColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextFont(
                        text: 'Nạp nhanh vào mục tiêu',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      TextFont(
                        text: widget.objective.name,
                        fontSize: 13,
                        textColor: getColor(context, 'black').withOpacity(0.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: suggestions.map((amt) {
                final isSelected = _selectedAmount == amt;
                return ChoiceChip(
                  label: TextFont(
                    text: '+ ${convertToMoney(wallets, amt)}',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    textColor:
                        isSelected ? Colors.white : getColor(context, 'black'),
                  ),
                  selected: isSelected,
                  selectedColor: accentColor,
                  backgroundColor: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (selected) {
                    if (selected) _selectChip(amt);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Số tiền tuỳ chỉnh',
                prefixIcon: const Icon(Icons.payments_outlined),
                suffixText:
                    wallets.list.isNotEmpty ? wallets.list.first.currency : 'đ',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() => _selectedAmount = double.tryParse(val));
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Ghi chú động viên (tuỳ chọn)',
                prefixIcon: const Icon(Icons.edit_note_rounded),
                hintText: 'VD: Thưởng tuần làm việc chăm chỉ',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitDeposit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const TextFont(
                        text: 'Xác nhận nạp quỹ 🚀',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        textColor: Colors.white,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
