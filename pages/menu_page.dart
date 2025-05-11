import 'package:flutter/material.dart';
import 'add_transaction_page.dart';
import 'transaction_report_page.dart';
import 'goals_page.dart';
import 'statistics_page.dart';
import 'account_page.dart';
import '../menu.dart';
import '../data/app_data.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final AppData _appData = AppData();

  @override
  void initState() {
    super.initState();
    _appData.init(); // Initialize with default account
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: const Text('MyCash', style: TextStyle(fontWeight: FontWeight.w600)
        ),
      ),
      drawer: const MyDrawer(),
      backgroundColor: const Color(0xFFF0F2F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAccountBalance(),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildRecentTransactions(),
            const SizedBox(height: 24),
            if (_appData.goals.isNotEmpty) _buildGoalProgress(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionPage()),
          ).then((_) {
            // Refresh page when returning from add transaction
            setState(() {});
          });
        },
      ),
    );
  }

  Widget _buildAccountBalance() {
    final currentAccount = _appData.currentAccount;
    final balance = _appData.currentBalance;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.white70,
              ),
              const SizedBox(width: 8),
              Text(
                currentAccount?.name ?? 'Akun Utama',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.swap_horiz, color: Colors.white),
                label: const Text(
                  'Ganti Akun',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountsPage()),
                  ).then((_) {
                    setState(() {});
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Saldo Saat Ini',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rp ${balance.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFinancialSummaryItem(
                'Pemasukan',
                _appData.totalIncome,
                Icons.arrow_upward,
                Colors.green,
              ),
              _buildFinancialSummaryItem(
                'Pengeluaran',
                _appData.totalExpense,
                Icons.arrow_downward,
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummaryItem(
      String title,
      double amount,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rp ${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aksi Cepat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickActionItem(
                'Tambah\nTransaksi',
                Icons.add_circle_outline,
                Colors.blue,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddTransactionPage()),
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
              _buildQuickActionItem(
                'Lihat\nLaporan',
                Icons.bar_chart,
                Colors.orange,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StatisticsPage()),
                  );
                },
              ),
              _buildQuickActionItem(
                'Target\nKeuangan',
                Icons.flag_outlined,
                Colors.green,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GoalsPage()),
                  );
                },
              ),
              _buildQuickActionItem(
                'Kelola\nAkun',
                Icons.account_balance_wallet_outlined,
                Colors.purple,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountsPage()),
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final transactions = _appData.currentAccountTransactions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaksi Terakhir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanTransaksiPage()),
                  );
                },
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (transactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada transaksi',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddTransactionPage()),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text('Tambah Transaksi'),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length > 5 ? 5 : transactions.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: transaction.isIncome
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        transaction.isIncome
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: transaction.isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(transaction.name),
                    subtitle: Text(
                      transaction.category,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Text(
                      'Rp ${transaction.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: transaction.isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress() {
    final goals = _appData.goals;
    if (goals.isEmpty) return const SizedBox.shrink();

    // Show the first goal only on home page
    final goal = goals.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Target Keuangan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GoalsPage()),
                  );
                },
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.flag,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          goal.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${goal.daysRemaining} hari tersisa',
                        style: TextStyle(
                          color: goal.daysRemaining < 10
                              ? Colors.red
                              : Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: goal.progressPercentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.teal,
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${goal.currentAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${goal.targetAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Show add funds dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GoalsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text('Tambah Dana'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}