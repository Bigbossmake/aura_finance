// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Selamat Datang di Aura Finance';

  @override
  String get onboardingAutomated =>
      'Pelacakan otomatis pengeluaran harian Anda.';

  @override
  String get onboardingAISecure =>
      'Kategori berbasis AI dengan keamanan tingkat bank.';

  @override
  String get netWorth => 'Kekayaan Bersih';

  @override
  String get recentTransactions => 'Transaksi Terakhir';

  @override
  String get subscriptions => 'Langganan';

  @override
  String get budgets => 'Anggaran';

  @override
  String get addTransaction => 'Tambah Transaksi';

  @override
  String get settings => 'Pengaturan';

  @override
  String get syncing => 'Menyinkronkan transaksi...';
}
