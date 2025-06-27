// views/transaction/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../controller/provider/transaction_provider.dart';
import '../../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String type = 'expense';
  String category = 'Food';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  final List<String> categories = [
    'Food', 'Transport', 'Shopping', 'Bills',
    'Entertain', 'Health', 'Education', 'Other'
  ];

  void saveTransaction() {
    final double? amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    final tx = TransactionModel(
      id: const Uuid().v4(),
      title: noteController.text.isNotEmpty ? noteController.text : category,
      amount: amount,
      date: selectedDate,
      category: category,
      type: type,
    );

    Provider.of<TransactionProvider>(context, listen: false).addTransaction(tx);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [type == 'expense', type == 'income'],
              onPressed: (index) {
                setState(() {
                  type = index == 0 ? 'expense' : 'income';
                });
              },
              children: const [Text('Expense'), Text('Income')],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: categories
                  .map((cat) => ChoiceChip(
                        label: Text(cat),
                        selected: category == cat,
                        onSelected: (_) {
                          setState(() => category = cat);
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                  child: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Note (Optional)',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveTransaction,
              child: const Text('Save Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
