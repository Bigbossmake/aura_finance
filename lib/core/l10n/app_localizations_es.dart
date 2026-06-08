// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Bienvenido a Aura Finance';

  @override
  String get onboardingAutomated =>
      'Seguimiento automático de sus gastos diarios.';

  @override
  String get onboardingAISecure =>
      'Categorías impulsadas por IA con seguridad bancaria.';

  @override
  String get netWorth => 'Patrimonio neto';

  @override
  String get recentTransactions => 'Transacciones recientes';

  @override
  String get subscriptions => 'Suscripciones';

  @override
  String get budgets => 'Presupuestos';

  @override
  String get addTransaction => 'Agregar transacción';

  @override
  String get settings => 'Configuración';

  @override
  String get syncing => 'Sincronizando transacciones...';
}
