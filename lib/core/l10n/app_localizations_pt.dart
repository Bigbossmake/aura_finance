// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Aura Finance';

  @override
  String get onboardingWelcome => 'Bem-vindo ao Aura Finance';

  @override
  String get onboardingAutomated =>
      'Rastreamento automático dos seus gastos diários.';

  @override
  String get onboardingAISecure =>
      'Categorias orientadas por IA com segurança bancária.';

  @override
  String get netWorth => 'Patrimônio líquido';

  @override
  String get recentTransactions => 'Transações recentes';

  @override
  String get subscriptions => 'Assinaturas';

  @override
  String get budgets => 'Orçamentos';

  @override
  String get addTransaction => 'Adicionar transação';

  @override
  String get settings => 'Configurações';

  @override
  String get syncing => 'Sincronizando transações...';
}
