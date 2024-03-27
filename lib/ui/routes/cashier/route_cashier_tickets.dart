import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/layouts/layout_cashier.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_order_maker.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_tickets_provider.dart';
import 'package:total_pos/ui/utils/functions.dart';

class RouteCashierTickets extends ConsumerWidget {
  static const routeName = "/cashier/tickets";
  RouteCashierTickets({super.key});

  final Function onceGetTickets = once();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routeCashierTicketsProvider);
    final methods = ref.read(routeCashierTicketsProvider.notifier);
    onceGetTickets(methods.getTickets);
    return LayoutCashier(
        child: Expanded(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(children: [
                  Expanded(
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: GridView.count(
                                  mainAxisSpacing: 13,
                                  crossAxisSpacing: 13,
                                  crossAxisCount: 4,
                                  children: [
                                    for (final ticket in state)
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)))),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context,
                                                RouteCashierOrderMaker
                                                    .routeName,
                                                arguments: ticket.id);
                                          },
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('ID: ${ticket.id}'),
                                                Text(
                                                    'Productos: ${ticket.products.length}'),
                                                Text('Total: \$${ticket.total}')
                                              ]))
                                  ]))))
                ]))));
  }
}
