// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Ласкаво просимо до Aura Finance';

  @override
  String get onboardingAutomated => 'Автоматичне відстеження щоденних витрат.';

  @override
  String get onboardingAISecure =>
      'Категорії на базі AI з банківською безпекою.';

  @override
  String get netWorth => 'Чисті активи';

  @override
  String get recentTransactions => 'Останні транзакції';

  @override
  String get subscriptions => 'Підписки';

  @override
  String get budgets => 'Бюджети';

  @override
  String get addTransaction => 'Додати транзакцію';

  @override
  String get settings => 'Налаштування';

  @override
  String get syncing => 'Синхронізація транзакцій...';
}
