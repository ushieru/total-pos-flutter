import 'package:flutter/material.dart';
import 'package:total_pos/ui/widgets/tables/table_tickets.dart';

class RouteAdminTickets extends StatelessWidget {
  static const routeName = "admin.tickets";
  static const routePath = "/admin/tickets";
  const RouteAdminTickets({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(children: const [
          SizedBox(
              width: double.maxFinite,
              child: Card(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TableTickets(),
              )))
        ]));
  }
}
