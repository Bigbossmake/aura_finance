// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Aura Finance에 오신 것을 환영합니다';

  @override
  String get onboardingAutomated => '일일 지출을 자동으로 추적합니다.';

  @override
  String get onboardingAISecure => '은행 수준의 보안을 적용한 AI 카테고리 분류.';

  @override
  String get netWorth => '순자산';

  @override
  String get recentTransactions => '최근 거래';

  @override
  String get subscriptions => '구독 목록';

  @override
  String get budgets => '예산';

  @override
  String get addTransaction => '거래 추가';

  @override
  String get settings => '설정';

  @override
  String get syncing => '거래 동기화 중...';
}
