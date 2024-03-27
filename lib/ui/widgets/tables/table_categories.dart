import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:total_pos/ui/routes/admin/route_admin_categories/route_admin_categories_provider.dart';
import 'package:total_pos/ui/widgets/dialogs/dialog_confirm.dart';

class TableCategories extends ConsumerWidget {
  const TableCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(routeAdminCateogiresProvider);
    final methods = ref.read(routeAdminCateogiresProvider.notifier);
    return DataTable(columns: const [
      DataColumn(label: Text('id')),
      DataColumn(label: Text('Nombre')),
      DataColumn(label: Text('Opciones')),
    ], rows: [
      for (final category in categories)
        DataRow(cells: [
          DataCell(Text(category.id), onTap: () {
            Clipboard.setData(ClipboardData(text: category.id));
            showToast('Copiado a portapapeles', position: ToastPosition.bottom);
          }),
          DataCell(Text(category.name)),
          DataCell(Row(children: [
            IconButton(
                onPressed: () {
                  DialogConfirm.show(
                          context,
                          'Eliminar categoria',
                          'Seguro que desea eliminar la categoria: "${category.name}"'
                              '\ncon id: "${category.id}"?')
                      .then((value) {
                    if (!value) return;
                    methods.deleteCategory(category.id);
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.red)),
          ])),
        ])
    ]);
  }
}
