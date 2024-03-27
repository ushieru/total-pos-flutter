import 'package:flutter/material.dart';
import 'package:total_pos/ui/layouts/widgets/layout_sidebar_button.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_dashboard.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_quick_sale.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_tickets.dart';
import 'package:total_pos/ui/routes/route_login.dart';

class LayoutCashierDrawer extends StatelessWidget {
  const LayoutCashierDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      child: ListView(
        children: [
          Container(
              width: double.infinity,
              height: 120,
              alignment: Alignment.center,
              child: Image.asset('lib/assets/favicon.png',
                  width: 90, filterQuality: FilterQuality.high)),
          LayoutSideBarButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, RouteCashierDashboard.routeName);
            },
            text: 'Dashboard',
          ),
          const SizedBox(height: 5),
          LayoutSideBarButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, RouteCashierTickets.routeName);
            },
            text: 'Tickets',
          ),
          const SizedBox(height: 5),
          LayoutSideBarButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, RouteCashierQuickSale.routeName);
            },
            text: 'Venta Rapida',
          ),
          const Divider(),
          LayoutSideBarButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteLogin.routeName, (route) => false);
            },
            text: 'Cerrar sesión',
          ),
        ],
      ),
    );
  }
}
