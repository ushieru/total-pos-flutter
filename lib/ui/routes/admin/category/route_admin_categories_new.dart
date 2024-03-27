import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:total_pos/ui/routes/admin/category/route_admin_categories_provider.dart';

class RouteAdminCategoriesNew extends ConsumerWidget {
  static const routeName = ".admin.category.new";
  static const routePath = "new";
  RouteAdminCategoriesNew({super.key});
  final _nameController = TextEditingController();

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
                      child: Row(children: [
                        InkWell(
                          onTap: () => context.pop(),
                          child: Text(
                            'Categorias',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade400,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.deepPurple.shade400),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('/'),
                        const SizedBox(width: 10),
                        const Text('Nueva'),
                      ])))),
          SizedBox(
              width: double.maxFinite,
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Form(
                          child: Column(children: [
                        TextFormField(
                          onFieldSubmitted: (_) {
                            methods
                                .createCategory(_nameController.text)
                                .then((_) => context.pop());
                          },
                          autofocus: true,
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Nombre'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              methods
                                  .createCategory(_nameController.text)
                                  .then((_) => context.pop());
                            },
                            child: const Text('Crear'))
                      ])))))
        ]));
  }
}
