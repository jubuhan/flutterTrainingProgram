// views/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/provider/transaction_provider.dart';
import 'widgets/balance_summary.dart';
import 'widgets/spending_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Back'),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Icon(Icons.person)),
          )
        ],
      ),
      body: Column(
        children: [
          BalanceSummary(
            income: provider.totalIncome,
            expense: provider.totalExpense,
          ),
          const SizedBox(height: 16),
          const SpendingChart(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to AddTransaction screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
