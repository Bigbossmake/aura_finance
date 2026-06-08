import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// 1. Users Table
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text().nullable()();
  BoolColumn get biometricEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get currencyDefault => text().withDefault(const Constant('USD'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Bank Connections Table
class BankConnections extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get institutionId => text()();
  TextColumn get institutionName => text()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get aggregator => text()(); // 'plaid', 'gocardless'
  TextColumn get status => text()(); // 'active', 'auth_expired', 'revoked'
  TextColumn get encryptedAccessToken => text()();
  DateTimeColumn get consentExpiresAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 3. Bank Accounts Table
class BankAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get connectionId => text().references(BankConnections, #id, onDelete: KeyAction.cascade)();
  TextColumn get externalAccountId => text()();
  TextColumn get name => text()();
  TextColumn get mask => text()();
  TextColumn get type => text()(); // 'depository', 'credit'
  TextColumn get subtype => text().nullable()(); // 'checking', 'savings'
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  RealColumn get balanceAvailable => real().nullable()();
  RealColumn get balanceCurrent => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. Categories Table
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get iconName => text()();
  TextColumn get colorHex => text()();
  TextColumn get parentId => text().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 5. Transactions Table
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(BankAccounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get externalTransactionId => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get merchantName => text().nullable()();
  TextColumn get rawDescription => text()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get authorizedDate => dateTime().nullable()();
  TextColumn get categoryId => text().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  RealColumn get aiConfidence => real().nullable()();
  BoolColumn get isPending => boolean().withDefault(const Constant(false))();
  BoolColumn get isSubscription => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 6. Subscriptions Table
class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get categoryId => text().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get frequency => text()(); // 'weekly', 'monthly', 'yearly'
  DateTimeColumn get nextBillingDate => dateTime()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  RealColumn get confidenceScore => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 7. Budgets Table
class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get categoryId => text().references(Categories, #id, onDelete: KeyAction.cascade)();
  RealColumn get limitAmount => real()();
  RealColumn get currentSpent => real().withDefault(const Constant(0.0))();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  TextColumn get periodType => text().withDefault(const Constant('monthly'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 8. Dashboard Widgets Table
class DashboardWidgets extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get widgetType => text()();
  IntColumn get positionIndex => integer()();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
  TextColumn get settingsJson => text().nullable()(); // settings stored as JSON
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Drift Database Class
@DriftDatabase(tables: [
  Users,
  BankConnections,
  BankAccounts,
  Categories,
  Transactions,
  Subscriptions,
  Budgets,
  DashboardWidgets
])
class AppDatabase extends _$AppDatabase {
  static final AppDatabase instance = AppDatabase();

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      
      // 1. Seed dummy user
      await into(users).insert(UsersCompanion.insert(
        id: 'dummy_user',
        email: 'user@aurafinance.app',
        biometricEnabled: const Value(true),
        currencyDefault: const Value('USD'),
      ));
      
      // 2. Seed dummy connection
      await into(bankConnections).insert(BankConnectionsCompanion.insert(
        id: 'dummy_connection',
        userId: 'dummy_user',
        institutionId: 'ins_mock',
        institutionName: 'Aura Premium Bank',
        aggregator: 'plaid',
        status: 'active',
        encryptedAccessToken: 'access_token_encrypted_mock_val',
      ));
      
      // 3. Seed dummy checking account
      await into(bankAccounts).insert(BankAccountsCompanion.insert(
        id: 'dummy_account',
        connectionId: 'dummy_connection',
        externalAccountId: 'acc_external_mock_123',
        name: 'Aura Premium Checking',
        mask: '4321',
        type: 'depository',
        subtype: const Value('checking'),
        currency: const Value('USD'),
        balanceCurrent: 12480.50,
      ));
      
      // 4. Seed default categories mapped by our categorizer
      final defaultCategories = [
        {'id': 'cat_food', 'name': 'Food & Dining', 'icon': 'local_cafe', 'color': '#FF10B981'},
        {'id': 'cat_groceries', 'name': 'Groceries', 'icon': 'local_grocery_store', 'color': '#FF059669'},
        {'id': 'cat_transport', 'name': 'Transport', 'icon': 'local_taxi', 'color': '#FF3B82F6'},
        {'id': 'cat_entertainment', 'name': 'Entertainment', 'icon': 'movie', 'color': '#FFE11D48'},
        {'id': 'cat_shopping', 'name': 'Shopping', 'icon': 'shopping_bag', 'color': '#FFF59E0B'},
        {'id': 'cat_utilities', 'name': 'Utilities', 'icon': 'phone_android', 'color': '#FF8B5CF6'},
        {'id': 'cat_income', 'name': 'Income', 'icon': 'payments', 'color': '#FF10B981'},
      ];
      
      for (var cat in defaultCategories) {
        await into(categories).insert(CategoriesCompanion.insert(
          id: cat['id']!,
          name: cat['name']!,
          iconName: cat['icon']!,
          colorHex: cat['color']!,
        ));
      }

      // 5. Seed default budgets for demo categories
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      final defaultBudgets = [
        {'id': 'budget_shopping', 'categoryId': 'cat_shopping', 'limit': 500.0},
        {'id': 'budget_food', 'categoryId': 'cat_food', 'limit': 300.0},
        {'id': 'budget_entertainment', 'categoryId': 'cat_entertainment', 'limit': 200.0},
      ];

      for (var b in defaultBudgets) {
        await into(budgets).insert(BudgetsCompanion.insert(
          id: b['id'] as String,
          userId: 'dummy_user',
          categoryId: b['categoryId'] as String,
          limitAmount: b['limit'] as double,
          periodStart: monthStart,
          periodEnd: monthEnd,
        ));
      }
    },
  );

  // Retrieve all transactions sorted by date descending
  Future<List<Transaction>> getAllTransactions() {
    return (select(transactions)
      ..orderBy([(t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)]))
      .get();
  }

  // Insert new transaction
  Future<int> insertTransaction(TransactionsCompanion entry) {
    return into(transactions).insert(entry);
  }

  // Clear transactions (for reset)
  Future<void> clearTransactions() {
    return delete(transactions).go();
  }

  // --- Budget helpers ---

  // Retrieve all budgets
  Future<List<Budget>> getAllBudgets() {
    return select(budgets).get();
  }

  // Retrieve a specific category by ID
  Future<Category?> getCategoryById(String id) {
    return (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  // Retrieve all categories
  Future<List<Category>> getAllCategories() {
    return select(categories).get();
  }

  // Insert a new budget
  Future<int> insertBudget(BudgetsCompanion entry) {
    return into(budgets).insert(entry);
  }

  // Delete a budget by ID
  Future<int> deleteBudget(String id) {
    return (delete(budgets)..where((b) => b.id.equals(id))).go();
  }
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'aura_finance.sqlite'));
    
    // Note: SQLCipher integration for SQLite encryption is configured at native layer.
    // In production, we initialize the Database using a custom key from Android Keystore / KeyStore API.
    return NativeDatabase.createInBackground(file);
  });
}
