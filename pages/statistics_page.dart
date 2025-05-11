import 'package:flutter/material.dart';
import '../data/app_data.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> with SingleTickerProviderStateMixin {
  final AppData _appData = AppData();
  late TabController _tabController;
  String _selectedPeriod = 'Bulan Ini';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Ringkasan'),
            Tab(text: 'Kategori'),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF0F2F5),
      body: Column(
        children: [
          _buildPeriodSelector(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildCategoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPeriodButton('Hari Ini'),
          _buildPeriodButton('Minggu Ini'),
          _buildPeriodButton('Bulan Ini'),
          _buildPeriodButton('Tahun Ini'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String title) {
    final isSelected = _selectedPeriod == title;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPeriod = title;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey.shade300,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTab() {
    final formatter = NumberFormat('#,###', 'id_ID');

    // Get total income and expense
    final totalIncome = _appData.totalIncome;
    final totalExpense = _appData.totalExpense;
    final balance = totalIncome - totalExpense;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.teal,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${formatter.format(balance)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Akun Aktif:',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _appData.currentAccount?.name ?? 'Semua Akun',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Income vs Expense Chart
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pemasukan vs Pengeluaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildIncomeExpenseChart(totalIncome, totalExpense),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Pemasukan',
                        'Rp ${formatter.format(totalIncome)}',
                        Colors.green,
                      ),
                      _buildStatItem(
                        'Pengeluaran',
                        'Rp ${formatter.format(totalExpense)}',
                        Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Spending Trend
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tren Pengeluaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Periode: $_selectedPeriod',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: _buildSpendingTrendChart(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseChart(double income, double expense) {
    final total = income + expense;
    final incomePercentage = total > 0 ? (income / total) * 100 : 0;
    final expensePercentage = total > 0 ? (expense / total) * 100 : 0;

    return Column(
      children: [
        SizedBox(
          height: 24,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Flexible(
                      flex: incomePercentage.round(),
                      child: Container(color: Colors.green),
                    ),
                    Flexible(
                      flex: expensePercentage.round(),
                      child: Container(color: Colors.red),
                    ),
                    if (total == 0)
                      const Flexible(
                        flex: 100,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${incomePercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${expensePercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingTrendChart() {
    // Generate random data for demo
    // In a real app, you would use actual transaction data
    final random = math.Random();
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final values = List.generate(7, (_) => random.nextDouble() * 500000);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxValue = values.reduce(math.max) * 1.1;
        final barWidth = constraints.maxWidth / (values.length * 2);

        return Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(values.length, (index) {
                  final height = (values[index] / maxValue) * constraints.maxHeight * 0.8;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: barWidth,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: days
                  .map((day) => SizedBox(
                width: barWidth,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryTab() {
    final categoryExpenses = _appData.categoryExpenses;

    if (categoryExpenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada data pengeluaran',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tambahkan transaksi untuk melihat data kategori',
              style: TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // For demonstration, let's create some sample category data
    // In a real app, this would come from the transactions
    final sampleCategories = {
      'Makanan': 250000.0,
      'Transportasi': 150000.0,
      'Belanja': 350000.0,
      'Hiburan': 125000.0,
      'Lainnya': 75000.0,
    };

    final totalExpense = sampleCategories.values.fold(0.0, (sum, amount) => sum + amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengeluaran per Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Periode: $_selectedPeriod',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: _buildCategoryDonutChart(sampleCategories, totalExpense),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Detail Kategori',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...sampleCategories.entries.map((entry) {
            final percentage = (entry.value / totalExpense) * 100;
            return _buildCategoryItem(
              entry.key,
              entry.value,
              percentage,
              _getCategoryColor(entry.key),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryDonutChart(Map<String, double> categories, double total) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);

        return CustomPaint(
          size: Size(size, size),
          painter: DonutChartPainter(categories, total),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${NumberFormat('#,###', 'id_ID').format(total)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(String category, double amount, double percentage, Color color) {
    final formatter = NumberFormat('#,###', 'id_ID');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${formatter.format(amount)}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.orange;
      case 'Transportasi':
        return Colors.blue;
      case 'Belanja':
        return Colors.purple;
      case 'Hiburan':
        return Colors.red;
      case 'Lainnya':
        return Colors.grey;
      default:
        return Colors.teal;
    }
  }
}

class DonutChartPainter extends CustomPainter {
  final Map<String, double> categories;
  final double total;

  DonutChartPainter(this.categories, this.total);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    const startAngle = -math.pi / 2;
    var currentAngle = startAngle;

    categories.forEach((category, amount) {
      final sweepAngle = (amount / total) * 2 * math.pi;

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = _getCategoryColor(category);

      canvas.drawArc(
        rect,
        currentAngle,
        sweepAngle,
        true,
        paint,
      );

      currentAngle += sweepAngle;
    });

    // Draw inner circle for donut effect
    final innerCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 4, // Inner radius is half of outer radius
      innerCirclePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.orange;
      case 'Transportasi':
        return Colors.blue;
      case 'Belanja':
        return Colors.purple;
      case 'Hiburan':
        return Colors.red;
      case 'Lainnya':
        return Colors.grey;
      default:
        return Colors.teal;
    }
  }
}