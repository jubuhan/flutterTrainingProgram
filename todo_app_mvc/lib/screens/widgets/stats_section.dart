import 'package:flutter/material.dart';
import '../../controller/todo_controller.dart';

class StatsSection extends StatelessWidget {
  final TodoController controller;

  const StatsSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatItem(
                label: 'Total',
                count: controller.totalCount,
                color: Colors.blue,
              ),
              StatItem(
                label: 'Pending',
                count: controller.pendingCount,
                color: Colors.orange,
              ),
              StatItem(
                label: 'Done',
                count: controller.completedCount,
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