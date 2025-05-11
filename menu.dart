import 'package:flutter/material.dart';
import 'pages/add_transaction_page.dart';
import 'pages/transaction_report_page.dart';
import 'pages/goals_page.dart';
import 'pages/statistics_page.dart';
import 'pages/account_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF1E1E1E), // Dark background like in the example
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
              ),
              accountName: const Text('My Wallet'),
              accountEmail: null,
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.home,
              title: 'Home',
              isSelected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.receipt_long,
              title: 'Transaksi',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LaporanTransaksiPage()),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.account_balance_wallet,
              title: 'Akun',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountsPage()),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.bar_chart,
              title: 'Statistik',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatisticsPage()),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.flag,
              title: 'Target Keuangan',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoalsPage()),
                );
              },
            ),
            const Divider(color: Colors.grey),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'MyCash v1.0',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.white70,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? const Color(0xFF252525) : null,
      onTap: onTap,
    );
  }
}