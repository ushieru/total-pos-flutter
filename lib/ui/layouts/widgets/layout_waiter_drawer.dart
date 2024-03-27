import 'package:flutter/material.dart';
import 'package:total_pos/ui/layouts/widgets/layout_sidebar_button.dart';
import 'package:total_pos/ui/routes/route_login.dart';
import 'package:total_pos/ui/routes/waiter/route_waiter_tables.dart';

class LayoutWaiterDrawer extends StatelessWidget {
  const LayoutWaiterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 200,
        child: ListView(children: [
          Container(
              width: double.infinity,
              height: 120,
              alignment: Alignment.center,
              child: Image.asset('lib/assets/favicon.png',
                  width: 90, filterQuality: FilterQuality.high)),
          LayoutSideBarButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                  context, RouteWaiterTables.routeName);
            },
            text: 'Tables',
          ),
          const Divider(),
          LayoutSideBarButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteLogin.routeName, (route) => false);
            },
            text: 'Cerrar sesión',
          )
        ]));
  }
}
