// controllers/transaction_provider.dart
import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  double get totalIncome => _transactions
      .where((tx) => tx.type == 'income')
      .fold(0, (sum, tx) => sum + tx.amount);

  double get totalExpense => _transactions
      .where((tx) => tx.type == 'expense')
      .fold(0, (sum, tx) => sum + tx.amount);

  void addTransaction(TransactionModel tx) {
    _transactions.add(tx);
    saveToPrefs();
    notifyListeners();
  }

  void removeTransaction(String id) {
    _transactions.removeWhere((tx) => tx.id == id);
    saveToPrefs();
    notifyListeners();
  }

  // SharedPreferences for local persistence
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> txList =
        _transactions.map((tx) => json.encode(tx.toMap())).toList();
    prefs.setStringList('transactions', txList);
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? txList = prefs.getStringList('transactions');
    if (txList != null) {
      _transactions = txList
          .map((txStr) => TransactionModel.fromMap(json.decode(txStr)))
          .toList();
      notifyListeners();
    }
  }
}
