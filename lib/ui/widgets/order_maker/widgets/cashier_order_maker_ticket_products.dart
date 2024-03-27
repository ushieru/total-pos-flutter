import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/widgets/order_maker/order_maker_provider.dart';

class CashierOrderMakerTicketProducts extends ConsumerWidget {
  const CashierOrderMakerTicketProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderMakerProvider);
    final methods = ref.read(orderMakerProvider.notifier);

    if (state.ticket == null) {
      return const Expanded(child: SizedBox());
    }

    return Expanded(
        child: ListView(children: [
      for (final product in state.ticket!.products)
        Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(product.name),
            Text('\$${product.price} c/u'),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              IconButton(
                  onPressed: () => methods.deleteProduct(product.productId),
                  icon: const Icon(Icons.remove)),
              Text('${product.quantity}'),
              IconButton(
                  onPressed: () => methods.addProcuct(product.productId),
                  icon: const Icon(Icons.add)),
            ]),
            Text('\$${product.quantity * product.price}'),
          ]),
        ])
    ]));
  }
}
