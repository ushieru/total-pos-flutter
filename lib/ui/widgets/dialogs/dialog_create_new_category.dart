import 'package:flutter/material.dart';

class DialogCreateNewCategory extends StatelessWidget {
  DialogCreateNewCategory({super.key});

  final _nameController = TextEditingController();

  static Future<String?> show(BuildContext context) async {
    return showDialog<String?>(
        context: context,
        builder: (context_) => DialogCreateNewCategory().build(context_));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva categoria'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextFormField(
              onFieldSubmitted: (value) => Navigator.of(context).pop(value),
              autofocus: true,
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Nombre'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Crear'),
          onPressed: () {
            Navigator.of(context).pop(_nameController.text);
          },
        ),
      ],
    );
  }
}
