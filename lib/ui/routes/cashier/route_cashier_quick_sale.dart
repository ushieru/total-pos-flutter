import 'package:flutter/material.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/grpc/client.dart';
import 'package:total_pos/ui/layouts/layout_cashier.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_order_maker.dart';

class RouteCashierQuickSale extends StatelessWidget {
  static const routeName = "/cashier/quicksale";
  const RouteCashierQuickSale({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => GrpcClientSingleton()
        .ticketClient
        .createTicket(Empty())
        .then((ticket) => Navigator.pushReplacementNamed(
            context, RouteCashierOrderMaker.routeName,
            arguments: ticket.id)));
    return const LayoutCashier(
        child: Expanded(
      child: Center(
          child: Card(
              child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CircularProgressIndicator(),
      ))),
    ));
  }
}
