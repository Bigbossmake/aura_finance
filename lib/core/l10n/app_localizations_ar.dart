// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أورا فاينانس';

  @override
  String get onboardingWelcome => 'مرحباً بك في أورا فاينانس';

  @override
  String get onboardingAutomated => 'تتبع تلقائي لمصروفاتك اليومية.';

  @override
  String get onboardingAISecure =>
      'تصنيفات مدعومة بالذكاء الاصطناعي مع أمان بنكي.';

  @override
  String get netWorth => 'صافي الثروة';

  @override
  String get recentTransactions => 'المعاملات الأخيرة';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get budgets => 'الميزانيات';

  @override
  String get addTransaction => 'إضافة معاملة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get syncing => 'جاري مزامنة المعاملات...';
}
