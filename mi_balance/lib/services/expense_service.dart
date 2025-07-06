import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_balance/models/expense_model.dart';
import 'package:mi_balance/models/expense_type_model.dart';

class ExpenseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addExpense(String uid, Expense expense) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .add(expense.toMap());
  }

  Future<List<Expense>> getExpenses(String uid) async {
    // Obtener los tipos de gastos primero
    final typesSnapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('expense_types')
        .get();

    final typeMap = {
      for (var doc in typesSnapshot.docs)
        doc.id: ExpenseType.fromMap(doc.id, doc.data()).name,
    };

    // Obtener los gastos
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final expense = Expense.fromMap(doc.id, data);
      expense.typeName = typeMap[expense.typeId]; // Asignar nombre del tipo
      return expense;
    }).toList();
  }

  Future<void> updateExpense(
    String uid,
    String expenseId,
    Expense expense,
  ) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .doc(expenseId)
        .update(expense.toMap());
  }

  Future<void> deleteExpense(String uid, String expenseId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }
}
