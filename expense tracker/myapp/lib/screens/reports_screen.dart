import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controller/provider/transaction_provider.dart';
import '../models/transaction_model.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;

    final Map<int, double> monthlyExpense = {};
    final Map<int, double> monthlyIncome = {};

    for (var tx in transactions) {
      final month = tx.date.month;
      if (tx.type == 'expense') {
        monthlyExpense[month] = (monthlyExpense[month] ?? 0) + tx.amount;
      } else {
        monthlyIncome[month] = (monthlyIncome[month] ?? 0) + tx.amount;
      }
    }

    List<FlSpot> expenseSpots = monthlyExpense.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    List<FlSpot> incomeSpots = monthlyIncome.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) => Text(
                    _monthAbbr(value.toInt()),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 100),
              ),
            ),
            gridData: FlGridData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: expenseSpots,
                isCurved: true,
                color: Colors.redAccent,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
              LineChartBarData(
                spots: incomeSpots,
                isCurved: true,
                color: Colors.greenAccent,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthAbbr(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}
