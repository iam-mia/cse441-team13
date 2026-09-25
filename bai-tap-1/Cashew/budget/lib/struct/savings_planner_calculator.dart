import 'package:budget/database/tables.dart';

/// Các trạng thái tiến độ tích lũy cá nhân hóa
enum GoalPaceStatus {
  completed,
  ahead,
  onTrack,
  behind,
  noDeadline,
}

/// Thông tin một cột mốc tích lũy (Milestone)
class GoalMilestone {
  final double percentage; // 0.25, 0.50, 0.75, 1.0
  final String title;
  final String description;
  final String emoji;
  final double targetAmount;
  final bool isReached;

  const GoalMilestone({
    required this.percentage,
    required this.title,
    required this.description,
    required this.emoji,
    required this.targetAmount,
    required this.isReached,
  });
}

/// Kết quả phân tích & lập kế hoạch tiết kiệm cá nhân hóa
class SavingsPlanInsight {
  final double currentAmount;
  final double targetAmount;
  final double percentage;
  final double remainingAmount;
  final int? daysRemaining;
  final double? dailyRequiredAmount;
  final double? weeklyRequiredAmount;
  final double? monthlyRequiredAmount;
  final GoalPaceStatus paceStatus;
  final String paceStatusLabel;
  final String motivationalQuote;
  final List<GoalMilestone> milestones;

  const SavingsPlanInsight({
    required this.currentAmount,
    required this.targetAmount,
    required this.percentage,
    required this.remainingAmount,
    this.daysRemaining,
    this.dailyRequiredAmount,
    this.weeklyRequiredAmount,
    this.monthlyRequiredAmount,
    required this.paceStatus,
    required this.paceStatusLabel,
    required this.motivationalQuote,
    required this.milestones,
  });
}

/// Bộ tính toán kế hoạch tích lũy cá nhân hóa
class SavingsPlannerCalculator {
  static SavingsPlanInsight calculate({
    required Objective objective,
    required double currentAmount,
  }) {
    final double targetAmount = objective.amount > 0 ? objective.amount : 1.0;
    final double clampedCurrent = currentAmount < 0 ? 0 : currentAmount;
    final double percentage = (clampedCurrent / targetAmount).clamp(0.0, 1.5);
    final double remainingAmount =
        (targetAmount - clampedCurrent).clamp(0.0, double.infinity);

    int? daysRemaining;
    double? dailyRequired;
    double? weeklyRequired;
    double? monthlyRequired;
    GoalPaceStatus paceStatus = GoalPaceStatus.noDeadline;
    String paceStatusLabel = 'Không giới hạn';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (objective.endDate != null) {
      final endDate = DateTime(
        objective.endDate!.year,
        objective.endDate!.month,
        objective.endDate!.day,
      );
      daysRemaining = endDate.difference(today).inDays;
      if (daysRemaining < 0) daysRemaining = 0;

      if (percentage >= 1.0) {
        paceStatus = GoalPaceStatus.completed;
        paceStatusLabel = 'Đã hoàn thành xuất sắc 🎉';
      } else if (daysRemaining == 0) {
        paceStatus = GoalPaceStatus.behind;
        paceStatusLabel = 'Hôm nay là hạn chót!';
        dailyRequired = remainingAmount;
      } else {
        dailyRequired = remainingAmount / daysRemaining;
        weeklyRequired = remainingAmount / (daysRemaining / 7.0);
        monthlyRequired = remainingAmount / (daysRemaining / 30.0);

        // Đánh giá tốc độ dựa trên thời gian đã qua vs phần trăm đã đạt
        final startDate = DateTime(
          objective.dateCreated.year,
          objective.dateCreated.month,
          objective.dateCreated.day,
        );
        final totalDays = endDate.difference(startDate).inDays;
        if (totalDays > 0) {
          final elapsedDays = today.difference(startDate).inDays;
          final expectedPace = (elapsedDays / totalDays).clamp(0.0, 1.0);
          if (percentage >= expectedPace + 0.05) {
            paceStatus = GoalPaceStatus.ahead;
            paceStatusLabel = 'Đang vượt tiến độ 🚀';
          } else if (percentage >= expectedPace - 0.05) {
            paceStatus = GoalPaceStatus.onTrack;
            paceStatusLabel = 'Đang đúng kế hoạch 🎯';
          } else {
            paceStatus = GoalPaceStatus.behind;
            paceStatusLabel = 'Cần tăng tốc tích lũy ⚡';
          }
        } else {
          paceStatus = GoalPaceStatus.onTrack;
          paceStatusLabel = 'Đang tiến hành 🎯';
        }
      }
    } else {
      if (percentage >= 1.0) {
        paceStatus = GoalPaceStatus.completed;
        paceStatusLabel = 'Đã đạt mục tiêu 🏆';
      } else {
        paceStatus = GoalPaceStatus.noDeadline;
        paceStatusLabel = 'Tích lũy tự do 🍀';
      }
    }

    final milestones = [
      GoalMilestone(
        percentage: 0.25,
        title: 'Khởi đầu vững chắc',
        description: 'Những bước đầu tiên xây dựng thói quen',
        emoji: '🌱',
        targetAmount: targetAmount * 0.25,
        isReached: percentage >= 0.25,
      ),
      GoalMilestone(
        percentage: 0.50,
        title: 'Nửa chặng đường',
        description: 'Đã hoàn thành một nửa mục tiêu!',
        emoji: '🌿',
        targetAmount: targetAmount * 0.50,
        isReached: percentage >= 0.50,
      ),
      GoalMilestone(
        percentage: 0.75,
        title: 'Bứt phá về đích',
        description: 'Mục tiêu đã ở rất gần trong tầm tay',
        emoji: '🌳',
        targetAmount: targetAmount * 0.75,
        isReached: percentage >= 0.75,
      ),
      GoalMilestone(
        percentage: 1.0,
        title: 'Chinh phục vinh quang',
        description: 'Thành quả xứng đáng cho sự kiên trì!',
        emoji: '🏆',
        targetAmount: targetAmount,
        isReached: percentage >= 1.0,
      ),
    ];

    final motivationalQuote = _getMotivationalQuote(percentage, paceStatus);

    return SavingsPlanInsight(
      currentAmount: clampedCurrent,
      targetAmount: targetAmount,
      percentage: percentage,
      remainingAmount: remainingAmount,
      daysRemaining: daysRemaining,
      dailyRequiredAmount: dailyRequired,
      weeklyRequiredAmount: weeklyRequired,
      monthlyRequiredAmount: monthlyRequired,
      paceStatus: paceStatus,
      paceStatusLabel: paceStatusLabel,
      motivationalQuote: motivationalQuote,
      milestones: milestones,
    );
  }

  static String _getMotivationalQuote(
      double percentage, GoalPaceStatus paceStatus) {
    if (percentage >= 1.0) {
      return 'Xuất sắc! Bạn đã biến mục tiêu tài chính thành hiện thực!';
    }
    if (percentage >= 0.75) {
      return 'Chỉ còn một chút nữa thôi, đích đến đã ngay trước mắt!';
    }
    if (percentage >= 0.50) {
      return 'Bạn đã đi được một nửa hành trình! Hãy tiếp tục duy trì đà này nhé.';
    }
    if (percentage >= 0.25) {
      return 'Khởi đầu tuyệt vời! Tích tiểu thành đại, từng đồng đều có ý nghĩa.';
    }
    return 'Hành trình vạn dặm bắt đầu từ những đồng tiết kiệm đầu tiên!';
  }

  /// Gợi ý các mức nạp tiền nhanh phù hợp với mục tiêu
  static List<double> getQuickDepositSuggestions(double targetAmount) {
    if (targetAmount <= 500000) {
      return [20000, 50000, 100000, 200000];
    } else if (targetAmount <= 5000000) {
      return [50000, 100000, 200000, 500000];
    } else if (targetAmount <= 20000000) {
      return [200000, 500000, 1000000, 2000000];
    } else {
      return [500000, 1000000, 2000000, 5000000];
    }
  }
}
