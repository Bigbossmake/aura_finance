class TransactionModel {
  final String id;
  final double amount; // Отрицательное для расходов, положительное для доходов
  final String currency;
  final String? merchantName;
  final String rawDescription;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.currency,
    this.merchantName,
    required this.rawDescription,
    required this.date,
  });
}
