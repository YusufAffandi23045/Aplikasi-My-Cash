import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final AppData _appData = AppData();

  bool _isIncome = true;
  String _selectedCategory = 'Umum';
  DateTime _selectedDate = DateTime.now();

  final List<String> _expenseCategories = [
    'Makanan',
    'Transportasi',
    'Belanja',
    'Hiburan',
    'Pendidikan',
    'Kesehatan',
    'Tagihan',
    'Umum',
  ];

  final List<String> _incomeCategories = [
    'Gaji',
    'Bonus',
    'Hadiah',
    'Investasi',
    'Penjualan',
    'Umum',
  ];

  @override
  void initState() {
    super.initState();
    _appData.init(); // Ensure there's at least one account
  }

  void _saveTransaction() {
    final name = _nameController.text;
    final amount = double.tryParse(
        _amountController.text.replaceAll('.', '').replaceAll(',', '')
    );

    if (name.isNotEmpty && amount != null) {
      // Create transaction with current account
      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        amount: amount,
        isIncome: _isIncome,
        category: _selectedCategory,
        date: _selectedDate,
        accountId: _appData.currentAccountId,
      );

      // Add transaction and update balance
      _appData.transactions.add(newTransaction);
      _appData.updateAccountBalances();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentAccount = _appData.currentAccount;
    final availableCategories = _isIncome ? _incomeCategories : _expenseCategories;

    if (availableCategories.contains(_selectedCategory) == false) {
      _selectedCategory = availableCategories.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF0F2F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Selection
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.account_balance_wallet, color: Colors.teal),
                  title: const Text('Akun'),
                  subtitle: Text(currentAccount?.name ?? 'Akun Utama'),
                  trailing: TextButton(
                    child: const Text('Ganti'),
                    onPressed: () {
                      // Show account selection dialog
                      _showAccountSelectionDialog();
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Transaction Type Selection
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton('Pemasukan', true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTypeButton('Pengeluaran', false),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Transaction Fields
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Transaksi',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah (Rp)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
              ),

              const SizedBox(height: 16),

              // Category Selection
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    hint: const Text('Pilih Kategori'),
                    items: availableCategories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Date Selection
              InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 1)),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 16),
                      Text(
                        DateFormat('dd MMMM yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Simpan Transaksi', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String title, bool type) {
    bool isSelected = _isIncome == type;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isIncome = type;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.teal : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.teal,
        elevation: isSelected ? 4 : 2,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.teal, width: 1),
      ),
      child: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }

  void _showAccountSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Akun'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _appData.accounts.length,
              itemBuilder: (context, index) {
                final account = _appData.accounts[index];
                final isSelected = account.id == _appData.currentAccountId;

                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal.shade50 : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: isSelected ? Colors.teal : Colors.grey,
                    ),
                  ),
                  title: Text(account.name),
                  subtitle: Text(
                    'Saldo: Rp ${account.balance.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: account.balance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.teal)
                      : null,
                  onTap: () {
                    setState(() {
                      _appData.currentAccountId = account.id;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }
}