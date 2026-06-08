// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Welkom bij Aura Finance';

  @override
  String get onboardingAutomated =>
      'Automatische tracking van uw dagelijkse uitgaven.';

  @override
  String get onboardingAISecure =>
      'AI-gestuurde categorieën met bankbeveiliging.';

  @override
  String get netWorth => 'Nettowaarde';

  @override
  String get recentTransactions => 'Recente transacties';

  @override
  String get subscriptions => 'Abonnementen';

  @override
  String get budgets => 'Budgetten';

  @override
  String get addTransaction => 'Transactie toevoegen';

  @override
  String get settings => 'Instellingen';

  @override
  String get syncing => 'Transacties synchroniseren...';
}
