import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/widgets/order_maker/order_maker_provider.dart';

class CashierOrderMakerCategories extends ConsumerWidget {
  const CashierOrderMakerCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderMakerProvider);
    final methods = ref.read(orderMakerProvider.notifier);
    return SizedBox(
        height: 80,
        width: double.maxFinite,
        child: Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    if (state.currentCategory != null &&
                        state.currentCategory!.id == category.id) {
                      return FilledButton(
                          style: FilledButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          onPressed: () {},
                          child: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ));
                    }
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        onPressed: () =>
                            methods.getProductsByCategoryId(category),
                        child: Text(category.name));
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                ))));
  }
}
