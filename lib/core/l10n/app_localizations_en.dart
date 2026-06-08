// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Welcome to Aura Finance';

  @override
  String get onboardingAutomated =>
      'Automated tracking of your daily spending.';

  @override
  String get onboardingAISecure =>
      'AI-Driven categories with banking-grade security.';

  @override
  String get netWorth => 'Net Worth';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get budgets => 'Budgets';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get settings => 'Settings';

  @override
  String get syncing => 'Syncing transactions...';
}
