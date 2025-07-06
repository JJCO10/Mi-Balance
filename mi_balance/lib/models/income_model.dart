import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  String id;
  double amount;
  String category;
  String description;
  DateTime date;
  String typeId;
  String? typeName; // ← nuevo campo opcional
  DateTime createdAt;

  Income({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.typeId,
    this.typeName, // ← permitido como opcional
    required this.createdAt,
  });

  factory Income.fromMap(String id, Map<String, dynamic> data) => Income(
    id: id,
    amount: data['amount'],
    category: data['category'],
    description: data['description'],
    date: (data['date'] as Timestamp).toDate(),
    typeId: data['typeId'],
    typeName: data['typeName'], // ← se puede traer si está presente
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'amount': amount,
    'category': category,
    'description': description,
    'date': date,
    'typeId': typeId,
    if (typeName != null) 'typeName': typeName, // ← solo si no es null
    'createdAt': createdAt,
  };
}
