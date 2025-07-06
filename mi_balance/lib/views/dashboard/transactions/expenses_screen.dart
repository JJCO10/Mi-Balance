import 'package:flutter/material.dart';
import 'package:mi_balance/controllers/expense_controller.dart';
import 'package:mi_balance/models/expense_model.dart';
import 'package:mi_balance/models/expense_type_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _searchController = TextEditingController();
  List<ExpenseType> _expenseTypes = [];

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<ExpenseController>(context, listen: false);
    controller.loadExpenses();
    _loadExpenseTypes();
  }

  Future<void> _loadExpenseTypes() async {
    final uid = Provider.of<ExpenseController>(context, listen: false).uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenseTypes')
        .get();

    setState(() {
      _expenseTypes = snapshot.docs
          .map((doc) => ExpenseType.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ExpenseController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showForm(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: controller.applyFilter,
              decoration: const InputDecoration(
                labelText: 'Buscar',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Categoría')),
                DataColumn(label: Text('Tipo')),
                DataColumn(label: Text('Monto')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: controller.expenses.map((expense) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(expense.date.toLocal().toString().split(' ')[0]),
                    ),
                    DataCell(Text(expense.category)),
                    DataCell(Text(expense.typeName ?? 'N/A')),
                    DataCell(Text('\$${expense.amount.toStringAsFixed(2)}')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showForm(context, expense: expense),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                controller.deleteExpense(expense.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showForm(BuildContext context, {Expense? expense}) {
    final _formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(
      text: expense?.amount.toString() ?? '',
    );
    final categoryController = TextEditingController(
      text: expense?.category ?? '',
    );
    final descriptionController = TextEditingController(
      text: expense?.description ?? '',
    );
    DateTime selectedDate = expense?.date ?? DateTime.now();
    String? selectedTypeId = expense?.typeId;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(expense == null ? 'Agregar gasto' : 'Editar gasto'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedTypeId,
                  items: _expenseTypes.map((type) {
                    return DropdownMenuItem(
                      value: type.id,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedTypeId = value;
                  },
                  decoration: const InputDecoration(labelText: 'Tipo de gasto'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Seleccione un tipo'
                      : null,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  child: const Text('Seleccionar Fecha'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final expenseObj = Expense(
                  id: expense?.id ?? '',
                  amount: double.parse(amountController.text),
                  category: categoryController.text,
                  description: descriptionController.text,
                  date: selectedDate,
                  typeId: selectedTypeId!,
                  createdAt: expense?.createdAt ?? DateTime.now(),
                );

                final controller = Provider.of<ExpenseController>(
                  context,
                  listen: false,
                );
                if (expense == null) {
                  controller.addExpense(expenseObj);
                } else {
                  controller.updateExpense(expense!.id, expenseObj);
                }

                Navigator.pop(context);
              }
            },
            child: Text(expense == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }
}
