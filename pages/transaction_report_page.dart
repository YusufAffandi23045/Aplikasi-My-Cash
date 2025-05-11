import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class LaporanTransaksiPage extends StatefulWidget {
  const LaporanTransaksiPage({super.key});

  @override
  State<LaporanTransaksiPage> createState() => _LaporanTransaksiPageState();
}

class _LaporanTransaksiPageState extends State<LaporanTransaksiPage> {
  final AppData _appData = AppData();
  String _filterType = 'Semua';

  @override
  Widget build(BuildContext context) {
    final transactions = _appData.currentAccountTransactions;
    double saldoTotal = _appData.currentBalance;

    // Filter transactions if needed
    List<Transaction> filteredTransactions = transactions;
    if (_filterType == 'Pemasukan') {
      filteredTransactions = transactions.where((t) => t.isIncome).toList();
    } else if (_filterType == 'Pengeluaran') {
      filteredTransactions = transactions.where((t) => !t.isIncome).toList();
    }

    // Sort transactions by date (newest first)
    filteredTransactions.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Transaksi'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF0F2F5),
      body: Column(
        children: [
          // Account Info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.teal),
                const SizedBox(width: 12),
                Text(
                  _appData.currentAccount?.name ?? 'Akun Utama',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Saldo: Rp ${saldoTotal.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: saldoTotal >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Filter Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterButton('Semua'),
                const SizedBox(width: 8),
                _buildFilterButton('Pemasukan'),
                const SizedBox(width: 8),
                _buildFilterButton('Pengeluaran'),
              ],
            ),
          ),

          // Transaction List
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada $_filterType',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaksi = filteredTransactions[index];

                // Group transactions by date
                bool showDateHeader = false;

                if (index == 0) {
                  showDateHeader = true;
                } else {
                  final prevDate = filteredTransactions[index - 1].date;
                  showDateHeader = !isSameDay(prevDate, transaksi.date);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader) ...[
                      const SizedBox(height: 16),
                      _buildDateHeader(transaksi.date),
                    ],
                    _buildTransactionCard(transaksi),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title) {
    final isSelected = _filterType == title;

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _filterType = title;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.teal : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          elevation: isSelected ? 2 : 0,
          side: BorderSide(
            color: isSelected ? Colors.teal : Colors.grey.shade300,
          ),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    String headerText;

    if (isSameDay(date, DateTime.now())) {
      headerText = 'Hari Ini';
    } else if (isSameDay(date, DateTime.now().subtract(const Duration(days: 1)))) {
      headerText = 'Kemarin';
    } else {
      headerText = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        headerText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: transaction.isIncome
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                transaction.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: transaction.isIncome ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.category,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp ${transaction.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: transaction.isIncome ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(transaction.date),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}