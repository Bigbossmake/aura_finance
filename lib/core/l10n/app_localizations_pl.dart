// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Witaj w Aura Finance';

  @override
  String get onboardingAutomated =>
      'Automatyczne śledzenie codziennych wydatków.';

  @override
  String get onboardingAISecure =>
      'Kategorie oparte na AI z zabezpieczeniami bankowymi.';

  @override
  String get netWorth => 'Majątek netto';

  @override
  String get recentTransactions => 'Ostatnie transakcje';

  @override
  String get subscriptions => 'Subskrypcje';

  @override
  String get budgets => 'Budżety';

  @override
  String get addTransaction => 'Dodaj transakcję';

  @override
  String get settings => 'Ustawienia';

  @override
  String get syncing => 'Synchronizacja transakcji...';
}
