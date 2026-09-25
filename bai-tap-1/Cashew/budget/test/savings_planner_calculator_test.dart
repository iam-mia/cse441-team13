import 'package:flutter_test/flutter_test.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/struct/savings_planner_calculator.dart';

void main() {
  group('SavingsPlannerCalculator Tests', () {
    test('Calculate progress without deadline correctly', () {
      final objective = Objective(
        objectivePk: 'obj-1',
        type: ObjectiveType.goal,
        name: 'Mua laptop mới',
        amount: 20000000,
        order: 0,
        colour: '#FF5722',
        dateCreated: DateTime.now().subtract(const Duration(days: 30)),
        endDate: null,
        dateTimeModified: null,
        iconName: 'laptop.png',
        emojiIconName: null,
        income: false,
        pinned: true,
        archived: false,
        walletFk: '0',
      );

      final plan = SavingsPlannerCalculator.calculate(
        objective: objective,
        currentAmount: 10000000,
      );

      expect(plan.percentage, 0.5);
      expect(plan.remainingAmount, 10000000);
      expect(plan.paceStatus, GoalPaceStatus.noDeadline);
      expect(plan.milestones.length, 4);
      expect(plan.milestones[0].isReached, isTrue); // 25%
      expect(plan.milestones[1].isReached, isTrue); // 50%
      expect(plan.milestones[2].isReached, isFalse); // 75%
      expect(plan.milestones[3].isReached, isFalse); // 100%
    });

    test('Calculate progress with deadline and daily requirement', () {
      final now = DateTime.now();
      final objective = Objective(
        objectivePk: 'obj-2',
        type: ObjectiveType.goal,
        name: 'Du lịch Đà Nẵng',
        amount: 10000000,
        order: 1,
        colour: '#2196F3',
        dateCreated: now.subtract(const Duration(days: 10)),
        endDate: now.add(const Duration(days: 20)),
        dateTimeModified: null,
        iconName: 'beach.png',
        emojiIconName: null,
        income: false,
        pinned: true,
        archived: false,
        walletFk: '0',
      );

      final plan = SavingsPlannerCalculator.calculate(
        objective: objective,
        currentAmount: 4000000,
      );

      expect(plan.percentage, 0.4);
      expect(plan.remainingAmount, 6000000);
      expect(plan.daysRemaining, 20);
      expect(plan.dailyRequiredAmount, 6000000 / 20);
      expect(plan.paceStatus, GoalPaceStatus.ahead);
    });

    test('Completed goal identifies completed status', () {
      final objective = Objective(
        objectivePk: 'obj-3',
        type: ObjectiveType.goal,
        name: 'Quỹ khẩn cấp',
        amount: 5000000,
        order: 2,
        colour: '#4CAF50',
        dateCreated: DateTime.now().subtract(const Duration(days: 60)),
        endDate: null,
        dateTimeModified: null,
        iconName: 'shield.png',
        emojiIconName: null,
        income: false,
        pinned: true,
        archived: false,
        walletFk: '0',
      );

      final plan = SavingsPlannerCalculator.calculate(
        objective: objective,
        currentAmount: 5500000,
      );

      expect(plan.percentage, greaterThanOrEqualTo(1.0));
      expect(plan.remainingAmount, 0.0);
      expect(plan.paceStatus, GoalPaceStatus.completed);
      expect(plan.milestones.every((m) => m.isReached), isTrue);
    });

    test('Quick deposit suggestions return sensible amounts', () {
      final lowSuggestions =
          SavingsPlannerCalculator.getQuickDepositSuggestions(300000);
      expect(lowSuggestions, contains(50000));

      final mediumSuggestions =
          SavingsPlannerCalculator.getQuickDepositSuggestions(15000000);
      expect(mediumSuggestions, contains(500000));

      final highSuggestions =
          SavingsPlannerCalculator.getQuickDepositSuggestions(50000000);
      expect(highSuggestions, contains(1000000));
    });
  });
}
