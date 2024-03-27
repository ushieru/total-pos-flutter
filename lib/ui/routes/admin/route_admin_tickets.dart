import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/layouts/layout_admin.dart';
import 'package:total_pos/ui/widgets/tables/table_tickets.dart';

class RouteAdminTickets extends ConsumerWidget {
  static const routeName = "/admin/tickets";
  const RouteAdminTickets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutAdmin(
        child: Expanded(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(children: const [
                  SizedBox(
                      width: double.maxFinite,
                      child: Card(
                          child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TableTickets(),
                      )))
                ]))));
  }
}
