import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/struct/savings_planner_calculator.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget hiển thị Lộ trình tích lũy cá nhân hóa (Gamified Milestone Roadmap)
class PersonalizedGoalMilestones extends StatelessWidget {
  final List<GoalMilestone> milestones;
  final Color accentColor;
  final double currentAmount;

  const PersonalizedGoalMilestones({
    Key? key,
    required this.milestones,
    required this.accentColor,
    required this.currentAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wallets = Provider.of<AllWallets>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text: 'Lộ trình cột mốc cá nhân',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textColor: getColor(context, 'black'),
                    ),
                    const SizedBox(height: 2),
                    TextFont(
                      text: 'Từng nấc thang đưa bạn đến thành công',
                      fontSize: 12,
                      textColor: getColor(context, 'black').withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < milestones.length; i++)
            _buildMilestoneRow(
              context: context,
              milestone: milestones[i],
              isLast: i == milestones.length - 1,
              wallets: wallets,
            ),
        ],
      ),
    );
  }

  Widget _buildMilestoneRow({
    required BuildContext context,
    required GoalMilestone milestone,
    required bool isLast,
    required AllWallets wallets,
  }) {
    final reached = milestone.isReached;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: reached ? accentColor : Colors.grey.withOpacity(0.2),
                  boxShadow: reached
                      ? [
                          BoxShadow(
                            color: accentColor.withOpacity(0.35),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: reached
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 18)
                      : Text(
                          '${(milestone.percentage * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: getColor(context, 'black').withOpacity(0.55),
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.5,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: reached
                          ? accentColor.withOpacity(0.6)
                          : Colors.grey.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        milestone.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextFont(
                          text: milestone.title,
                          fontSize: 14,
                          fontWeight:
                              reached ? FontWeight.bold : FontWeight.w600,
                          textColor: reached
                              ? getColor(context, 'black')
                              : getColor(context, 'black').withOpacity(0.6),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: reached
                              ? accentColor.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFont(
                          text: convertToMoney(wallets, milestone.targetAmount),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          textColor: reached
                              ? accentColor
                              : getColor(context, 'black').withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  TextFont(
                    text: milestone.description,
                    fontSize: 12,
                    textColor: getColor(context, 'black').withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
