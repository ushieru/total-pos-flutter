import 'package:flutter/material.dart';

class DialogConfirm extends StatelessWidget {
  const DialogConfirm({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  static Future<bool> show(
      BuildContext context, String title, String body) async {
    return showDialog<bool?>(
        context: context,
        builder: (context_) => DialogConfirm(title: title, body: body)
            .build(context_)).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text(body)],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        ElevatedButton(
          autofocus: true,
          child: const Text('Confirmar'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
