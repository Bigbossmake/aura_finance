// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Bienvenue sur Aura Finance';

  @override
  String get onboardingAutomated =>
      'Suivi automatique de vos dépenses quotidiennes.';

  @override
  String get onboardingAISecure =>
      'Catégories gérées par IA avec sécurité bancaire.';

  @override
  String get netWorth => 'Patrimoine net';

  @override
  String get recentTransactions => 'Transactions récentes';

  @override
  String get subscriptions => 'Abonnements';

  @override
  String get budgets => 'Budgets';

  @override
  String get addTransaction => 'Ajouter transaction';

  @override
  String get settings => 'Paramètres';

  @override
  String get syncing => 'Synchronisation des transactions...';
}
