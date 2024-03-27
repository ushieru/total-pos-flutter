import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:total_pos/ui/routes/admin/product/route_admin_product_update.dart';
import 'package:total_pos/ui/routes/admin/product/route_admin_products_provider.dart';
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
                  context
                      .pushNamed(RouteAdminProductUpdate.routeName,
                          extra: product)
                      .then((_) => methods.getProducts());
                },
                icon: const Icon(Icons.edit, color: Colors.deepPurple)),
          ])),
        ])
    ]);
  }
}
