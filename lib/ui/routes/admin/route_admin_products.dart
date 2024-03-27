import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/layouts/layout_admin.dart';
import 'package:total_pos/ui/routes/admin/route_admin_products_provider.dart';
import 'package:total_pos/ui/widgets/dialogs/dialog_create_new_product.dart';
import 'package:total_pos/ui/widgets/tables/table_products.dart';

class RouteAdminProduct extends ConsumerWidget {
  static const routeName = "/admin/product";
  const RouteAdminProduct({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.read(routeAdminProductsProvider.notifier);
    return LayoutAdmin(
        child: Expanded(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(children: [
                  SizedBox(
                      width: double.maxFinite,
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    DialogCreateNewProduct.show(context)
                                        .then((response) {
                                      if (response == null) return;
                                      final (name, description, price) =
                                          response;
                                      methods.createProduct(
                                          name, description, price);
                                    });
                                  },
                                  child: const Text('Nuevo producto'))))),
                  const SizedBox(
                      width: double.maxFinite,
                      child: Card(
                          child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TableProducts(),
                      )))
                ]))));
  }
}
