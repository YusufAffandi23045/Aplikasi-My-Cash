import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryList extends StatelessWidget {
  final Map<String, double> categoryData;

  const CategoryList({
    super.key,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty) {
      return const SizedBox.shrink();
    }

    final formatter = NumberFormat('#,###', 'id_ID');
    final total = categoryData.values.fold(0.0, (sum, amount) => sum + amount);

    // Sort categories by amount (descending)
    final sortedEntries = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        for (var entry in sortedEntries)
          _buildCategoryItem(
            entry.key,
            entry.value,
            (entry.value / total) * 100,
            _getCategoryColor(entry.key),
            formatter,
          ),
      ],
    );
  }

  Widget _buildCategoryItem(
      String category,
      double amount,
      double percentage,
      Color color,
      NumberFormat formatter,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
            flex: 2,
            child: Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Rp ${formatter.format(amount)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
      case 'Pendidikan':
        return Colors.green;
      case 'Kesehatan':
        return Colors.cyan;
      case 'Tagihan':
        return Colors.amber;
      case 'Umum':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}