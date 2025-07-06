class ExpenseType {
  final String id;
  final String name;

  ExpenseType({required this.id, required this.name});

  factory ExpenseType.fromMap(String id, Map<String, dynamic> map) {
    return ExpenseType(id: id, name: map['name'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'name': name};
  }
}
