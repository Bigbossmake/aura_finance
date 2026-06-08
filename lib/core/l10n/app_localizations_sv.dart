// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Välkommen till Aura Finance';

  @override
  String get onboardingAutomated =>
      'Automatisk spårning av dina dagliga utgifter.';

  @override
  String get onboardingAISecure =>
      'AI-kategorisering med säkerhet i bankklass.';

  @override
  String get netWorth => 'Nettovärde';

  @override
  String get recentTransactions => 'Senaste transaktioner';

  @override
  String get subscriptions => 'Prenumerationer';

  @override
  String get budgets => 'Budgetar';

  @override
  String get addTransaction => 'Lägg till transaktion';

  @override
  String get settings => 'Inställningar';

  @override
  String get syncing => 'Synkroniserar transaktioner...';
}
