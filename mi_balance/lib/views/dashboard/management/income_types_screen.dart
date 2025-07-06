import 'package:flutter/material.dart';

class IncomeTypesScreen extends StatelessWidget {
  const IncomeTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Income Types')),
      body: const Center(child: Text('Manage your income categories here')),
    );
  }
}
