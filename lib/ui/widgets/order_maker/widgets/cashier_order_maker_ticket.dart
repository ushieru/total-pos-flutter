import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/widgets/order_maker/order_maker_provider.dart';
import 'package:total_pos/ui/widgets/order_maker/widgets/cashier_order_maker_ticket_buttons.dart';
import 'package:total_pos/ui/widgets/order_maker/widgets/cashier_order_maker_ticket_products.dart';

class CashierOrderMakerTicket extends ConsumerWidget {
  const CashierOrderMakerTicket({super.key, this.showCloseButton = false});

  final bool showCloseButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderMakerProvider);
    return SizedBox(
        height: double.maxFinite,
        width: 300,
        child: Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ticket #${state.ticket?.id}'),
                            if (showCloseButton)
                              IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close))
                          ]),
                      const Divider(),
                      const CashierOrderMakerTicketProducts(),
                      const Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:'),
                            Text('\$${state.ticket?.total ?? 0}')
                          ]),
                      const Divider(),
                      const CashierOrderMakerTicketButtons(),
                    ]))));
  }
}
