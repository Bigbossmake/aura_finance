// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Chào mừng đến với Aura Finance';

  @override
  String get onboardingAutomated =>
      'Tự động theo dõi chi tiêu hàng ngày của bạn.';

  @override
  String get onboardingAISecure =>
      'Phân loại bằng AI với bảo mật cấp ngân hàng.';

  @override
  String get netWorth => 'Giá trị tài sản ròng';

  @override
  String get recentTransactions => 'Giao dịch gần đây';

  @override
  String get subscriptions => 'Khoản đăng ký';

  @override
  String get budgets => 'Ngân sách';

  @override
  String get addTransaction => 'Thêm giao dịch';

  @override
  String get settings => 'Cài đặt';

  @override
  String get syncing => 'Đang đồng bộ giao dịch...';
}
