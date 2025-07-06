import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/income_model.dart';
import '../services/income_service.dart';

class IncomeController with ChangeNotifier {
  final IncomeService _incomeService = IncomeService();
  final String uid;

  IncomeController(this.uid);

  List<Income> _incomes = [];
  List<Income> get incomes => _filteredIncomes;
  List<Income> _filteredIncomes = [];

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> loadIncomes() async {
    _incomes = await _incomeService.getIncomes(uid);
    applyFilter(_searchQuery);
    notifyListeners();
  }

  void applyFilter(String query) {
    _searchQuery = query.toLowerCase();
    _filteredIncomes = _incomes.where((income) {
      return income.category.toLowerCase().contains(_searchQuery) ||
          income.description.toLowerCase().contains(_searchQuery);
    }).toList();
    notifyListeners();
  }

  Future<void> addIncome(Income income) async {
    // 1. Obtener el nombre del tipo desde Firestore
    final typeDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('incomeTypes')
        .doc(income.typeId)
        .get();

    final typeName = typeDoc.data()?['name'] ?? 'Tipo desconocido';

    // 2. Crear el Income con el nombre del tipo incluido
    final enrichedIncome = Income(
      id: '',
      amount: income.amount,
      category: income.category,
      description: income.description,
      date: income.date,
      typeId: income.typeId,
      typeName: typeName, // ← importante
      createdAt: income.createdAt,
    );

    // 3. Guardar en Firestore
    await _incomeService.addIncome(uid, enrichedIncome);
    await loadIncomes();
  }

  Future<void> updateIncome(String incomeId, Income income) async {
    await _incomeService.updateIncome(uid, incomeId, income);
    await loadIncomes();
  }

  Future<void> deleteIncome(String incomeId) async {
    await _incomeService.deleteIncome(uid, incomeId);
    await loadIncomes();
  }
}
