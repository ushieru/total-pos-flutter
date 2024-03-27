import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/routes/admin/route_admin_product_categories.dart';
import 'package:total_pos/ui/routes/admin/route_admin_products_provider.dart';
import 'package:total_pos/ui/widgets/dialogs/dialog_confirm.dart';

class TableProducts extends ConsumerWidget {
  const TableProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(routeAdminProductsProvider);
    final methods = ref.read(routeAdminProductsProvider.notifier);
    return DataTable(columns: const [
      DataColumn(label: Text('id')),
      DataColumn(label: Text('Nombre')),
      DataColumn(label: Text('Descripcion')),
      DataColumn(label: Text('Precio')),
      DataColumn(label: Text('Opciones'))
    ], rows: [
      for (final product in products)
        DataRow(cells: [
          DataCell(Text(product.id)),
          DataCell(Text(product.name)),
          DataCell(Text(product.description)),
          DataCell(Text('\$${product.price}')),
          DataCell(Row(children: [
            IconButton(
                onPressed: () {
                  DialogConfirm.show(
                          context,
                          'Eliminar producto',
                          'Seguro que desea eliminar el producto: "${product.name}"'
                              '\ncon id: "${product.id}"?')
                      .then((value) {
                    if (!value) return;
                    methods.deleteProduct(product);
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.red)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, RouteAdminProductCategories.routeName,
                      arguments:
                          RouteAdminProductCategoriesArguments(product.id));
                },
                icon: const Icon(Icons.link, color: Colors.deepPurple)),
          ])),
        ])
    ]);
  }
}
