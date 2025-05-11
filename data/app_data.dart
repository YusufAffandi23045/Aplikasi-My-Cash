import '../models/transaction.dart';
import '../models/account.dart';
import '../models/goals.dart';

class AppData {
  static final AppData _instance = AppData._internal();

  factory AppData() {
    return _instance;
  }

  AppData._internal();

  // Data storage
  List<Transaction> transactions = [];
  List<Account> accounts = [];
  List<Goal> goals = [];
  String currentAccountId = '';
  bool _isInitialized = false;

  // Initialize with default account
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Try to load saved data
      final savedData = await DataPersistence.loadAllData();

      transactions = savedData['transactions'];
      accounts = savedData['accounts'];
      goals = savedData['goals'];
      currentAccountId = savedData['currentAccountId'];

      // If no accounts, create default account
      if (accounts.isEmpty) {
        final defaultAccount = Account(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Utama',
          description: 'Akun default',
        );
        accounts.add(defaultAccount);
        currentAccountId = defaultAccount.id;
      }

      _isInitialized = true;
    } catch (e) {
      print('Error loading data: $e');
      // If error, ensure there's at least one account
      if (accounts.isEmpty) {
        final defaultAccount = Account(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Utama',
          description: 'Akun default',
        );
        accounts.add(defaultAccount);
        currentAccountId = defaultAccount.id;
      }
      _isInitialized = true;
    }
  }

  // Save all data
  Future<void> saveData() async {
    await DataPersistence.saveAllData(
      transactions: transactions,
      accounts: accounts,
      goals: goals,
      currentAccountId: currentAccountId,
    );
  }

  // Get current account
  Account? get currentAccount {
    if (currentAccountId.isEmpty) return null;
    try {
      return accounts.firstWhere((account) => account.id == currentAccountId);
    } catch (e) {
      return accounts.isNotEmpty ? accounts.first : null;
    }
  }

  // Get transactions for current account
  List<Transaction> get currentAccountTransactions {
    if (currentAccountId.isEmpty) return [];
    return transactions.where((t) => t.accountId == currentAccountId).toList();
  }

  // Calculate total income for current account
  double get totalIncome {
    return currentAccountTransactions
        .where((t) => t.isIncome)
        .fold(0, (sum, item) => sum + item.amount);
  }

  // Calculate total expense for current account
  double get totalExpense {
    return currentAccountTransactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, item) => sum + item.amount);
  }

  // Calculate balance for current account
  double get currentBalance {
    return totalIncome - totalExpense;
  }

  // Update account balances based on transactions
  void updateAccountBalances() {
    for (var account in accounts) {
      final accountTransactions = transactions
          .where((t) => t.accountId == account.id)
          .toList();

      double income = accountTransactions
          .where((t) => t.isIncome)
          .fold(0, (sum, item) => sum + item.amount);

      double expense = accountTransactions
          .where((t) => !t.isIncome)
          .fold(0, (sum, item) => sum + item.amount);

      account.balance = income - expense;
    }

    // Save changes
    saveData();
  }

  // Category-wise expense breakdown for current account
  Map<String, double> get categoryExpenses {
    final Map<String, double> result = {};

    for (var transaction in currentAccountTransactions.where((t) => !t.isIncome)) {
      if (result.containsKey(transaction.category)) {
        result[transaction.category] = result[transaction.category]! + transaction.amount;
      } else {
        result[transaction.category] = transaction.amount;
      }
    }

    return result;
  }

  // Add money to goal
  void addToGoal(String goalId, double amount) {
    final index = goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      goals[index].currentAmount += amount;
      saveData();
    }
  }

  // Add a transaction
  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    updateAccountBalances();
    saveData();
  }

  // Add account
  void addAccount(Account account) {
    accounts.add(account);
    saveData();
  }

  // Add goal
  void addGoal(Goal goal) {
    goals.add(goal);
    saveData();
  }
}