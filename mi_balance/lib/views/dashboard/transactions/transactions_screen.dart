import 'package:flutter/material.dart';
import 'incomes_screen.dart';
import 'expenses_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool showIncomes = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => showIncomes = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: showIncomes ? Colors.blue : Colors.grey,
                ),
                child: const Text('Incomes'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => setState(() => showIncomes = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !showIncomes ? Colors.blue : Colors.grey,
                ),
                child: const Text('Expenses'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: showIncomes ? const IncomesScreen() : const ExpensesScreen(),
          ),
        ],
      ),
    );
  }
}
