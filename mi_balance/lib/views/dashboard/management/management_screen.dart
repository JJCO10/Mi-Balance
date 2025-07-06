import 'package:flutter/material.dart';
import 'income_types_screen.dart';
import 'expense_types_screen.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  bool showIncomeTypes = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Management')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => showIncomeTypes = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: showIncomeTypes ? Colors.blue : Colors.grey,
                ),
                child: const Text('Income Types'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => setState(() => showIncomeTypes = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !showIncomeTypes ? Colors.blue : Colors.grey,
                ),
                child: const Text('Expense Types'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: showIncomeTypes
                ? const IncomeTypesScreen()
                : const ExpenseTypesScreen(),
          ),
        ],
      ),
    );
  }
}
