import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/expense_type_controller.dart';
import '../../../models/expense_type_model.dart';

class ExpenseTypesScreen extends StatefulWidget {
  const ExpenseTypesScreen({super.key});

  @override
  State<ExpenseTypesScreen> createState() => _ExpenseTypesScreenState();
}

class _ExpenseTypesScreenState extends State<ExpenseTypesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseTypeController>(context, listen: false).loadTypes();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseTypeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Gasto'),
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
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Buscar'),
              onChanged: provider.applyFilter,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.types.length,
              itemBuilder: (_, index) {
                final type = provider.types[index];
                return ListTile(
                  title: Text(type.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(context, type: type),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => provider.deleteType(type.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showForm(BuildContext context, {ExpenseType? type}) {
    final nameController = TextEditingController(text: type?.name ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(type == null ? 'Nuevo tipo' : 'Editar tipo'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final provider = Provider.of<ExpenseTypeController>(
                  context,
                  listen: false,
                );
                if (type == null) {
                  provider.addType(name);
                } else {
                  provider.updateType(type.id, name);
                }
                Navigator.pop(context);
              }
            },
            child: Text(type == null ? 'Guardar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }
}
