import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class ExpenseChart extends StatelessWidget {
  final Map<String, double> categoryData;

  const ExpenseChart({
    super.key,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Belum ada data pengeluaran',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: _createSections(),
          centerSpaceRadius: 40,
          sectionsSpace: 2,
          startDegreeOffset: -90,
        ),
      ),
    );
  }

  List<PieChartSectionData> _createSections() {
    final List<PieChartSectionData> sections = [];
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.amber,
      Colors.teal,
    ];

    double total = categoryData.values.fold(0, (sum, value) => sum + value);
    int colorIndex = 0;

    categoryData.forEach((category, amount) {
      final percentage = total > 0 ? (amount / total) * 100 : 0;

      sections.add(
        PieChartSectionData(
          value: amount,
          title: '${percentage.toStringAsFixed(1)}%',
          color: colors[colorIndex % colors.length],
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

      colorIndex++;
    });

    return sections;
  }
}