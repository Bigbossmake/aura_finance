import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/l10n/app_localizations.dart';
import 'core/services/notification_service.dart';
import 'core/services/biometric_service.dart';
import 'features/transactions/domain/transaction_model.dart';
import 'features/subscriptions/domain/subscription_predictor.dart';
import 'features/subscriptions/domain/subscription_model.dart';
import 'features/transactions/domain/transaction_categorizer.dart';
import 'features/subscriptions/presentation/subscriptions_screen.dart';
import 'features/transactions/presentation/add_transaction_sheet.dart';
import 'core/db/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'features/budgets/domain/budget_model.dart';
import 'features/budgets/presentation/add_budget_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await NotificationService.requestPermissions();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura Finance',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('pt'),
        Locale('zh'),
        Locale('ja'),
        Locale('ko'),
        Locale('ar'),
        Locale('hi'),
        Locale('tr'),
        Locale('nl'),
        Locale('pl'),
        Locale('uk'),
        Locale('vi'),
        Locale('id'),
        Locale('th'),
        Locale('sv'),
      ],
      home: DashboardScreen(onLocaleChange: setLocale, currentLocale: _locale),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  final Locale currentLocale;

  const DashboardScreen({
    super.key,
    required this.onLocaleChange,
    required this.currentLocale,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English 🇬🇧'},
    {'code': 'ru', 'name': 'Русский 🇷🇺'},
    {'code': 'es', 'name': 'Español 🇪🇸'},
    {'code': 'fr', 'name': 'Français 🇫🇷'},
    {'code': 'de', 'name': 'Deutsch 🇩🇪'},
    {'code': 'it', 'name': 'Italiano 🇮🇹'},
    {'code': 'pt', 'name': 'Português 🇵🇹'},
    {'code': 'zh', 'name': '中文 🇨🇳'},
    {'code': 'ja', 'name': '日本語 🇯🇵'},
    {'code': 'ko', 'name': '한국어 🇰🇷'},
    {'code': 'ar', 'name': 'العربية 🇸🇦'},
    {'code': 'hi', 'name': 'हिन्दी 🇮🇳'},
    {'code': 'tr', 'name': 'Türkçe 🇹🇷'},
    {'code': 'nl', 'name': 'Nederlands 🇳🇱'},
    {'code': 'pl', 'name': 'Polski 🇵🇱'},
    {'code': 'uk', 'name': 'Українська 🇺🇦'},
    {'code': 'vi', 'name': 'Tiếng Việt 🇻🇳'},
    {'code': 'id', 'name': 'Bahasa Indonesia 🇮🇩'},
    {'code': 'th', 'name': 'ไทย 🇹🇭'},
    {'code': 'sv', 'name': 'Svenska 🇸🇪'},
  ];

  List<SubscriptionModel> _predictedSubscriptions = [];
  List<TransactionModel> _transactions = [];
  List<BudgetModel> _budgets = [];
  bool _isLocked = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _loadAndPredictSubscriptions();
    _authenticateUser();
  }

  void _authenticateUser() async {
    final supported = await BiometricService.isBiometricSupported();
    if (supported) {
      final authenticated = await BiometricService.authenticate(
        reason: 'Confirm your identity to unlock Aura Finance',
      );
      if (authenticated && mounted) {
        setState(() {
          _isLocked = false;
        });
      }
    } else {
      // If biometrics not supported, bypass lock for demo purposes
      if (mounted) {
        setState(() {
          _isLocked = false;
        });
      }
    }
  }

  List<TransactionModel> _generateMockTransactions(DateTime now) {
    return [
      // Netflix recurring monthly (billing date estimated around now + 30 days)
      TransactionModel(
        id: 'tx_netflix_1',
        amount: -15.99,
        currency: 'USD',
        merchantName: 'Netflix',
        rawDescription: 'NETFLIX.COM CARD RENEWAL',
        date: now.subtract(const Duration(days: 57)),
      ),
      TransactionModel(
        id: 'tx_netflix_2',
        amount: -15.99,
        currency: 'USD',
        merchantName: 'Netflix',
        rawDescription: 'NETFLIX.COM CARD RENEWAL',
        date: now.subtract(const Duration(days: 27)),
      ),
      // Spotify recurring monthly (renewal expected in 3 days)
      TransactionModel(
        id: 'tx_spotify_1',
        amount: -9.99,
        currency: 'USD',
        merchantName: 'Spotify',
        rawDescription: 'SPOTIFY PREMIUM MEMBERSHIP',
        date: now.subtract(const Duration(days: 57)),
      ),
      TransactionModel(
        id: 'tx_spotify_2',
        amount: -9.99,
        currency: 'USD',
        merchantName: 'Spotify',
        rawDescription: 'SPOTIFY PREMIUM MEMBERSHIP',
        date: now.subtract(const Duration(days: 27)),
      ),
      // Gym recurring weekly
      TransactionModel(
        id: 'tx_gym_1',
        amount: -12.00,
        currency: 'USD',
        merchantName: 'Gym Membership',
        rawDescription: 'FITNESS CLUB WEEKLY DEBIT',
        date: now.subtract(const Duration(days: 21)),
      ),
      TransactionModel(
        id: 'tx_gym_2',
        amount: -12.00,
        currency: 'USD',
        merchantName: 'Gym Membership',
        rawDescription: 'FITNESS CLUB WEEKLY DEBIT',
        date: now.subtract(const Duration(days: 14)),
      ),
      TransactionModel(
        id: 'tx_gym_3',
        amount: -12.00,
        currency: 'USD',
        merchantName: 'Gym Membership',
        rawDescription: 'FITNESS CLUB WEEKLY DEBIT',
        date: now.subtract(const Duration(days: 7)),
      ),
      // Non-recurring random transactions (should be ignored by predictor)
      TransactionModel(
        id: 'tx_uber_1',
        amount: -22.50,
        currency: 'USD',
        merchantName: 'Uber',
        rawDescription: 'UBER RIDE ON 25TH',
        date: now.subtract(const Duration(days: 15)),
      ),
      TransactionModel(
        id: 'tx_starbucks_1',
        amount: -5.40,
        currency: 'USD',
        merchantName: 'Starbucks',
        rawDescription: 'STARBUCKS COFFEE SEATTLE',
        date: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  void _loadAndPredictSubscriptions() async {
    final now = DateTime.now();
    
    // Read transactions from SQLite database
    final dbTxs = await AppDatabase.instance.getAllTransactions();
    
    if (dbTxs.isEmpty) {
      // Seed default mock transactions to database
      final mockTxs = _generateMockTransactions(now);
      for (final tx in mockTxs) {
        await AppDatabase.instance.insertTransaction(
          TransactionsCompanion.insert(
            id: tx.id,
            accountId: 'dummy_account',
            amount: tx.amount,
            currency: Value(tx.currency),
            merchantName: Value(tx.merchantName),
            rawDescription: tx.rawDescription,
            transactionDate: tx.date,
          ),
        );
      }
      // Re-read after seeding
      final updatedDbTxs = await AppDatabase.instance.getAllTransactions();
      _transactions = updatedDbTxs.map((dbTx) => TransactionModel(
        id: dbTx.id,
        amount: dbTx.amount,
        currency: dbTx.currency,
        merchantName: dbTx.merchantName,
        rawDescription: dbTx.rawDescription,
        date: dbTx.transactionDate,
      )).toList();
    } else {
      _transactions = dbTxs.map((dbTx) => TransactionModel(
        id: dbTx.id,
        amount: dbTx.amount,
        currency: dbTx.currency,
        merchantName: dbTx.merchantName,
        rawDescription: dbTx.rawDescription,
        date: dbTx.transactionDate,
      )).toList();
    }

    // Run AI/Heuristic subscription prediction
    final predictions = SubscriptionPredictor.predictSubscriptions(_transactions);

    // Schedule local push notification reminder for each predicted subscription 3 days before renewal
    for (var sub in predictions) {
      await NotificationService.scheduleSubscriptionReminder(
        id: sub.id,
        subscriptionName: sub.name,
        amount: sub.amount,
        currency: sub.currency,
        billingDate: sub.nextBillingDate,
      );
    }

    if (mounted) {
      setState(() {
        _predictedSubscriptions = predictions;
      });
    }

    // Load budgets after transactions are available (so currentSpent is computed correctly)
    _loadBudgets();
  }

  void _addNewTransaction(double amount, String rawDescription) async {
    final now = DateTime.now();
    final result = TransactionCategorizer.categorize(rawDescription, amount);
    final txId = 'tx_${now.millisecondsSinceEpoch}';

    // Insert into SQLite database
    await AppDatabase.instance.insertTransaction(
      TransactionsCompanion.insert(
        id: txId,
        accountId: 'dummy_account',
        amount: amount,
        currency: const Value('USD'),
        merchantName: Value(result.cleanedMerchantName),
        rawDescription: rawDescription,
        transactionDate: now,
      ),
    );
    
    // Re-load transactions from DB and update state (which will re-run subscription prediction)
    _loadAndPredictSubscriptions();
    _loadBudgets();
  }

  // --- Budget Management ---

  /// Category name mapping (categoryId -> categoryName) for budgets
  static const _categoryNameMap = {
    'cat_food': 'Food & Dining',
    'cat_groceries': 'Groceries',
    'cat_transport': 'Transport',
    'cat_entertainment': 'Entertainment',
    'cat_shopping': 'Shopping',
    'cat_utilities': 'Utilities',
    'cat_income': 'Income',
  };

  static const _categoryColorMap = {
    'cat_food': '#FF10B981',
    'cat_groceries': '#FF059669',
    'cat_transport': '#FF3B82F6',
    'cat_entertainment': '#FFE11D48',
    'cat_shopping': '#FFF59E0B',
    'cat_utilities': '#FF8B5CF6',
    'cat_income': '#FF10B981',
  };

  static const _categoryIconMap = {
    'cat_food': 'local_cafe',
    'cat_groceries': 'local_grocery_store',
    'cat_transport': 'local_taxi',
    'cat_entertainment': 'movie',
    'cat_shopping': 'shopping_bag',
    'cat_utilities': 'phone_android',
    'cat_income': 'payments',
  };

  void _loadBudgets() async {
    final dbBudgets = await AppDatabase.instance.getAllBudgets();
    final categorySpending = _computeCategorySpending();

    final List<BudgetModel> loaded = [];
    for (final b in dbBudgets) {
      final catName = _categoryNameMap[b.categoryId] ?? 'Other';
      final catColor = _categoryColorMap[b.categoryId] ?? '#FF94A3B8';
      final catIcon = _categoryIconMap[b.categoryId] ?? 'monetization_on';
      final spent = categorySpending[catName] ?? 0.0;

      loaded.add(BudgetModel(
        id: b.id,
        categoryId: b.categoryId,
        categoryName: catName,
        categoryColorHex: catColor,
        categoryIconName: catIcon,
        limitAmount: b.limitAmount,
        currentSpent: spent,
        periodStart: b.periodStart,
        periodEnd: b.periodEnd,
      ));
    }

    if (mounted) {
      setState(() {
        _budgets = loaded;
      });
    }
  }

  void _showAddBudgetSheet() {
    // Filter categories that don't already have a budget
    final existingCategoryIds = _budgets.map((b) => b.categoryId).toSet();
    final available = _categoryNameMap.entries
        .where((e) => !existingCategoryIds.contains(e.key) && e.key != 'cat_income')
        .map((e) => {'id': e.key, 'name': e.value})
        .toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All categories already have budgets!',
              style: GoogleFonts.inter(color: AppColors.textPrimary)),
          backgroundColor: AppColors.backgroundEnd,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddBudgetSheet(
        availableCategories: available,
        onSave: (categoryId, categoryName, limit) async {
          final now = DateTime.now();
          final monthStart = DateTime(now.year, now.month, 1);
          final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

          await AppDatabase.instance.insertBudget(
            BudgetsCompanion.insert(
              id: 'budget_${now.millisecondsSinceEpoch}',
              userId: 'dummy_user',
              categoryId: categoryId,
              limitAmount: limit,
              periodStart: monthStart,
              periodEnd: monthEnd,
            ),
          );
          _loadBudgets();
        },
      ),
    );
  }

  void _deleteBudget(String budgetId) async {
    await AppDatabase.instance.deleteBudget(budgetId);
    _loadBudgets();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Background + Main Dashboard Content
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
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.gold, width: 1.5),
                              ),
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150&auto=format&fit=crop'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.appTitle,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Premium Member',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Language Switcher Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.glassBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: widget.currentLocale.languageCode,
                              dropdownColor: AppColors.backgroundEnd,
                              icon: const Icon(Icons.language, color: AppColors.gold, size: 18),
                              onChanged: (String? code) {
                                if (code != null) {
                                  widget.onLocaleChange(Locale(code));
                                }
                              },
                              items: _languages.map((lang) {
                                return DropdownMenuItem<String>(
                                  value: lang['code'],
                                  child: Text(
                                    lang['name']!,
                                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Net Worth Card with Gold/Emerald accents
                    _buildNetWorthCard(l10n),
                    const SizedBox(height: 25),

                    // Quick Actions Horizontal Scroll
                    _buildQuickActions(l10n),
                    const SizedBox(height: 25),

                    // AI Radar Curve Chart
                    _buildAnalyticsCard(l10n),
                    const SizedBox(height: 25),

                    // Subscriptions Ticker (showing 1 warning card with gold pulse)
                    _buildSubscriptionsSection(l10n),
                    const SizedBox(height: 25),

                    // Interactive Budgets Progress Bars
                    _buildBudgetsSection(l10n),
                    const SizedBox(height: 25),

                    // Recent Transactions with AI categorization
                    _buildRecentTransactionsSection(l10n),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          // Glassmorphic Biometric Lock Overlay
          if (_isLocked)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  color: AppColors.backgroundEnd.withValues(alpha: 0.85),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold.withValues(alpha: 0.4), width: 1.5),
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            color: AppColors.gold,
                            size: 56,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'AURA IS LOCKED',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use Fingerprint or FaceID to authenticate',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton.icon(
                          onPressed: _authenticateUser,
                          icon: const Icon(Icons.fingerprint, color: AppColors.backgroundEnd, size: 20),
                          label: Text(
                            'UNLOCK',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.backgroundEnd,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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

  Widget _buildNetWorthCard(AppLocalizations l10n) {
    return _buildGlassCard(
      border: Border.all(color: AppColors.gold.withValues(alpha: 0.25), width: 1.0),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.netWorth.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Icon(Icons.account_balance_wallet, color: AppColors.gold, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '\$12,480.50',
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.arrow_upward, color: AppColors.emerald, size: 16),
                const SizedBox(width: 4),
                Text(
                  '+14.2% this month',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.emerald,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(AppLocalizations l10n) {
    final actions = [
      {'icon': Icons.add, 'label': l10n.addTransaction},
      {'icon': Icons.psychology, 'label': 'AI Tags'},
      {'icon': Icons.subscriptions, 'label': l10n.subscriptions},
      {'icon': Icons.pie_chart, 'label': l10n.budgets},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return GestureDetector(
            onTap: () {
              if (action['icon'] == Icons.subscriptions) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscriptionsScreen(
                      subscriptions: _predictedSubscriptions,
                    ),
                  ),
                );
              } else if (action['icon'] == Icons.add) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddTransactionSheet(
                    onSave: (amount, rawDescription) {
                      _addNewTransaction(amount, rawDescription);
                    },
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  _buildGlassCard(
                    child: Container(
                      height: 56,
                      width: 56,
                      alignment: Alignment.center,
                      child: Icon(action['icon'] as IconData, color: AppColors.gold, size: 22),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    action['label'] as String,
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- LIVE ANALYTICS HELPERS ---

  /// Compute spending totals grouped by category from real transactions
  Map<String, double> _computeCategorySpending() {
    final Map<String, double> categoryTotals = {};
    for (final tx in _transactions) {
      if (tx.amount >= 0) continue; // skip income
      final result = TransactionCategorizer.categorize(tx.rawDescription, tx.amount);
      categoryTotals[result.categoryName] =
          (categoryTotals[result.categoryName] ?? 0) + tx.amount.abs();
    }
    return categoryTotals;
  }

  /// Compute daily spending totals for the last 7 days
  List<double> _computeDailySpending() {
    final now = DateTime.now();
    final List<double> dailyTotals = List.filled(7, 0.0);
    for (final tx in _transactions) {
      if (tx.amount >= 0) continue;
      final daysAgo = now.difference(tx.date).inDays;
      if (daysAgo >= 0 && daysAgo < 7) {
        dailyTotals[6 - daysAgo] += tx.amount.abs();
      }
    }
    return dailyTotals;
  }

  /// Generate a dynamic AI insight string from actual transaction data
  String _generateAIInsight() {
    if (_transactions.isEmpty) return 'Add transactions to unlock AI insights.';

    final categorySpending = _computeCategorySpending();
    if (categorySpending.isEmpty) return 'No expenses recorded yet.';

    // Find top spending category
    final topEntry = categorySpending.entries
        .reduce((a, b) => a.value >= b.value ? a : b);
    final totalSpent = categorySpending.values.fold(0.0, (a, b) => a + b);
    final topPercent = totalSpent > 0
        ? (topEntry.value / totalSpent * 100).toInt()
        : 0;

    // Find subscription renewal info
    String renewalHint = '';
    if (_predictedSubscriptions.isNotEmpty) {
      final nearest = _predictedSubscriptions.reduce((a, b) =>
          a.nextBillingDate.isBefore(b.nextBillingDate) ? a : b);
      final daysLeft = nearest.nextBillingDate.difference(DateTime.now()).inDays;
      renewalHint = ' ${nearest.name} renewal in $daysLeft day${daysLeft == 1 ? '' : 's'}.';
    }

    return 'AI: $topPercent% of spending goes to ${topEntry.key} (\$${topEntry.value.toStringAsFixed(2)}).$renewalHint';
  }

  Widget _buildAnalyticsCard(AppLocalizations l10n) {
    final categorySpending = _computeCategorySpending();
    final dailySpending = _computeDailySpending();
    final totalSpent = categorySpending.values.fold(0.0, (a, b) => a + b);
    final aiInsight = _generateAIInsight();

    // Sort categories by amount descending
    final sortedCategories = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Category color map
    const categoryColors = {
      'Food & Dining': Color(0xFF10B981),
      'Groceries': Color(0xFF059669),
      'Transport': Color(0xFF3B82F6),
      'Entertainment': Color(0xFFE11D48),
      'Shopping': Color(0xFFF59E0B),
      'Utilities': Color(0xFF8B5CF6),
      'Income': Color(0xFF10B981),
    };

    return _buildGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AI EXPENSE INSIGHTS',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'LIVE',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Total spending line
            Text(
              '\$${totalSpent.toStringAsFixed(2)} spent',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 15),

            // 7-day spending trend chart
            SizedBox(
              height: 110,
              width: double.infinity,
              child: CustomPaint(
                painter: SpendingTrendPainter(dailyData: dailySpending),
              ),
            ),

            // Day labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final day = DateTime.now().subtract(Duration(days: 6 - i));
                final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Text(
                  dayNames[day.weekday - 1],
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),

            // Category breakdown bars
            if (sortedCategories.isNotEmpty) ...[
              Text(
                'BY CATEGORY',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              ...sortedCategories.take(4).map((entry) {
                final fraction = totalSpent > 0 ? entry.value / totalSpent : 0.0;
                final color = categoryColors[entry.key] ?? AppColors.textSecondary;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(
                          entry.key,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            height: 6,
                            child: LinearProgressIndicator(
                              value: fraction,
                              backgroundColor: AppColors.textSecondary.withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${entry.value.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 12),

            // AI insight row
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.gold, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    aiInsight,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubscriptionsScreen(
                  subscriptions: _predictedSubscriptions,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.subscriptions.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_predictedSubscriptions.isEmpty)
          _buildGlassCard(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'No recurring subscriptions detected yet.',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
            ),
          )
        else
          ..._predictedSubscriptions.map((sub) {
            // Calculate remaining days
            final daysLeft = sub.nextBillingDate.difference(DateTime.now()).inDays;
            final bool isUrgent = daysLeft <= 3;
            
            final Widget cardContent = Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: (isUrgent ? AppColors.gold : AppColors.emerald).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      sub.name.toLowerCase().contains('gym') ? Icons.fitness_center : Icons.credit_card,
                      color: isUrgent ? AppColors.gold : AppColors.emerald,
                    ),
                  ),
                  const SizedBox(width: 15),
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
                        Text(
                          'Renewal in $daysLeft days • ${sub.frequency}',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${sub.amount.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isUrgent ? AppColors.gold : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );

            if (isUrgent) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final double glowMultiplier = _pulseController.value;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                           BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.15 * glowMultiplier),
                            blurRadius: 15.0 * glowMultiplier,
                            spreadRadius: 1.0 * glowMultiplier,
                          )
                        ],
                      ),
                      child: _buildGlassCard(
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.2 + (0.3 * glowMultiplier)),
                          width: 1.2,
                        ),
                        child: cardContent,
                      ),
                    );
                  },
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildGlassCard(
                  child: cardContent,
                ),
              );
            }
          }),
      ],
    );
  }

  Widget _buildBudgetsSection(AppLocalizations l10n) {
    // Category color map for progress bars
    const categoryColors = {
      'Food & Dining': Color(0xFF10B981),
      'Groceries': Color(0xFF059669),
      'Transport': Color(0xFF3B82F6),
      'Entertainment': Color(0xFFE11D48),
      'Shopping': Color(0xFFF59E0B),
      'Utilities': Color(0xFF8B5CF6),
      'Income': Color(0xFF10B981),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.budgets.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            GestureDetector(
              onTap: _showAddBudgetSheet,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.add, color: AppColors.gold, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_budgets.isEmpty)
          _buildGlassCard(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'No budgets set. Tap + to create one.',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
            ),
          )
        else
          _buildGlassCard(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: _budgets.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final budget = entry.value;
                  final color = categoryColors[budget.categoryName] ?? AppColors.textSecondary;
                  final progressColor = budget.isOverBudget
                      ? AppColors.ruby
                      : budget.isNearLimit
                          ? AppColors.gold
                          : color;

                  return Column(
                    children: [
                      if (idx > 0) const SizedBox(height: 15),
                      Dismissible(
                        key: Key(budget.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete_outline, color: AppColors.ruby, size: 22),
                        ),
                        onDismissed: (_) => _deleteBudget(budget.id),
                        child: _buildBudgetProgressBar(
                          budget.categoryName,
                          budget.progress,
                          '\$${budget.currentSpent.toStringAsFixed(0)} / \$${budget.limitAmount.toStringAsFixed(0)}',
                          progressColor,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBudgetProgressBar(String category, double progress, String detailText, Color progressColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text(detailText, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.textSecondary.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ),
      ],
    );
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

  Widget _buildRecentTransactionsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recentTransactions.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        if (_transactions.isEmpty)
          _buildGlassCard(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'No recent transactions.',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
            ),
          )
        else
          ..._transactions.map((tx) {
            final result = TransactionCategorizer.categorize(tx.rawDescription, tx.amount);
            final isExpense = tx.amount < 0;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildGlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Category Icon with soft background
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: _getColorFromHex(result.categoryColorHex).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconData(result.categoryIconName),
                          color: _getColorFromHex(result.categoryColorHex),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Cleaned merchant name, category, and confidence
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.cleanedMerchantName,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  result.categoryName,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _getColorFromHex(result.categoryColorHex),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.textSecondary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${(result.confidenceScore * 100).toInt()}% AI',
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Amount
                      Text(
                        '${isExpense ? '-' : '+'}\$${tx.amount.abs().toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isExpense ? AppColors.textPrimary : AppColors.emerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}

class SpendingTrendPainter extends CustomPainter {
  final List<double> dailyData;

  SpendingTrendPainter({required this.dailyData});

  @override
  void paint(Canvas canvas, Size size) {
    if (dailyData.isEmpty) return;

    final maxVal = dailyData.reduce((a, b) => a > b ? a : b);
    final effectiveMax = maxVal > 0 ? maxVal : 1.0;

    // Normalize data points to canvas coordinates
    final points = <Offset>[];
    for (int i = 0; i < dailyData.length; i++) {
      final x = (i / (dailyData.length - 1)) * size.width;
      final y = size.height - (dailyData[i] / effectiveMax) * (size.height * 0.85);
      points.add(Offset(x, y));
    }

    // Draw gradient fill under the curve
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, size.height);
    for (int i = 0; i < points.length - 1; i++) {
      final cp1x = points[i].dx + (points[i + 1].dx - points[i].dx) * 0.4;
      final cp2x = points[i].dx + (points[i + 1].dx - points[i].dx) * 0.6;
      fillPath.cubicTo(cp1x, points[i].dy, cp2x, points[i + 1].dy,
          points[i + 1].dx, points[i + 1].dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.emerald.withValues(alpha: 0.35),
          AppColors.emerald.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // Draw the smooth Bezier curve line
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final cp1x = points[i].dx + (points[i + 1].dx - points[i].dx) * 0.4;
      final cp2x = points[i].dx + (points[i + 1].dx - points[i].dx) * 0.6;
      linePath.cubicTo(cp1x, points[i].dy, cp2x, points[i + 1].dy,
          points[i + 1].dx, points[i + 1].dy);
    }

    final linePaint = Paint()
      ..color = AppColors.emerald
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Draw data point dots
    final dotPaint = Paint()
      ..color = AppColors.emerald
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = AppColors.backgroundEnd
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotBorderPaint);
      canvas.drawCircle(point, 2.5, dotPaint);
    }

    // Draw horizontal grid lines (subtle)
    final gridPaint = Paint()
      ..color = const Color(0x15FFFFFF)
      ..strokeWidth = 0.5;
    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SpendingTrendPainter oldDelegate) {
    if (oldDelegate.dailyData.length != dailyData.length) return true;
    for (int i = 0; i < dailyData.length; i++) {
      if (oldDelegate.dailyData[i] != dailyData[i]) return true;
    }
    return false;
  }
}
