import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/struct/savings_planner_calculator.dart';
import 'package:budget/widgets/animatedCircularProgress.dart';
import 'package:budget/widgets/categoryIcon.dart';
import 'package:budget/widgets/countNumber.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:flutter/material.dart';

/// Widget vòng đo tiến độ và thông điệp động viên cá nhân hóa
class PersonalizedGoalGaugeHeader extends StatelessWidget {
  final Objective objective;
  final Color accentColor;
  final SavingsPlanInsight plan;
  final double totalAmount;
  final double targetAmount;
  final AllWallets wallets;

  const PersonalizedGoalGaugeHeader({
    super.key,
    required this.objective,
    required this.accentColor,
    required this.plan,
    required this.totalAmount,
    required this.targetAmount,
    required this.wallets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 170,
                height: 170,
                child: AnimatedCircularProgress(
                  percent: plan.percentage.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.withValues(alpha: 0.15),
                  foregroundColor: accentColor,
                  strokeWidth: 8,
                  valueStrokeWidth: 12,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CategoryIcon(
                    categoryPk: '-1',
                    category: TransactionCategory(
                      categoryPk: '-1',
                      name: '',
                      dateCreated: DateTime.now(),
                      dateTimeModified: null,
                      order: 0,
                      income: false,
                      iconName: objective.iconName,
                      colour: objective.colour,
                      emojiIconName: objective.emojiIconName,
                    ),
                    size: 32,
                    sizePadding: 16,
                    borderRadius: 100,
                  ),
                  const SizedBox(height: 6),
                  CountNumber(
                    count: plan.percentage * 100,
                    duration: const Duration(milliseconds: 900),
                    initialCount: 0,
                    textBuilder: (val) => TextFont(
                      text: '${val.toInt()}%',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFont(
            text:
                '${convertToMoney(wallets, totalAmount)} / ${convertToMoney(wallets, targetAmount)}',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            textColor: accentColor,
          ),
          const SizedBox(height: 4),
          TextFont(
            text: plan.remainingAmount > 0
                ? 'Còn thiếu ${convertToMoney(wallets, plan.remainingAmount)}'
                : 'Mục tiêu đã hoàn tất xuất sắc!',
            fontSize: 13,
            textColor: getColor(context, 'black').withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}
