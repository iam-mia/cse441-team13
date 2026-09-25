import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/pages/addObjectivePage.dart';
import 'package:budget/pages/objectivesListPage.dart';
import 'package:budget/pages/personalized_goal_detail_page.dart';
import 'package:budget/struct/savings_planner_calculator.dart';
import 'package:budget/widgets/categoryIcon.dart';
import 'package:budget/widgets/openContainerNavigation.dart';
import 'package:budget/widgets/openPopup.dart';
import 'package:budget/widgets/personalized_quick_deposit_sheet.dart';
import 'package:budget/widgets/tappable.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Thẻ mục tiêu tiết kiệm mang phong cách cá nhân hóa và gamified
class PersonalizedGoalCard extends StatelessWidget {
  final Objective objective;
  final int index;
  final double? forcedTotalAmount;

  const PersonalizedGoalCard({
    super.key,
    required this.objective,
    required this.index,
    this.forcedTotalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final wallets = Provider.of<AllWallets>(context);
    final Color primaryAccent = HexColor(
      objective.colour,
      defaultColor: theme.colorScheme.primary,
    );

    return WatchTotalAndAmountOfObjective(
      objective: objective,
      builder: (objectiveAmount, totalAmount, percentageTowardsGoal) {
        if (forcedTotalAmount != null) {
          totalAmount = forcedTotalAmount!;
        }
        final plan = SavingsPlannerCalculator.calculate(
          objective: objective,
          currentAmount: totalAmount,
        );
        final percentDisplay = (plan.percentage * 100).toInt();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryAccent.withValues(alpha: isDark ? 0.28 : 0.14),
                isDark
                    ? theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5)
                    : Colors.white,
              ],
            ),
            border: Border.all(
              color: primaryAccent.withValues(alpha: isDark ? 0.35 : 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryAccent.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: OpenContainerNavigation(
            openPage:
                PersonalizedGoalDetailPage(objectivePk: objective.objectivePk),
            borderRadius: 24,
            closedColor: Colors.transparent,
            button: (openContainer) => Tappable(
              color: Colors.transparent,
              borderRadius: 24,
              onTap: openContainer,
              onLongPress: () {
                pushRoute(
                  context,
                  AddObjectivePage(
                    routesToPopAfterDelete: RoutesToPopAfterDelete.One,
                    objective: objective,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          sizePadding: 20,
                          borderRadius: 100,
                          canEditByLongPress: false,
                          margin: EdgeInsetsDirectional.zero,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFont(
                                text: objective.name,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 3),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: primaryAccent.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFont(
                                  text: plan.paceStatusLabel,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  textColor: primaryAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Nạp quỹ nhanh',
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: primaryAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          onPressed: () {
                            PersonalizedQuickDepositSheet.show(
                              context,
                              objective: objective,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFont(
                              text: 'Đã tích lũy',
                              fontSize: 12,
                              textColor: getColor(context, 'black')
                                  .withValues(alpha: 0.55),
                            ),
                            const SizedBox(height: 2),
                            TextFont(
                              text: convertToMoney(wallets, totalAmount),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              textColor: primaryAccent,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFont(
                              text: 'Mục tiêu',
                              fontSize: 12,
                              textColor: getColor(context, 'black')
                                  .withValues(alpha: 0.55),
                            ),
                            const SizedBox(height: 2),
                            TextFont(
                              text: convertToMoney(wallets, objectiveAmount),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              textColor: getColor(context, 'black')
                                  .withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildMilestoneBar(plan.percentage, primaryAccent),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFont(
                          text: '$percentDisplay% hoàn thành',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          textColor: primaryAccent,
                        ),
                        if (plan.dailyRequiredAmount != null &&
                            plan.dailyRequiredAmount! > 0)
                          TextFont(
                            text:
                                'Cần ${convertToMoney(wallets, plan.dailyRequiredAmount!)}/ngày',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            textColor: getColor(context, 'black')
                                .withValues(alpha: 0.65),
                          )
                        else if (plan.daysRemaining != null)
                          TextFont(
                            text: 'Còn ${plan.daysRemaining} ngày',
                            fontSize: 12,
                            textColor: getColor(context, 'black')
                                .withValues(alpha: 0.65),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMilestoneBar(double percentage, Color accentColor) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        FractionallySizedBox(
          widthFactor: percentage.clamp(0.0, 1.0),
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.7),
                  accentColor,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.4),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
