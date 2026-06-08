// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Willkommen bei Aura Finance';

  @override
  String get onboardingAutomated =>
      'Automatische Verfolgung Ihrer täglichen Ausgaben.';

  @override
  String get onboardingAISecure =>
      'KI-gestützte Kategorien mit Bankensicherheit.';

  @override
  String get netWorth => 'Nettovermögen';

  @override
  String get recentTransactions => 'Kürzliche Transaktionen';

  @override
  String get subscriptions => 'Abonnements';

  @override
  String get budgets => 'Budgets';

  @override
  String get addTransaction => 'Transaktion hinzufügen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get syncing => 'Transaktionen werden synchronisiert...';
}
