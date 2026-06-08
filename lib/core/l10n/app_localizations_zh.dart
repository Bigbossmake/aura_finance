// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => '欢迎使用 Aura Finance';

  @override
  String get onboardingAutomated => '自动追踪您的日常支出。';

  @override
  String get onboardingAISecure => '具备银行级安全性的 AI 智能分类。';

  @override
  String get netWorth => '净资产';

  @override
  String get recentTransactions => '最近交易';

  @override
  String get subscriptions => '订阅管理';

  @override
  String get budgets => '预算管理';

  @override
  String get addTransaction => '添加交易';

  @override
  String get settings => '设置';

  @override
  String get syncing => '正在同步交易...';
}
