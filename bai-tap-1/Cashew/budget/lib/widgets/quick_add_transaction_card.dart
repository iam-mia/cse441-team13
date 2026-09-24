import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/struct/quick_transaction_parser.dart';
import 'package:budget/widgets/globalSnackbar.dart';
import 'package:budget/widgets/openSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget thẻ Thêm nhanh giao dịch bằng ngôn ngữ tự nhiên (NLP + Regex + Từ điển)
class QuickAddTransactionCard extends StatefulWidget {
  final List<TransactionCategory> categories;
  final Function(ParsedQuickTransaction parsed) onApply;

  const QuickAddTransactionCard({
    Key? key,
    required this.categories,
    required this.onApply,
  }) : super(key: key);

  @override
  State<QuickAddTransactionCard> createState() =>
      _QuickAddTransactionCardState();
}

class _QuickAddTransactionCardState extends State<QuickAddTransactionCard> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ParsedQuickTransaction? _currentParsed;
  bool _isExpanded = true;

  final List<String> _quickExamples = [
    'ăn bún riêu 35k',
    'cà phê 25k',
    'đổ xăng 50k',
    'mua áo 200k',
    'nhận lương 15tr',
    'tiền điện 650 ngàn',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (text.trim().isEmpty) {
      setState(() {
        _currentParsed = null;
      });
      return;
    }

    final result = QuickTransactionParser.parse(text, widget.categories);
    setState(() {
      _currentParsed = result;
    });
  }

  void _applyResult() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final result = QuickTransactionParser.parse(text, widget.categories);
    if (result != null) {
      widget.onApply(result);
      final walletData = Provider.of<AllWallets>(context, listen: false);
      openSnackbar(
        SnackbarMessage(
          title: 'Đã nhận diện & điền dữ liệu',
          description:
              '${result.title} • ${convertToMoney(walletData, result.amount)} • ${result.matchedCategory?.name ?? result.matchedCategoryKey}',
          icon: Icons.check_circle_rounded,
        ),
      );
    } else {
      openSnackbar(
        SnackbarMessage(
          title: 'Chưa nhận diện được số tiền',
          description: 'Vui lòng nhập kèm số tiền (VD: 35k, 50.000, 15tr...)',
          icon: Icons.info_outline_rounded,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.4),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _currentParsed != null
                ? colorScheme.primary.withOpacity(0.6)
                : colorScheme.outline.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.bolt_rounded,
                        color: Colors.amber.shade800,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thêm nhanh bằng ngôn ngữ tự nhiên',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Nhập 1 câu, app tự phân loại danh mục & số tiền',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),

            if (_isExpanded) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ô nhập liệu chính
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            onChanged: _onTextChanged,
                            onSubmitted: (_) => _applyResult(),
                            decoration: InputDecoration(
                              hintText: 'VD: ăn bún riêu 35k...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurfaceVariant
                                    .withOpacity(0.6),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              filled: true,
                              fillColor: colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                  width: 1.8,
                                ),
                              ),
                              suffixIcon: _controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () {
                                        _controller.clear();
                                        _onTextChanged('');
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _applyResult,
                          icon:
                              const Icon(Icons.auto_fix_high_rounded, size: 18),
                          label: const Text('Áp dụng'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Gợi ý mẫu (Quick chips)
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _quickExamples.map((example) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ActionChip(
                              label: Text(
                                example,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.2),
                                ),
                              ),
                              onPressed: () {
                                _controller.text = example;
                                _controller.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(offset: example.length),
                                );
                                _onTextChanged(example);
                                _applyResult();
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Preview kết quả nhận diện
                    if (_currentParsed != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Kết quả phân tích tự động:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _buildBadge(
                                  icon: Icons.title_rounded,
                                  label: 'Tên: ${_currentParsed!.title}',
                                  color: Colors.blue,
                                ),
                                _buildBadge(
                                  icon: Icons.monetization_on_rounded,
                                  label:
                                      'Tiền: ${_currentParsed!.amount.toInt()} đ',
                                  color: Colors.green,
                                ),
                                _buildBadge(
                                  icon: Icons.category_rounded,
                                  label:
                                      'Danh mục: ${_currentParsed!.matchedCategory?.name ?? _currentParsed!.matchedCategoryKey}',
                                  color: Colors.purple,
                                ),
                                _buildBadge(
                                  icon: _currentParsed!.isIncome
                                      ? Icons.arrow_downward_rounded
                                      : Icons.arrow_upward_rounded,
                                  label: _currentParsed!.isIncome
                                      ? 'Thu nhập'
                                      : 'Chi phí',
                                  color: _currentParsed!.isIncome
                                      ? Colors.teal
                                      : Colors.orange,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color.shade800),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
