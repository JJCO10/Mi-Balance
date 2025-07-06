import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  double amount;
  String category;
  String description;
  DateTime date;
  String typeId;
  String? typeName; // ✅ nuevo
  DateTime createdAt;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.typeId,
    required this.createdAt,
    this.typeName,
  });

  factory Expense.fromMap(String id, Map<String, dynamic> data) => Expense(
    id: id,
    amount: data['amount'],
    category: data['category'],
    description: data['description'],
    date: (data['date'] as Timestamp).toDate(),
    typeId: data['typeId'],
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'amount': amount,
    'category': category,
    'description': description,
    'date': date,
    'typeId': typeId,
    'createdAt': createdAt,
  };
}
