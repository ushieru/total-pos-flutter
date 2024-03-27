import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/utils/layout_helper.dart';
import 'package:total_pos/ui/widgets/order_maker/order_maker_provider.dart';

class CashierOrderMakerProductsGrid extends ConsumerWidget {
  const CashierOrderMakerProductsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderMakerProvider);
    final methods = ref.read(orderMakerProvider.notifier);
    return Expanded(
        child: Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: LayoutBuilder(builder: (context, constraints) {
                  final layoutHelper = LayoutHelper(constraints);
                  final crossAxisCount = layoutHelper.isLarge
                      ? 4
                      : layoutHelper.isMedium
                          ? 3
                          : 2;
                  return GridView.count(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: crossAxisCount,
                      children: [
                        for (final product in state.products)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () => methods.addProcuct(product.id),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(product.name),
                                  Text('\$${product.price}'),
                                ]),
                          )
                      ]);
                }))));
  }
}
