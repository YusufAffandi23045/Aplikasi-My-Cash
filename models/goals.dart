class Goal {
  String id;
  String name;
  double targetAmount;
  double currentAmount;
  DateTime targetDate;
  String iconName;

  Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.targetDate,
    this.iconName = 'flag',
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0;
    double progress = (currentAmount / targetAmount) * 100;
    return progress > 100 ? 100 : progress;
  }

  int get daysRemaining {
    return targetDate.difference(DateTime.now()).inDays;
  }
}