import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_balance/models/income_model.dart';

class IncomeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addIncome(String uid, Income income) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('incomes')
        .add(income.toMap());
  }

  Future<List<Income>> getIncomes(String uid) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('incomes')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Income.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> updateIncome(String uid, String incomeId, Income income) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('incomes')
        .doc(incomeId)
        .update(income.toMap());
  }

  Future<void> deleteIncome(String uid, String incomeId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('incomes')
        .doc(incomeId)
        .delete();
  }
}
