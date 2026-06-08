// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Aura Finance में आपका स्वागत है';

  @override
  String get onboardingAutomated => 'आपके दैनिक खर्चों की स्वचालित ट्रैकिंग।';

  @override
  String get onboardingAISecure =>
      'बैंकिंग-ग्रेड सुरक्षा के साथ AI-संचालित श्रेणियां।';

  @override
  String get netWorth => 'कुल संपत्ति';

  @override
  String get recentTransactions => 'हाल के लेनदेन';

  @override
  String get subscriptions => 'सदस्यता';

  @override
  String get budgets => 'बजट';

  @override
  String get addTransaction => 'लेनदेन जोड़ें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get syncing => 'लेनदेन सिंक हो रहे हैं...';
}
