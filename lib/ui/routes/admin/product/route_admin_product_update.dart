import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/ui/routes/admin/product/route_admin_product_update_provider.dart';
import 'package:total_pos/ui/utils/functions.dart';

class RouteAdminProductUpdate extends ConsumerWidget {
  static const routeName = "admin.product.update";
  static const routePath = "update";
  RouteAdminProductUpdate({super.key, required this.product});

  final Product product;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final onInit = once();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routeAdminProductUpdateProvider);
    final methods = ref.read(routeAdminProductUpdateProvider.notifier);
    onInit(() {
      methods.getCategoriesByProductId(product.id);
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
    });
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
                            'Productos',
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
                        Text(product.name),
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
                          autofocus: true,
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Nombre'),
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          decoration:
                              const InputDecoration(labelText: 'Descripcion'),
                        ),
                        TextFormField(
                            controller: _priceController,
                            decoration:
                                const InputDecoration(labelText: 'Precio'),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              methods
                                  .updateProduct(
                                      product,
                                      _nameController.text,
                                      _descriptionController.text,
                                      double.tryParse(_priceController.text) ??
                                          0)
                                  .then((_) => showToast('Producto actualizado',
                                      position: ToastPosition.bottom));
                            },
                            child: const Text('Actualizar'))
                      ]))))),
          SizedBox(
              width: double.maxFinite,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Card(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(children: [
                              const Text('Categorias'),
                              const SizedBox(height: 10),
                              for (final category in state.filtercategories)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ElevatedButton.icon(
                                      onPressed: () {
                                        methods.addCategoryToProduct(
                                            product, category.id);
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
                              for (final category in state.productCategories)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ElevatedButton.icon(
                                      onPressed: () {
                                        methods.deleteCategoryToProduct(
                                            product, category.id);
                                      },
                                      icon: const Icon(Icons.remove),
                                      label: Text(category.name)),
                                )
                            ]))))
              ]))
        ]));
  }
}
