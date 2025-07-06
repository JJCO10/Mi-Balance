import 'package:flutter/material.dart';
import 'package:mi_balance/controllers/auth_controller.dart';
import 'package:mi_balance/controllers/expense_controller.dart';
import 'package:mi_balance/controllers/expense_type_controller.dart';
import 'package:mi_balance/controllers/income_controller.dart';
import 'package:mi_balance/controllers/income_type_controller.dart';
import 'package:mi_balance/views/dashboard/balances_screen.dart';
import 'package:mi_balance/views/dashboard/home_screen.dart';
import 'package:mi_balance/views/dashboard/management/management_screen.dart';
import 'package:mi_balance/views/dashboard/settings/settings_screen.dart';
import 'package:mi_balance/views/dashboard/transactions/transactions_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthController>(context).user;
    final uid = user?.uid ?? '';

    final List<Widget> screens = [
      const HomeScreen(),
      const BalancesScreen(),
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => IncomeController(uid)),
          ChangeNotifierProvider(create: (_) => ExpenseController(uid)),
          ChangeNotifierProvider(create: (_) => IncomeTypeController(uid)),
          ChangeNotifierProvider(create: (_) => ExpenseTypeController(uid)),
        ],
        child: const TransactionsScreen(),
      ),
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => IncomeTypeController(uid)),
          ChangeNotifierProvider(create: (_) => ExpenseTypeController(uid)),
        ],
        child: const ManagementScreen(),
      ),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Welcome, ${user?.nickname ?? 'User'}')),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Balances',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
