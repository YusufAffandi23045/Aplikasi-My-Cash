import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/account.dart';
import '../models/goals.dart';
import 'package:intl/intl.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final AppData _appData = AppData();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  final _addAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Keuangan'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: const Color(0xFFF0F2F5),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.teal.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target Keuangan Saya',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.teal.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tetapkan target keuangan dan pantau kemajuan Anda',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _appData.goals.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada target keuangan',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tambahkan target untuk memulai',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _appData.goals.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final goal = _appData.goals[index];
                return _buildGoalCard(goal);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGoalDialog,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add),
        label: const Text('Target Baru'),
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    final formatter = NumberFormat('#,###', 'id_ID');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.flag,
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Target: ${DateFormat('dd MMM yyyy').format(goal.targetDate)}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.teal,
                  onPressed: () => _showAddFundsDialog(goal),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: goal.progressPercentage / 100,
              backgroundColor: Colors.grey.shade200,
              color: Colors.teal,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp ${formatter.format(goal.currentAmount)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp ${formatter.format(goal.targetAmount)}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${goal.progressPercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  '${goal.daysRemaining} hari tersisa',
                  style: TextStyle(
                    color: goal.daysRemaining < 10
                        ? Colors.red
                        : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGoalDialog() {
    _nameController.clear();
    _amountController.clear();
    _selectedDate = DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tambah Target Baru'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Target',
                        hintText: 'Contoh: Beli Laptop',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Target (Rp)',
                        hintText: 'Contoh: 5000000',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Tanggal Target'),
                      subtitle: Text(
                        DateFormat('dd MMMM yyyy').format(_selectedDate),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
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
                    final amount = double.tryParse(_amountController.text.replaceAll('.', '')) ?? 0;

                    if (name.isNotEmpty && amount > 0) {
                      setState(() {
                        final newGoal = Goal(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: name,
                          targetAmount: amount,
                          targetDate: _selectedDate,
                        );
                        _appData.goals.add(newGoal);
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
      },
    );
  }

  void _showAddFundsDialog(Goal goal) {
    _addAmountController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Dana ke ${goal.name}'),
          content: TextField(
            controller: _addAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Jumlah (Rp)',
              hintText: 'Masukkan jumlah dana',
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
                final amount = double.tryParse(_addAmountController.text.replaceAll('.', '')) ?? 0;
                if (amount > 0) {
                  setState(() {
                    _appData.addToGoal(goal.id, amount);
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}