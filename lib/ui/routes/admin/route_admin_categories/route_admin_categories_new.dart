import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/layouts/layout_admin.dart';
import 'package:total_pos/ui/routes/admin/route_admin_categories/route_admin_categories.dart';
import 'package:total_pos/ui/routes/admin/route_admin_categories/route_admin_categories_provider.dart';

class RouteAdminCategoriesNew extends ConsumerWidget {
  static const routeName = "/admin/categories/new";
  RouteAdminCategoriesNew({super.key});
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.read(routeAdminCateogiresProvider.notifier);
    return LayoutAdmin(
        child: Expanded(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(children: [
                  const SizedBox(
                      width: double.maxFinite,
                      child: Card(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text('Nueva Categoria')))),
                  SizedBox(
                      width: double.maxFinite,
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Form(
                                  child: Column(children: [
                                TextFormField(
                                  onFieldSubmitted: (value) =>
                                      Navigator.of(context).pop(value),
                                  autofocus: true,
                                  controller: _nameController,
                                  decoration:
                                      const InputDecoration(hintText: 'Nombre'),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                    onPressed: () {
                                      methods
                                          .createCategory(_nameController.text)
                                          .then((_) =>
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  RouteAdminCategories
                                                      .routeName));
                                    },
                                    child: const Text('Crear'))
                              ])))))
                ]))));
  }
}
