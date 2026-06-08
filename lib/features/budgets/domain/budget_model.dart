class BudgetModel {
  final String id;
  final String categoryId;
  final String categoryName;
  final String categoryColorHex;
  final String categoryIconName;
  final double limitAmount;
  final double currentSpent;
  final DateTime periodStart;
  final DateTime periodEnd;

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColorHex,
    required this.categoryIconName,
    required this.limitAmount,
    required this.currentSpent,
    required this.periodStart,
    required this.periodEnd,
  });

  double get progress => limitAmount > 0 ? (currentSpent / limitAmount).clamp(0.0, 1.0) : 0.0;
  double get remaining => (limitAmount - currentSpent).clamp(0.0, double.infinity);
  bool get isOverBudget => currentSpent > limitAmount;
  bool get isNearLimit => progress >= 0.85 && !isOverBudget;
}
