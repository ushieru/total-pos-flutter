import 'package:flutter/material.dart';
import 'package:total_pos/ui/layouts/layout_waiter.dart';
import 'package:total_pos/ui/widgets/order_maker/order_maker.dart';

class RouteWaiterOrderMaker extends StatelessWidget {
  static const routeName = "/waiter/order";
  const RouteWaiterOrderMaker({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context) {
    return LayoutWaiter(
        child: Expanded(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: OrderMaker(ticketId: ticketId))));
  }
}
