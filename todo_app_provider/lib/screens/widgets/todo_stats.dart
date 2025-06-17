import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/todo_provider.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatItem(
                label: 'Total',
                count: todoProvider.totalCount,
                color: Colors.blue,
              ),
              StatItem(
                label: 'Pending',
                count: todoProvider.pendingCount,
                color: Colors.orange,
              ),
              StatItem(
                label: 'Done',
                count: todoProvider.completedCount,
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }
}

class StatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const StatItem({
    Key? key,
    required this.label,
    required this.count,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}