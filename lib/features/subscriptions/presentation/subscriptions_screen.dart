import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/l10n/app_localizations.dart';
import '../domain/subscription_model.dart';

class SubscriptionsScreen extends StatefulWidget {
  final List<SubscriptionModel> subscriptions;

  const SubscriptionsScreen({
    super.key,
    required this.subscriptions,
  });

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final ScrollController _calendarScrollController = ScrollController();
  int? _selectedDay;
  final Set<String> _enabledReminders = {};

  @override
  void initState() {
    super.initState();
    // By default, all active subscriptions have their notification reminders scheduled
    for (var sub in widget.subscriptions) {
      if (sub.status == 'active') {
        _enabledReminders.add(sub.id);
      }
    }
    
    // Auto-scroll the calendar to the current day after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentDay = DateTime.now().day;
      if (currentDay > 3) {
        // Calculate offset: each item is 55px wide + 10px margin = 65px total
        final offset = (currentDay - 3) * 65.0;
        _calendarScrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _calendarScrollController.dispose();
    super.dispose();
  }

  // Helper to get total costs
  Map<String, double> _calculateTotalCosts() {
    double monthlyTotal = 0.0;
    double weeklyTotal = 0.0;
    for (var sub in widget.subscriptions) {
      if (sub.status != 'active') continue;
      final cost = sub.amount;
      if (sub.frequency == 'weekly') {
        weeklyTotal += cost;
        monthlyTotal += cost * (52 / 12);
      } else if (sub.frequency == 'monthly') {
        monthlyTotal += cost;
        weeklyTotal += cost / (52 / 12);
      } else if (sub.frequency == 'yearly') {
        monthlyTotal += cost / 12;
        weeklyTotal += cost / 52;
      }
    }
    return {'monthly': monthlyTotal, 'weekly': weeklyTotal};
  }

  bool _isSubscriptionDueOnDate(SubscriptionModel sub, DateTime date) {
    if (sub.frequency == 'weekly') {
      return date.weekday == sub.nextBillingDate.weekday;
    } else if (sub.frequency == 'monthly') {
      return date.day == sub.nextBillingDate.day;
    } else if (sub.frequency == 'yearly') {
      return date.day == sub.nextBillingDate.day && date.month == sub.nextBillingDate.month;
    }
    return false;
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'MON';
      case 2: return 'TUE';
      case 3: return 'WED';
      case 4: return 'THU';
      case 5: return 'FRI';
      case 6: return 'SAT';
      case 7: return 'SUN';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }

  Color _getServiceColor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('netflix')) return AppColors.ruby;
    if (lower.contains('spotify')) return AppColors.emerald;
    if (lower.contains('gym') || lower.contains('fitness')) return AppColors.gold;
    return AppColors.textSecondary;
  }

  IconData _getServiceIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('netflix')) return Icons.movie;
    if (lower.contains('spotify')) return Icons.music_note;
    if (lower.contains('gym') || lower.contains('fitness')) return Icons.fitness_center;
    return Icons.credit_card;
  }

  void _toggleReminder(SubscriptionModel sub, bool enabled) async {
    setState(() {
      if (enabled) {
        _enabledReminders.add(sub.id);
      } else {
        _enabledReminders.remove(sub.id);
      }
    });

    if (enabled) {
      await NotificationService.scheduleSubscriptionReminder(
        id: sub.id,
        subscriptionName: sub.name,
        amount: sub.amount,
        currency: sub.currency,
        billingDate: sub.nextBillingDate,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reminder enabled for ${sub.name} (3 days before billing)',
              style: GoogleFonts.inter(color: AppColors.textPrimary),
            ),
            backgroundColor: AppColors.backgroundStart,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      await NotificationService.cancelSubscriptionReminder(sub.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reminder disabled for ${sub.name}',
              style: GoogleFonts.inter(color: AppColors.textPrimary),
            ),
            backgroundColor: AppColors.ruby.withValues(alpha: 0.8),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totals = _calculateTotalCosts();
    final now = DateTime.now();
    final totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;

    // Filtered subscriptions based on selected calendar day
    final filteredSubscriptions = widget.subscriptions.where((sub) {
      if (_selectedDay == null) return true;
      final date = DateTime(now.year, now.month, _selectedDay!);
      return _isSubscriptionDueOnDate(sub, date);
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.6, -0.8),
                radius: 1.5,
                colors: [
                  AppColors.backgroundStart,
                  AppColors.backgroundEnd,
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Nav Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        l10n.subscriptions.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Balancing spacer matching the BackButton
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),

                        // Stats Summary Cards (Glassmorphic Row)
                        Row(
                          children: [
                            Expanded(
                              child: _buildGlassCard(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'MONTHLY TOTAL',
                                        style: GoogleFonts.outfit(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '\$${totals['monthly']!.toStringAsFixed(2)}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.gold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildGlassCard(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'WEEKLY TOTAL',
                                        style: GoogleFonts.outfit(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '\$${totals['weekly']!.toStringAsFixed(2)}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 30),

                        // Calendar Month Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_getMonthName(now.month)} ${now.year}'.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (_selectedDay != null)
                              GestureDetector(
                                onTap: () => setState(() => _selectedDay = null),
                                child: Text(
                                  'CLEAR FILTER',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Horizontal Calendar Scroll Timeline
                        SizedBox(
                          height: 85,
                          child: ListView.builder(
                            controller: _calendarScrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: totalDaysInMonth,
                            itemBuilder: (context, index) {
                              final day = index + 1;
                              final date = DateTime(now.year, now.month, day);
                              final daySubs = widget.subscriptions.where((sub) {
                                return _isSubscriptionDueOnDate(sub, date);
                              }).toList();
                              
                              final isSelected = _selectedDay == day;
                              final hasSubscription = daySubs.isNotEmpty;
                              final isUrgent = daySubs.any((sub) {
                                final days = sub.nextBillingDate.difference(DateTime.now()).inDays;
                                return days <= 3 && days >= 0;
                              });

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_selectedDay == day) {
                                      _selectedDay = null;
                                    } else {
                                      _selectedDay = day;
                                    }
                                  });
                                },
                                child: Container(
                                  width: 55,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.gold.withValues(alpha: 0.15)
                                        : AppColors.glassBackground,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.gold
                                          : AppColors.glassBorder.withValues(alpha: 0.3),
                                      width: isSelected ? 1.5 : 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _getWeekdayName(date.weekday),
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          color: isSelected ? AppColors.gold : AppColors.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        day.toString(),
                                        style: GoogleFonts.outfit(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? AppColors.gold : AppColors.textPrimary,
                                        ),
                                      ),
                                      if (hasSubscription) ...[
                                        const SizedBox(height: 6),
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isUrgent ? AppColors.gold : AppColors.emerald,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Section List Title
                        Text(
                          _selectedDay != null
                              ? 'DUE ON ${_getMonthName(now.month).toUpperCase()} $_selectedDay'
                              : 'ALL DETECTED SUBSCRIPTIONS',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subscriptions Listing
                        if (filteredSubscriptions.isEmpty)
                          _buildGlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Center(
                                child: Text(
                                  'No renewals scheduled for this date.',
                                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                                ),
                              ),
                            ),
                          )
                        else
                          ...filteredSubscriptions.map((sub) {
                            final color = _getServiceColor(sub.name);
                            final icon = _getServiceIcon(sub.name);
                            final daysLeft = sub.nextBillingDate.difference(DateTime.now()).inDays;
                            final isUrgent = daysLeft <= 3 && daysLeft >= 0;
                            final isEnabled = _enabledReminders.contains(sub.id);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildGlassCard(
                                border: isUrgent
                                    ? Border.all(color: AppColors.gold.withValues(alpha: 0.4), width: 1.2)
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      // Service Icon Circular container
                                      Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(icon, color: color, size: 22),
                                      ),
                                      const SizedBox(width: 15),
                                      // Title + Renewal Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              sub.name,
                                              style: GoogleFonts.outfit(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              daysLeft < 0
                                                  ? 'Billed ${daysLeft.abs()} days ago'
                                                  : (daysLeft == 0
                                                      ? 'Renews TODAY • ${sub.frequency}'
                                                      : 'Renews in $daysLeft days • ${sub.frequency}'),
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: isUrgent ? AppColors.gold : AppColors.textSecondary,
                                                fontWeight: isUrgent ? FontWeight.w600 : FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.emerald.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                '${(sub.confidenceScore * 100).toInt()}% Confidence',
                                                style: GoogleFonts.inter(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.emerald,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Amount + Switch Toggle
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\$${sub.amount.toStringAsFixed(2)}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isUrgent ? AppColors.gold : AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                isEnabled ? Icons.notifications_active : Icons.notifications_off,
                                                color: isEnabled ? AppColors.gold : AppColors.textSecondary,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              Transform.scale(
                                                scale: 0.75,
                                                alignment: Alignment.centerRight,
                                                child: Switch(
                                                  value: isEnabled,
                                                  activeThumbColor: AppColors.gold,
                                                  activeTrackColor: AppColors.gold.withValues(alpha: 0.3),
                                                  inactiveThumbColor: AppColors.textSecondary,
                                                  inactiveTrackColor: AppColors.glassBackground,
                                                  onChanged: (val) => _toggleReminder(sub, val),
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
                            );
                          }),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, Border? border}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(24),
            border: border ?? Border.all(color: AppColors.glassBorder, width: 1.0),
          ),
          child: child,
        ),
      ),
    );
  }
}
