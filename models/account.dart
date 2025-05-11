class Account {
  String id;
  String name;
  double balance;
  String description;
  String iconName;

  Account({
    required this.id,
    required this.name,
    this.balance = 0.0,
    this.description = '',
    this.iconName = 'account_balance_wallet',
  });
}