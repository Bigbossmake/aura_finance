import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/transaction_categorizer.dart';

class AddTransactionSheet extends StatefulWidget {
  final Function(double amount, String rawDescription) onSave;

  const AddTransactionSheet({
    super.key,
    required this.onSave,
  });

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  CategorizedResult? _aiResult;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateAIPreview);
    _amountController.addListener(_updateAIPreview);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateAIPreview() {
    final rawDesc = _descriptionController.text.trim();
    final amtText = _amountController.text.trim();
    final amt = double.tryParse(amtText) ?? 0.0;

    setState(() {
      if (rawDesc.isNotEmpty) {
        // Run on-device categorizer (assuming it is an expense by default, so amount is passed as negative)
        _aiResult = TransactionCategorizer.categorize(rawDesc, -amt);
      } else {
        _aiResult = null;
      }
    });
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'local_cafe':
        return Icons.local_cafe;
      case 'lunch_dining':
        return Icons.lunch_dining;
      case 'delivery_dining':
        return Icons.delivery_dining;
      case 'local_grocery_store':
        return Icons.local_grocery_store;
      case 'local_taxi':
        return Icons.local_taxi;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'movie':
        return Icons.movie;
      case 'music_note':
        return Icons.music_note;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'checkroom':
        return Icons.checkroom;
      case 'phone_android':
        return Icons.phone_android;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'payments':
        return Icons.payments;
      case 'trending_up':
        return Icons.trending_up;
      default:
        return Icons.monetization_on;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amt = double.parse(_amountController.text.trim());
      // expenses are represented as negative amounts in core logic
      widget.onSave(-amt, _descriptionController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            decoration: BoxDecoration(
              color: AppColors.backgroundEnd.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border.all(color: AppColors.glassBorder, width: 1.0),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ADD TRANSACTION',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Amount Input
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Amount (USD)',
                      labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
                      prefixText: '\$ ',
                      prefixStyle: GoogleFonts.outfit(color: AppColors.gold, fontSize: 24, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.glassBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
                      ),
                      filled: true,
                      fillColor: AppColors.glassBackground,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value.trim()) == null || double.parse(value.trim()) <= 0) {
                        return 'Please enter a valid positive number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Raw Description Input
                  TextFormField(
                    controller: _descriptionController,
                    textCapitalization: TextCapitalization.characters,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Statement Description',
                      labelStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
                      hintText: 'e.g. STARBUCKS COFFEE #1042',
                      hintStyle: GoogleFonts.inter(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.glassBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
                      ),
                      filled: true,
                      fillColor: AppColors.glassBackground,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a transaction description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),

                  // Real-time AI Preview Panel
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: _aiResult == null
                        ? const SizedBox.shrink()
                        : Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.glassBackground,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getColorFromHex(_aiResult!.categoryColorHex).withValues(alpha: 0.3),
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'AI CLASSIFIER PREVIEW',
                                      style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getColorFromHex(_aiResult!.categoryColorHex).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${(_aiResult!.confidenceScore * 100).toInt()}% Match',
                                        style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: _getColorFromHex(_aiResult!.categoryColorHex),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: _getColorFromHex(_aiResult!.categoryColorHex).withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _getIconData(_aiResult!.categoryIconName),
                                        color: _getColorFromHex(_aiResult!.categoryColorHex),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _aiResult!.cleanedMerchantName,
                                          style: GoogleFonts.outfit(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          _aiResult!.categoryName,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.backgroundEnd,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'SAVE TRANSACTION',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
