import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_balance/models/expense_type_model.dart';

class ExpenseTypeService {
  final _db = FirebaseFirestore.instance;

  Future<List<ExpenseType>> getExpenseTypes(String uid) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('expenseTypes')
        .get();
    return snapshot.docs
        .map((doc) => ExpenseType.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addExpenseType(String uid, ExpenseType type) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('expenseTypes')
        .add(type.toMap());
  }

  Future<void> updateExpenseType(
    String uid,
    String id,
    ExpenseType type,
  ) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('expenseTypes')
        .doc(id)
        .update(type.toMap());
  }

  Future<void> deleteExpenseType(String uid, String id) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('expenseTypes')
        .doc(id)
        .delete();
  }
}
