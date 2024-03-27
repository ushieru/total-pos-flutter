import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/routes/admin/route_admin_users_provider.dart';
import 'package:total_pos/ui/widgets/dialogs/dialog_confirm.dart';

class TableUsers extends ConsumerWidget {
  const TableUsers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(routeAdminUsersProvider);
    final methods = ref.read(routeAdminUsersProvider.notifier);
    return DataTable(columns: const [
      DataColumn(label: Text('id')),
      DataColumn(label: Text('Nombre')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Usuario')),
      DataColumn(label: Text('Rol')),
      DataColumn(label: Text('Estado')),
      DataColumn(label: Text('Opciones'))
    ], rows: [
      for (final user in users)
        DataRow(cells: [
          DataCell(Text(user.id)),  
          DataCell(Text(user.user.name)),
          DataCell(Text(user.user.email)),
          DataCell(Text(user.username)),
          DataCell(Text(user.accountType.name)),
          DataCell(Text(user.isActive ? 'Activo' : 'Inactivo')),
          DataCell(Row(children: [
            IconButton(
                onPressed: () {
                  DialogConfirm.show(
                          context,
                          'Eliminar producto',
                          'Seguro que desea eliminar el usuario: "${user.user.email}"'
                              '\ncon id: "${user.id}"?')
                      .then((value) {
                    if (!value) return;
                    methods.deleteUser(user.id);
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.red)),
          ])),
        ])
    ]);
  }
}
