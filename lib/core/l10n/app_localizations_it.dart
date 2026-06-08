// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Benvenuto in Aura Finance';

  @override
  String get onboardingAutomated =>
      'Monitoraggio automatico delle spese quotidiane.';

  @override
  String get onboardingAISecure =>
      'Categorie basate su IA con sicurezza bancaria.';

  @override
  String get netWorth => 'Patrimonio netto';

  @override
  String get recentTransactions => 'Transazioni recenti';

  @override
  String get subscriptions => 'Abbonamenti';

  @override
  String get budgets => 'Budget';

  @override
  String get addTransaction => 'Aggiungi transazione';

  @override
  String get settings => 'Impostazioni';

  @override
  String get syncing => 'Sincronizzazione transazioni...';
}
