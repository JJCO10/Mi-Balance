import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/income_type_controller.dart';

class IncomeTypesScreen extends StatefulWidget {
  const IncomeTypesScreen({super.key});

  @override
  State<IncomeTypesScreen> createState() => _IncomeTypesScreenState();
}

class _IncomeTypesScreenState extends State<IncomeTypesScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<IncomeTypeController>(context, listen: false).loadTypes();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IncomeTypeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Ingreso'),
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
              controller: _controller,
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

  void _showForm(BuildContext context, {type}) {
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
              if (nameController.text.isNotEmpty) {
                final provider = Provider.of<IncomeTypeController>(
                  context,
                  listen: false,
                );
                if (type == null) {
                  provider.addType(nameController.text);
                } else {
                  provider.updateType(type.id, nameController.text);
                }
              }
              Navigator.pop(context);
            },
            child: Text(type == null ? 'Guardar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }
}
