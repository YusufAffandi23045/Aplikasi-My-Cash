import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/account.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final AppData _appData = AppData();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appData.init(); // Ensure there's at least one account
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: const Color(0xFFF0F2F5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'List Akun',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: _appData.accounts.isEmpty
                ? const Center(
              child: Text('Belum ada akun yang tersedia'),
            )
                : ListView.builder(
              itemCount: _appData.accounts.length,
              itemBuilder: (context, index) {
                final account = _appData.accounts[index];
                return _buildAccountCard(account);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAccountDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAccountCard(Account account) {
    bool isSelected = account.id == _appData.currentAccountId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isSelected ? Colors.teal.shade50 : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _appData.currentAccountId = account.id;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.teal : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.teal : Colors.black87,
                      ),
                    ),
                    if (account.description.isNotEmpty)
                      Text(
                        account.description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rp ${account.balance.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: account.balance >= 0 ? Colors.teal : Colors.red,
                    ),
                  ),
                  if (isSelected)
                    const Chip(
                      label: Text('Aktif'),
                      backgroundColor: Colors.teal,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAccountDialog() {
    _nameController.clear();
    _descriptionController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Akun Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Akun',
                    hintText: 'Contoh: Bisnis, Kuliah, dll',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi (opsional)',
                    hintText: 'Deskripsi singkat tentang akun ini',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    final newAccount = Account(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      description: _descriptionController.text.trim(),
                    );
                    _appData.accounts.add(newAccount);
                    _appData.currentAccountId = newAccount.id;
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}