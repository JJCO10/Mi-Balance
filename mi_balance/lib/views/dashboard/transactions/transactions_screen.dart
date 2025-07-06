import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/incomes');
          },
          child: const Text('Incomes'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/expenses');
          },
          child: const Text('Expenses'),
        ),
      ],
    );
  }
}
