import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/ui/routes/waiter/route_waiter_tables.dart';
import 'package:total_pos/ui/utils/session.dart';
import 'package:total_pos/ui/widgets/order_maker/order_maker_provider.dart';
import 'package:total_pos/ui/widgets/order_maker/widgets/dialogs/dialog_pay_ticket.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_tickets.dart';

final _buttonStyle = ElevatedButton.styleFrom(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))));

class CashierOrderMakerTicketButtons extends ConsumerWidget {
  const CashierOrderMakerTicketButtons({super.key});

  void Function()? ifProductsIsEmpty(
      List<TicketProduct> products, void Function() function) {
    if (products.isEmpty) return function;
    return null;
  }

  void Function()? ifProductsIsNotEmpty(
      List<TicketProduct> products, void Function() function) {
    if (products.isNotEmpty) return function;
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderMakerProvider);
    final methods = ref.read(orderMakerProvider.notifier);
    return Row(children: [
      Expanded(
        child: ElevatedButton(
            style: _buttonStyle,
            onPressed:
                ifProductsIsEmpty(state.ticket?.products ?? [], () async {
              methods.cancelOrder().then((_) {
                if (SessionSingleton().account.accountType ==
                    AccountType.CASHIER) {
                  Navigator.pushReplacementNamed(
                      context, RouteCashierTickets.routeName);
                }
                if (SessionSingleton().account.accountType ==
                    AccountType.WAITER) {
                  Navigator.pushReplacementNamed(
                      context, RouteWaiterTables.routeName);
                }
              });
            }),
            child: const Text('Cancelar')),
      ),
      const SizedBox(width: 5),
      Expanded(
        child: ElevatedButton(
            style: _buttonStyle,
            onPressed:
                ifProductsIsNotEmpty(state.ticket?.products ?? [], () async {
              if (state.ticket == null) return;
              final reponse =
                  await DialogPayTicket.show(context, state.ticket!);
              if (!reponse) return;
              methods.payOrder().then((_) {
                if (SessionSingleton().account.accountType ==
                    AccountType.CASHIER) {
                  Navigator.pushReplacementNamed(
                      context, RouteCashierTickets.routeName);
                }
                if (SessionSingleton().account.accountType ==
                    AccountType.WAITER) {
                  Navigator.pushReplacementNamed(
                      context, RouteWaiterTables.routeName);
                }
              });
            }),
            child: const Text('Cobrar')),
      )
    ]);
  }
}
