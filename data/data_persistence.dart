import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/account.dart';
import '../models/goals.dart';

class DataPersistence {
  // Keys for SharedPreferences
  static const String _transactionsKey = 'transactions';
  static const String _accountsKey = 'accounts';
  static const String _goalsKey = 'goals';
  static const String _currentAccountIdKey = 'currentAccountId';

  // Save all data
  static Future<void> saveAllData({
    required List<Transaction> transactions,
    required List<Account> accounts,
    required List<Goal> goals,
    required String currentAccountId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert transactions to JSON
    final transactionsJson = transactions.map((transaction) => {
      'id': transaction.id,
      'name': transaction.name,
      'amount': transaction.amount,
      'isIncome': transaction.isIncome,
      'date': transaction.date.millisecondsSinceEpoch,
      'category': transaction.category,
      'accountId': transaction.accountId,
    }).toList();

    // Convert accounts to JSON
    final accountsJson = accounts.map((account) => {
      'id': account.id,
      'name': account.name,
      'balance': account.balance,
      'description': account.description,
      'iconName': account.iconName,
    }).toList();

    // Convert goals to JSON
    final goalsJson = goals.map((goal) => {
      'id': goal.id,
      'name': goal.name,
      'targetAmount': goal.targetAmount,
      'currentAmount': goal.currentAmount,
      'targetDate': goal.targetDate.millisecondsSinceEpoch,
      'iconName': goal.iconName,
    }).toList();

    // Save to SharedPreferences
    await prefs.setString(_transactionsKey, jsonEncode(transactionsJson));
    await prefs.setString(_accountsKey, jsonEncode(accountsJson));
    await prefs.setString(_goalsKey, jsonEncode(goalsJson));
    await prefs.setString(_currentAccountIdKey, currentAccountId);
  }

  // Load all data
  static Future<Map<String, dynamic>> loadAllData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load transactions
    final transactionsJson = prefs.getString(_transactionsKey);
    List<Transaction> transactions = [];

    if (transactionsJson != null) {
      final List<dynamic> decoded = jsonDecode(transactionsJson);
      transactions = decoded.map((item) => Transaction(
        id: item['id'],
        name: item['name'],
        amount: item['amount'],
        isIncome: item['isIncome'],
        date: DateTime.fromMillisecondsSinceEpoch(item['date']),
        category: item['category'],
        accountId: item['accountId'],
      )).toList();
    }

    // Load accounts
    final accountsJson = prefs.getString(_accountsKey);
    List<Account> accounts = [];

    if (accountsJson != null) {
      final List<dynamic> decoded = jsonDecode(accountsJson);
      accounts = decoded.map((item) => Account(
        id: item['id'],
        name: item['name'],
        balance: item['balance'],
        description: item['description'],
        iconName: item['iconName'],
      )).toList();
    }

    // Load goals
    final goalsJson = prefs.getString(_goalsKey);
    List<Goal> goals = [];

    if (goalsJson != null) {
      final List<dynamic> decoded = jsonDecode(goalsJson);
      goals = decoded.map((item) => Goal(
        id: item['id'],
        name: item['name'],
        targetAmount: item['targetAmount'],
        currentAmount: item['currentAmount'],
        targetDate: DateTime.fromMillisecondsSinceEpoch(item['targetDate']),
        iconName: item['iconName'],
      )).toList();
    }

    // Load current account ID
    final currentAccountId = prefs.getString(_currentAccountIdKey) ?? '';

    return {
      'transactions': transactions,
      'accounts': accounts,
      'goals': goals,
      'currentAccountId': currentAccountId,
    };
  }

  // Clear all data (for reset/logout)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}