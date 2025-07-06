import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/expense_service.dart';

class ExpenseController with ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();
  final String uid;

  ExpenseController(this.uid);

  List<Expense> _expenses = [];
  List<Expense> get expenses => _filteredExpenses;
  List<Expense> _filteredExpenses = [];

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> loadExpenses() async {
    _expenses = await _expenseService.getExpenses(uid);

    // 🔁 Cargar tipos
    final typesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenseTypes')
        .get();

    final Map<String, String> typeMap = {
      for (var doc in typesSnapshot.docs) doc.id: doc['name'],
    };

    // 🔁 Asignar typeName a cada Expense
    for (var e in _expenses) {
      e.typeName = typeMap[e.typeId];
    }

    applyFilter(_searchQuery);
    notifyListeners();
  }

  void applyFilter(String query) {
    _searchQuery = query.toLowerCase();
    _filteredExpenses = _expenses.where((expense) {
      return expense.category.toLowerCase().contains(_searchQuery) ||
          expense.description.toLowerCase().contains(_searchQuery);
    }).toList();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _expenseService.addExpense(uid, expense);
    await loadExpenses();
  }

  Future<void> updateExpense(String expenseId, Expense expense) async {
    await _expenseService.updateExpense(uid, expenseId, expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(String expenseId) async {
    await _expenseService.deleteExpense(uid, expenseId);
    await loadExpenses();
  }
}
