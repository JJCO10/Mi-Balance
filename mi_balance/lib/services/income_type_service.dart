import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_balance/models/income_type_model.dart';

class ExpenseTypeService {
  final _db = FirebaseFirestore.instance;

  Future<List<ExpenseType>> getIncomeTypes(String uid) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('incomeTypes')
        .get();
    return snapshot.docs
        .map((doc) => ExpenseType.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addIncomeType(String uid, ExpenseType type) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('incomeTypes')
        .add(type.toMap());
  }

  Future<void> updateIncomeType(String uid, String id, ExpenseType type) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('incomeTypes')
        .doc(id)
        .update(type.toMap());
  }

  Future<void> deleteIncomeType(String uid, String id) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('incomeTypes')
        .doc(id)
        .delete();
  }
}
