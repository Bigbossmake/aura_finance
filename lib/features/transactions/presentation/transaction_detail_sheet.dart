import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/transaction_model.dart';
import '../domain/transaction_categorizer.dart';

class TransactionDetailSheet extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;

  const TransactionDetailSheet({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'local_cafe': return Icons.local_cafe;
      case 'lunch_dining': return Icons.lunch_dining;
      case 'delivery_dining': return Icons.delivery_dining;
      case 'local_grocery_store': return Icons.local_grocery_store;
      case 'local_taxi': return Icons.local_taxi;
      case 'local_gas_station': return Icons.local_gas_station;
      case 'movie': return Icons.movie;
      case 'music_note': return Icons.music_note;
      case 'sports_esports': return Icons.sports_esports;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'checkroom': return Icons.checkroom;
      case 'phone_android': return Icons.phone_android;
      case 'electrical_services': return Icons.electrical_services;
      case 'payments': return Icons.payments;
      case 'trending_up': return Icons.trending_up;
      default: return Icons.monetization_on;
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor';
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final result = TransactionCategorizer.categorize(
      transaction.rawDescription,
      transaction.amount,
    );
    final isExpense = transaction.amount < 0;
    final catColor = _getColorFromHex(result.categoryColorHex);
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final dateStr = '${dayNames[transaction.date.weekday - 1]}, '
        '${monthNames[transaction.date.month - 1]} ${transaction.date.day}, '
        '${transaction.date.year}';

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundEnd.withValues(alpha: 0.94),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Large icon + amount hero section
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: catColor.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Icon(
                  _getIconData(result.categoryIconName),
                  color: catColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              // Merchant name
              Text(
                result.cleanedMerchantName,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),

              // Amount
              Text(
                '${isExpense ? '-' : '+'}\$${transaction.amount.abs().toStringAsFixed(2)}',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isExpense ? AppColors.ruby : AppColors.emerald,
                ),
              ),
              const SizedBox(height: 24),

              // Detail rows in glass card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.glassBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      Icons.category_outlined,
                      'Category',
                      result.categoryName,
                      valueColor: catColor,
                    ),
                    _divider(),
                    _buildDetailRow(
                      Icons.calendar_today_outlined,
                      'Date',
                      dateStr,
                    ),
                    _divider(),
                    _buildDetailRow(
                      Icons.auto_awesome,
                      'AI Confidence',
                      '${(result.confidenceScore * 100).toInt()}%',
                      valueColor: AppColors.gold,
                    ),
                    _divider(),
                    _buildDetailRow(
                      Icons.account_balance_wallet_outlined,
                      'Currency',
                      transaction.currency,
                    ),
                    _divider(),
                    _buildDetailRow(
                      Icons.description_outlined,
                      'Raw Description',
                      transaction.rawDescription,
                      isSmall: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Delete button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.backgroundEnd,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: AppColors.glassBorder),
                        ),
                        title: Text(
                          'Delete Transaction',
                          style: GoogleFonts.outfit(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to delete this ${result.cleanedMerchantName} transaction?',
                          style: GoogleFonts.inter(color: AppColors.textSecondary),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(color: AppColors.textSecondary),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx); // close dialog
                              Navigator.pop(context); // close sheet
                              onDelete();
                            },
                            child: Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                color: AppColors.ruby,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text(
                    'DELETE TRANSACTION',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ruby.withValues(alpha: 0.15),
                    foregroundColor: AppColors.ruby,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppColors.ruby.withValues(alpha: 0.3)),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? valueColor, bool isSmall = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: isSmall ? 11 : 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: AppColors.textSecondary.withValues(alpha: 0.08),
      height: 1,
    );
  }
}
