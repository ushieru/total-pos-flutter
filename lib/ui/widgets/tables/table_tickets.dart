import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:total_pos/ui/routes/admin/route_admin_tickets_provider.dart';

class TableTickets extends ConsumerWidget {
  const TableTickets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(routeAdminTicketsProvider);
    return DataTable(columns: const [
      DataColumn(label: Text('Id')),
      DataColumn(label: Text('Products')),
      DataColumn(label: Text('Total')),
      DataColumn(label: Text('Fecha')),
    ], rows: [
      for (final ticket in tickets)
        DataRow(cells: [
          DataCell(Text(ticket.id), onTap: () {
            Clipboard.setData(ClipboardData(text: ticket.id));
            showToast('Copiado a portapapeles', position: ToastPosition.bottom);
          }),
          DataCell(Text('${ticket.products.length}')),
          DataCell(Text('\$${ticket.total}')),
          DataCell(Text(DateFormat('dd MMMM yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(ticket.createAt.toInt())))),
        ])
    ]);
  }
}
