import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/pages/addObjectivePage.dart';
import 'package:budget/pages/addTransactionPage.dart';
import 'package:budget/pages/objectivesListPage.dart';
import 'package:budget/pages/transactionFilters.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/struct/savings_planner_calculator.dart';
import 'package:budget/widgets/framework/pageFramework.dart';
import 'package:budget/widgets/openPopup.dart';
import 'package:budget/widgets/personalized_goal_gauge_header.dart';
import 'package:budget/widgets/personalized_goal_milestones.dart';
import 'package:budget/widgets/personalized_quick_deposit_sheet.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:budget/widgets/transactionEntries.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Trang chi tiết mục tiêu tiết kiệm cá nhân hóa
class PersonalizedGoalDetailPage extends StatelessWidget {
  final String objectivePk;

  const PersonalizedGoalDetailPage({
    super.key,
    required this.objectivePk,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Objective>(
      stream: database.getObjective(objectivePk),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final objective = snapshot.data!;
        final Color accent = HexColor(objective.colour,
            defaultColor: Theme.of(context).colorScheme.primary);
        return CustomColorTheme(
          accentColor: accent,
          child: _PersonalizedGoalDetailContent(
              objective: objective, accentColor: accent),
        );
      },
    );
  }
}

class _PersonalizedGoalDetailContent extends StatefulWidget {
  final Objective objective;
  final Color accentColor;

  const _PersonalizedGoalDetailContent({
    required this.objective,
    required this.accentColor,
  });

  @override
  State<_PersonalizedGoalDetailContent> createState() =>
      _PersonalizedGoalDetailContentState();
}

class _PersonalizedGoalDetailContentState
    extends State<_PersonalizedGoalDetailContent> {
  final ConfettiController _confettiController = ConfettiController();
  bool _hasCelebrated = false;

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _triggerCelebration() {
    if (_hasCelebrated) return;
    _hasCelebrated = true;
    _confettiController.play();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _confettiController.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallets = Provider.of<AllWallets>(context);

    return Scaffold(
      body: Stack(
        children: [
          WatchTotalAndAmountOfObjective(
            objective: widget.objective,
            builder: (objectiveAmount, totalAmount, percentageTowardsGoal) {
              if (percentageTowardsGoal >= 1.0) _triggerCelebration();

              final plan = SavingsPlannerCalculator.calculate(
                objective: widget.objective,
                currentAmount: totalAmount,
              );

              return PageFramework(
                title: widget.objective.name,
                dragDownToDismiss: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Chỉnh sửa mục tiêu',
                    onPressed: () {
                      pushRoute(
                        context,
                        AddObjectivePage(
                          objective: widget.objective,
                          routesToPopAfterDelete: RoutesToPopAfterDelete.All,
                        ),
                      );
                    },
                  ),
                ],
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          PersonalizedGoalGaugeHeader(
                            objective: widget.objective,
                            accentColor: widget.accentColor,
                            plan: plan,
                            totalAmount: totalAmount,
                            targetAmount: objectiveAmount,
                            wallets: wallets,
                          ),
                          const SizedBox(height: 16),
                          _buildQuoteBanner(context, plan),
                          const SizedBox(height: 16),
                          _buildPlannerBreakdown(context, plan, wallets),
                          const SizedBox(height: 16),
                          _buildQuickActions(context),
                          const SizedBox(height: 16),
                          PersonalizedGoalMilestones(
                            milestones: plan.milestones,
                            accentColor: widget.accentColor,
                            currentAmount: totalAmount,
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextFont(
                              text: 'Lịch sử tích lũy',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              textColor: getColor(context, 'black'),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  TransactionEntries(
                    null,
                    null,
                    renderType: TransactionEntriesRenderType.sliversNotSticky,
                    searchFilters: SearchFilters()
                        .copyWith(objectivePks: [widget.objective.objectivePk]),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 60)),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 25,
              gravity: 0.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteBanner(BuildContext context, SavingsPlanInsight plan) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('💬', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: TextFont(
              text: plan.motivationalQuote,
              fontSize: 13,
              textColor: getColor(context, 'black').withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlannerBreakdown(
    BuildContext context,
    SavingsPlanInsight plan,
    AllWallets wallets,
  ) {
    if (plan.dailyRequiredAmount == null || plan.dailyRequiredAmount! <= 0) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights_rounded, size: 20, color: widget.accentColor),
              const SizedBox(width: 8),
              const TextFont(
                text: 'Kế hoạch tích lũy thông minh',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metricTile(context, 'Mỗi ngày',
                  convertToMoney(wallets, plan.dailyRequiredAmount!)),
              _metricTile(context, 'Mỗi tuần',
                  convertToMoney(wallets, plan.weeklyRequiredAmount ?? 0)),
              _metricTile(context, 'Còn lại', '${plan.daysRemaining} ngày'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricTile(BuildContext context, String title, String val) => Column(
        children: [
          TextFont(
            text: title,
            fontSize: 11,
            textColor: getColor(context, 'black').withValues(alpha: 0.55),
          ),
          const SizedBox(height: 4),
          TextFont(text: val, fontSize: 13, fontWeight: FontWeight.bold),
        ],
      );

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.flash_on_rounded),
            label: const TextFont(
              text: 'Nạp quỹ nhanh',
              fontWeight: FontWeight.bold,
              textColor: Colors.white,
            ),
            onPressed: () => PersonalizedQuickDepositSheet.show(
              context,
              objective: widget.objective,
              onDepositSuccess: _triggerCelebration,
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: widget.accentColor.withValues(alpha: 0.12),
            padding: const EdgeInsets.all(14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          icon:
              Icon(Icons.add_circle_outline_rounded, color: widget.accentColor),
          tooltip: 'Thêm giao dịch chi tiết',
          onPressed: () => pushRoute(
            context,
            AddTransactionPage(
              selectedObjective: widget.objective,
              routesToPopAfterDelete: RoutesToPopAfterDelete.One,
              selectedIncome: widget.objective.income,
            ),
          ),
        ),
      ],
    );
  }
}
