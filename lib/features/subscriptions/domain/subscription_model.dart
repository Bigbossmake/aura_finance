class SubscriptionModel {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final String frequency; // 'weekly', 'monthly', 'yearly'
  final DateTime nextBillingDate;
  final double confidenceScore;
  final String status;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.frequency,
    required this.nextBillingDate,
    required this.confidenceScore,
    this.status = 'active',
  });
}
