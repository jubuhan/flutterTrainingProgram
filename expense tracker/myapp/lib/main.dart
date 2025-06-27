// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/provider/transaction_provider.dart';
import 'screens/home_screen.dart';
import 'screens/main_wrapper.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
      home: const MainWrapper(),

      ),
    );
  }
}
