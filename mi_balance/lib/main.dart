import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mi_balance/controllers/expense_controller.dart';
import 'package:mi_balance/controllers/expense_type_controller.dart';
import 'package:mi_balance/controllers/income_controller.dart';
import 'package:mi_balance/controllers/income_type_controller.dart';
import 'package:mi_balance/firebase_options.dart';
import 'package:mi_balance/views/auth/register_screen.dart';
import 'package:mi_balance/views/dashboard/dashboard_screen.dart';
import 'package:mi_balance/views/dashboard/management/expense_types_screen.dart';
import 'package:mi_balance/views/dashboard/management/income_types_screen.dart';
import 'package:mi_balance/views/dashboard/settings/edit_user_screen.dart';
import 'package:mi_balance/views/dashboard/transactions/expenses_screen.dart';
import 'package:mi_balance/views/dashboard/transactions/incomes_screen.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'views/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Balance',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/incomes': (context) {
          final uid =
              Provider.of<AuthController>(context, listen: false).user?.uid ??
              '';
          return ChangeNotifierProvider(
            create: (_) => IncomeController(uid),
            child: const IncomeScreen(),
          );
        },
        '/expenses': (context) {
          final uid =
              Provider.of<AuthController>(context, listen: false).user?.uid ??
              '';
          return ChangeNotifierProvider(
            create: (_) => ExpenseController(uid),
            child: const ExpenseScreen(),
          );
        },
        '/income-types': (context) {
          final uid =
              Provider.of<AuthController>(context, listen: false).user?.uid ??
              '';
          return ChangeNotifierProvider(
            create: (_) => IncomeTypeController(uid),
            child: const IncomeTypesScreen(),
          );
        },
        '/expense-types': (context) {
          final uid =
              Provider.of<AuthController>(context, listen: false).user?.uid ??
              '';
          return ChangeNotifierProvider(
            create: (_) => ExpenseTypeController(uid),
            child: const ExpenseTypesScreen(),
          );
        },

        '/edit-user': (_) => const EditUserScreen(),
      },
    );
  }
}
