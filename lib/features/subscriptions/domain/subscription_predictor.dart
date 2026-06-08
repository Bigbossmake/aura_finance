import '../../transactions/domain/transaction_model.dart';
import 'subscription_model.dart';

class SubscriptionPredictor {
  /// Analyzes a list of transactions to detect potential recurring subscriptions.
  /// It groups transactions by merchant name and identifies recurring intervals
  /// (weekly, monthly, yearly) with similar amounts.
  static List<SubscriptionModel> predictSubscriptions(List<TransactionModel> transactions) {
    if (transactions.isEmpty) return [];

    // Group transactions by merchant name (normalized to lower case)
    final Map<String, List<TransactionModel>> groupedByMerchant = {};
    for (var tx in transactions) {
      if (tx.merchantName == null || tx.amount >= 0) continue; // Only process outgoing transactions/expenses
      
      final normalizedMerchant = tx.merchantName!.trim().toLowerCase();
      groupedByMerchant.putIfAbsent(normalizedMerchant, () => []).add(tx);
    }

    final List<SubscriptionModel> predicted = [];

    groupedByMerchant.forEach((merchant, txList) {
      if (txList.length < 2) return; // Need at least 2 transactions to detect a pattern

      // Sort transactions by date (oldest first)
      txList.sort((a, b) => a.date.compareTo(b.date));

      // Calculate intervals in days between consecutive transactions
      final List<int> intervals = [];
      for (int i = 0; i < txList.length - 1; i++) {
        final diff = txList[i + 1].date.difference(txList[i].date).inDays;
        intervals.add(diff);
      }

      // Calculate average interval
      final double avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;

      // Check amount consistency (all transaction amounts should be close/identical)
      final double firstAmount = txList.first.amount.abs();
      bool amountsConsistent = true;
      for (var tx in txList) {
        final currentAmount = tx.amount.abs();
        // Allow up to 5% variance in price (e.g. currency conversion fluctuation or price change)
        if ((currentAmount - firstAmount).abs() / firstAmount > 0.05) {
          amountsConsistent = false;
          break;
        }
      }

      if (!amountsConsistent) return;

      // Determine frequency
      String frequency = 'monthly';
      double confidence = 0.5;

      // If average interval is close to 7 days (+- 1 day)
      if ((avgInterval - 7).abs() <= 1.5) {
        frequency = 'weekly';
        confidence = 0.8;
      }
      // If average interval is close to 30 days (+- 3 days)
      else if ((avgInterval - 30.4).abs() <= 4) {
        frequency = 'monthly';
        confidence = 0.9;
      }
      // If average interval is close to 365 days (+- 15 days)
      else if ((avgInterval - 365.25).abs() <= 15) {
        frequency = 'yearly';
        confidence = 0.95;
      } else {
        // Not a standard frequency we recognize, skip
        return;
      }

      // Add confidence based on transaction count (more transactions = higher confidence)
      if (txList.length >= 3) confidence = (confidence + 0.1).clamp(0.0, 1.0);
      if (txList.length >= 5) confidence = (confidence + 0.1).clamp(0.0, 1.0);

      // Estimate next billing date
      final lastTxDate = txList.last.date;
      DateTime nextBillingDate;
      if (frequency == 'weekly') {
        nextBillingDate = lastTxDate.add(const Duration(days: 7));
      } else if (frequency == 'yearly') {
        nextBillingDate = DateTime(lastTxDate.year + 1, lastTxDate.month, lastTxDate.day);
      } else {
        // Monthly
        int nextMonth = lastTxDate.month + 1;
        int nextYear = lastTxDate.year;
        if (nextMonth > 12) {
          nextMonth = 1;
          nextYear += 1;
        }
        // Handle end of month day overflow (e.g. Jan 31 -> Feb 28)
        int nextDay = lastTxDate.day;
        final daysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        if (nextDay > daysInNextMonth) {
          nextDay = daysInNextMonth;
        }
        nextBillingDate = DateTime(nextYear, nextMonth, nextDay);
      }

      // Format clean merchant name (capitalize first letter)
      final rawName = txList.first.merchantName!;
      final cleanName = rawName[0].toUpperCase() + rawName.substring(1);

      predicted.add(
        SubscriptionModel(
          id: '${merchant}_predicted',
          name: cleanName,
          amount: firstAmount,
          currency: txList.first.currency,
          frequency: frequency,
          nextBillingDate: nextBillingDate,
          confidenceScore: confidence,
        ),
      );
    });

    return predicted;
  }
}
