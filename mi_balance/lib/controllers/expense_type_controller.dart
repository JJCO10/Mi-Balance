import 'package:flutter/material.dart';
import '../models/expense_type_model.dart';
import '../services/expense_type_service.dart';

class ExpenseTypeController with ChangeNotifier {
  final ExpenseTypeService _service = ExpenseTypeService();
  final String uid;

  ExpenseTypeController(this.uid);

  List<ExpenseType> _types = [];
  List<ExpenseType> get types => _filteredTypes;
  List<ExpenseType> _filteredTypes = [];

  Future<void> loadTypes() async {
    _types = await _service.getExpenseTypes(uid);
    applyFilter('');
  }

  void applyFilter(String query) {
    _filteredTypes = _types
        .where((t) => t.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> addType(String name) async {
    await _service.addExpenseType(uid, ExpenseType(id: '', name: name));
    await loadTypes();
  }

  Future<void> updateType(String id, String name) async {
    await _service.updateExpenseType(uid, id, ExpenseType(id: id, name: name));
    await loadTypes();
  }

  Future<void> deleteType(String id) async {
    await _service.deleteExpenseType(uid, id);
    await loadTypes();
  }
}
