
class Transaction {
  String id;
  String name;
  double amount;
  bool isIncome;
  DateTime date;
  String category;
  String accountId;

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.isIncome,
    required this.accountId,
    DateTime? date,
    this.category = 'Umum',
  }) : date = date ?? DateTime.now();
}