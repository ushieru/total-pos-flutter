import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/layouts/layout_admin.dart';
import 'package:total_pos/ui/routes/admin/route_admin_product_categories_provider.dart';

class RouteAdminProductCategoriesArguments {
  RouteAdminProductCategoriesArguments(this.productId);
  final String productId;
}

class RouteAdminProductCategories extends ConsumerWidget {
  static const routeName = "/admin/product/categories";
  const RouteAdminProductCategories({super.key, required String productId})
      : _productId = productId;

  final String _productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routeAdminProductCategoriesProvider);
    final methods = ref.read(routeAdminProductCategoriesProvider.notifier);
    methods.getProduct(_productId);
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
                              child: Text(state.product.name,
                                  style: const TextStyle(fontSize: 30))))),
                  SizedBox(
                      width: double.maxFinite,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Column(children: [
                                          const Text('Categorias'),
                                          const SizedBox(height: 10),
                                          for (final category
                                              in state.filtercategories)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    methods
                                                        .addCategoryToProduct(
                                                            category.id);
                                                  },
                                                  icon: const Icon(Icons.add),
                                                  label: Text(category.name)),
                                            )
                                        ])))),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Column(children: [
                                          const Text('Categorias en Producto'),
                                          const SizedBox(height: 10),
                                          for (final category
                                              in state.productCategories)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    methods
                                                        .deleteCategoryToProduct(
                                                            category.id);
                                                  },
                                                  icon:
                                                      const Icon(Icons.remove),
                                                  label: Text(category.name)),
                                            )
                                        ]))))
                          ]))
                ]))));
  }
}
