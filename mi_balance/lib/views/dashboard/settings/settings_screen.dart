import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/edit-user');
          },
          child: const Text('Edit Profile'),
        ),
        // Puedes agregar más configuraciones aquí
      ],
    );
  }
}
