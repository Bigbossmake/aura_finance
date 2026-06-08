// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'ยินดีต้อนรับสู่ Aura Finance';

  @override
  String get onboardingAutomated => 'ติดตามรายจ่ายประจำวันของคุณโดยอัตโนมัติ';

  @override
  String get onboardingAISecure =>
      'จัดหมวดหมู่ด้วย AI พร้อมความปลอดภัยระดับธนาคาร';

  @override
  String get netWorth => 'สินทรัพย์สุทธิ';

  @override
  String get recentTransactions => 'รายการล่าสุด';

  @override
  String get subscriptions => 'การเป็นสมาชิก';

  @override
  String get budgets => 'งบประมาณ';

  @override
  String get addTransaction => 'เพิ่มรายการ';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get syncing => 'กำลังซิงค์รายการ...';
}
