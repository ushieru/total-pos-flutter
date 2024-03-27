import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/layouts/layout_admin.dart';
import 'package:total_pos/ui/routes/admin/route_admin_categories/route_admin_categories_new.dart';
import 'package:total_pos/ui/widgets/tables/table_categories.dart';

class RouteAdminCategories extends ConsumerWidget {
  static const routeName = "/admin/categories";
  const RouteAdminCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                                    Navigator.pushReplacementNamed(context,
                                        RouteAdminCategoriesNew.routeName);
                                  },
                                  child: const Text('Nueva categoria'))))),
                  const SizedBox(
                      width: double.maxFinite,
                      child: Card(
                          child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TableCategories(),
                      )))
                ]))));
  }
}
