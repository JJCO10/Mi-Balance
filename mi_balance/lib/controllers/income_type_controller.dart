import 'package:flutter/material.dart';
import '../models/income_type_model.dart';
import '../services/income_type_service.dart';

class IncomeTypeController with ChangeNotifier {
  final ExpenseTypeService _service = ExpenseTypeService();
  final String uid;

  IncomeTypeController(this.uid);

  List<ExpenseType> _types = [];
  List<ExpenseType> get types => _filteredTypes;
  List<ExpenseType> _filteredTypes = [];

  Future<void> loadTypes() async {
    _types = await _service.getIncomeTypes(uid);
    applyFilter('');
  }

  void applyFilter(String query) {
    _filteredTypes = _types
        .where((t) => t.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> addType(String name) async {
    await _service.addIncomeType(uid, ExpenseType(id: '', name: name));
    await loadTypes();
  }

  Future<void> updateType(String id, String name) async {
    await _service.updateIncomeType(uid, id, ExpenseType(id: id, name: name));
    await loadTypes();
  }

  Future<void> deleteType(String id) async {
    await _service.deleteIncomeType(uid, id);
    await loadTypes();
  }
}
