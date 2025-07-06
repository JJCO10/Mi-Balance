import 'package:flutter/material.dart';
import 'package:mi_balance/controllers/income_controller.dart';
import 'package:mi_balance/controllers/income_type_controller.dart';
import 'package:mi_balance/models/income_model.dart';
import 'package:provider/provider.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<IncomeController>(context, listen: false);
    controller.loadIncomes();
    final typeController = Provider.of<IncomeTypeController>(
      context,
      listen: false,
    );
    typeController.loadTypes();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<IncomeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresos'),
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
              rows: controller.incomes.map((income) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(income.date.toLocal().toString().split(' ')[0]),
                    ),
                    DataCell(Text(income.category)),
                    DataCell(Text(income.typeName ?? 'N/A')),
                    DataCell(Text('\$${income.amount.toStringAsFixed(2)}')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(context, income: income),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => controller.deleteIncome(income.id),
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

  void _showForm(BuildContext context, {Income? income}) {
    final _formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(
      text: income?.amount.toString() ?? '',
    );
    final categoryController = TextEditingController(
      text: income?.category ?? '',
    );
    final descriptionController = TextEditingController(
      text: income?.description ?? '',
    );
    String? _selectedTypeId = income?.typeId;
    DateTime selectedDate = income?.date ?? DateTime.now();

    final typeController = Provider.of<IncomeTypeController>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(income == null ? 'Agregar ingreso' : 'Editar ingreso'),
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
                  value: _selectedTypeId,
                  hint: const Text('Selecciona un tipo de ingreso'),
                  items: typeController.types.map((type) {
                    return DropdownMenuItem(
                      value: type.id,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTypeId = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Selecciona un tipo de ingreso' : null,
                ),
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
                final incomeObj = Income(
                  id: income?.id ?? '',
                  amount: double.parse(amountController.text),
                  category: categoryController.text,
                  description: descriptionController.text,
                  date: selectedDate,
                  typeId: _selectedTypeId!,
                  createdAt: income?.createdAt ?? DateTime.now(),
                );

                final controller = Provider.of<IncomeController>(
                  context,
                  listen: false,
                );
                if (income == null) {
                  controller.addIncome(incomeObj);
                } else {
                  controller.updateIncome(income!.id, incomeObj);
                }

                Navigator.pop(context);
              }
            },
            child: Text(income == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }
}
