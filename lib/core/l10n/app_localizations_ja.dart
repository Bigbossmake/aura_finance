// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Aura Finance へようこそ';

  @override
  String get onboardingAutomated => '毎日の支出を自動的に追跡します。';

  @override
  String get onboardingAISecure => '銀行レベルのセキュリティを備えたAIカテゴリ分類。';

  @override
  String get netWorth => '純資産';

  @override
  String get recentTransactions => '最近の取引';

  @override
  String get subscriptions => 'サブスクリプション';

  @override
  String get budgets => '予算';

  @override
  String get addTransaction => '取引を追加';

  @override
  String get settings => '設定';

  @override
  String get syncing => '取引を同期中...';
}
