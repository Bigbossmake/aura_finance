// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Aura Finance\'a Hoş Geldiniz';

  @override
  String get onboardingAutomated => 'Günlük harcamalarınızın otomatik takibi.';

  @override
  String get onboardingAISecure =>
      'Banka düzeyinde güvenlikli yapay zeka kategorileri.';

  @override
  String get netWorth => 'Net Değer';

  @override
  String get recentTransactions => 'Son İşlemler';

  @override
  String get subscriptions => 'Abonelikler';

  @override
  String get budgets => 'Bütçeler';

  @override
  String get addTransaction => 'İşlem Ekle';

  @override
  String get settings => 'Ayarlar';

  @override
  String get syncing => 'İşlemler senkronize ediliyor...';
}
