import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/layouts/layout_cashier.dart';
import 'package:total_pos/ui/widgets/order_maker/order_maker.dart';

class RouteCashierOrderMaker extends ConsumerWidget {
  static const routeName = "/cashier/ordermaker";
  const RouteCashierOrderMaker({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutCashier(
        child: Expanded(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: OrderMaker(ticketId: ticketId))));
  }
}
