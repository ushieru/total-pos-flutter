import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:total_pos/generated/protos/main.pb.dart';

class DialogPayTicket extends StatefulWidget {
  const DialogPayTicket({super.key, required this.ticket});

  final Ticket ticket;

  static Future<bool> show(BuildContext context, Ticket ticket) async {
    return showDialog<bool?>(
            context: context, builder: (_) => DialogPayTicket(ticket: ticket))
        .then((value) => value ?? false);
  }

  @override
  State<DialogPayTicket> createState() => _DialogPayTicketState();
}

class _DialogPayTicketState extends State<DialogPayTicket> {
  String payAmount = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pagar ticket'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextFormField(
                decoration: const InputDecoration(labelText: 'Pago con:'),
                onChanged: (value) => setState(() => payAmount = value),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ]),
            const SizedBox(height: 10),
            const Text('Cambio:'),
            Text('\$${(int.tryParse(payAmount) ?? 0) - widget.ticket.total}')
          ],
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
