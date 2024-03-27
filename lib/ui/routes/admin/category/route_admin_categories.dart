import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:total_pos/ui/routes/admin/category/route_admin_categories_new.dart';
import 'package:total_pos/ui/routes/admin/category/route_admin_categories_provider.dart';
import 'package:total_pos/ui/routes/admin/category/widgets/table_categories.dart';

class RouteAdminCategories extends ConsumerWidget {
  static const routeName = "admin.category";
  static const routePath = "/admin/category";
  const RouteAdminCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.read(routeAdminCateogiresProvider.notifier);
    return Padding(
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
                            context
                                .pushNamed(RouteAdminCategoriesNew.routeName)
                                .then((_) => methods.getCategories());
                          },
                          child: const Text('Nueva categoria'))))),
          const SizedBox(
              width: double.maxFinite,
              child: Card(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TableCategories(),
              )))
        ]));
  }
}
