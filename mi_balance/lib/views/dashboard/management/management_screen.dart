import 'package:flutter/material.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/income-types');
          },
          child: const Text('Income Types'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/expense-types');
          },
          child: const Text('Expense Types'),
        ),
      ],
    );
  }
}
