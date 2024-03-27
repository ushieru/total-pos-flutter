import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef DialogCreateNewProductResponse = (String, String, double);

class DialogCreateNewProduct extends StatelessWidget {
  DialogCreateNewProduct({super.key});

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  static Future<DialogCreateNewProductResponse?> show(
      BuildContext context) async {
    return showDialog<DialogCreateNewProductResponse?>(
        context: context,
        builder: (context_) => DialogCreateNewProduct().build(context_));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo producto'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Nombre'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Descripcion'),
            ),
            TextFormField(
              onFieldSubmitted: (value) =>
                  Navigator.of(context).pop<DialogCreateNewProductResponse>((
                _nameController.text,
                _descriptionController.text,
                double.parse(_priceController.text)
              )),
              controller: _priceController,
              decoration: const InputDecoration(hintText: 'Precio'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
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
            Navigator.of(context).pop<DialogCreateNewProductResponse>((
              _nameController.text,
              _descriptionController.text,
              double.parse(_priceController.text)
            ));
          },
        ),
      ],
    );
  }
}
