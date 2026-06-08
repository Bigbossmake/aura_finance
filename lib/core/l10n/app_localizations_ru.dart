// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Добро пожаловать в Aura Finance';

  @override
  String get onboardingAutomated =>
      'Автоматическое отслеживание ежедневных расходов.';

  @override
  String get onboardingAISecure =>
      'AI-категоризация и безопасность банковского уровня.';

  @override
  String get netWorth => 'Чистые активы';

  @override
  String get recentTransactions => 'Последние транзакции';

  @override
  String get subscriptions => 'Подписки';

  @override
  String get budgets => 'Бюджеты';

  @override
  String get addTransaction => 'Добавить транзакцию';

  @override
  String get settings => 'Настройки';

  @override
  String get syncing => 'Синхронизация транзакций...';
}
