import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/utils/functions.dart';
import 'package:total_pos/ui/utils/layout_helper.dart';
import 'package:total_pos/ui/widgets/order_maker/order_maker_provider.dart';
import 'package:total_pos/ui/widgets/order_maker/widgets/cashier_order_maker_categories.dart';
import 'package:total_pos/ui/widgets/order_maker/widgets/cashier_order_maker_products_grid.dart';
import 'package:total_pos/ui/widgets/order_maker/widgets/cashier_order_maker_ticket.dart';

class OrderMaker extends ConsumerWidget {
  OrderMaker({super.key, required this.ticketId});

  final String ticketId;
  final loadTicket = once();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(orderMakerProvider);
    final methods = ref.read(orderMakerProvider.notifier);
    loadTicket(() => methods.loadTicket(ticketId));
    if (state.isLoading) {
      return const Center(
          child: Card(
              child: Padding(
        padding: EdgeInsets.all(12),
        child: CircularProgressIndicator(),
      )));
    }
    return LayoutBuilder(builder: (context, constraints) {
      final layoutHelper = LayoutHelper(constraints);
      if (layoutHelper.isMobile) {
        return Column(children: [
          const CashierOrderMakerCategories(),
          const SizedBox(height: 10),
          const CashierOrderMakerProductsGrid(),
          SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => const Dialog.fullscreen(
                            child: CashierOrderMakerTicket(
                                showCloseButton: true)));
                  },
                  child: const Text('Ticket')))
        ]);
      }
      return const Row(children: [
        Expanded(
            child: Column(children: [
          CashierOrderMakerCategories(),
          SizedBox(height: 10),
          CashierOrderMakerProductsGrid(),
        ])),
        SizedBox(width: 10),
        CashierOrderMakerTicket(),
      ]);
    });
  }
}
