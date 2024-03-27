import 'package:flutter/material.dart';
import 'package:total_pos/ui/layouts/widgets/layout_sidebar_button.dart';
import 'package:total_pos/ui/routes/admin/route_admin_categories/route_admin_categories.dart';
import 'package:total_pos/ui/routes/admin/route_admin_dashboard.dart';
import 'package:total_pos/ui/routes/admin/route_admin_products.dart';
import 'package:total_pos/ui/routes/admin/route_admin_tables.dart';
import 'package:total_pos/ui/routes/admin/route_admin_tickets.dart';
import 'package:total_pos/ui/routes/admin/route_admin_users.dart';
import 'package:total_pos/ui/routes/route_login.dart';

class LayoutAdmin extends StatelessWidget {
  const LayoutAdmin({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        Drawer(
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
                        context, RouteAdminDashboard.routeName);
                  },
                  text: 'Dashboard'),
              const SizedBox(height: 5),
              LayoutSideBarButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RouteAdminUsers.routeName);
                  },
                  text: 'Usuarios'),
              const SizedBox(height: 5),
              LayoutSideBarButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RouteAdminCategories.routeName);
                  },
                  text: 'Categorias'),
              const SizedBox(height: 5),
              LayoutSideBarButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RouteAdminProduct.routeName);
                  },
                  text: 'Productos'),
              const SizedBox(height: 5),
              LayoutSideBarButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RouteAdminTickets.routeName);
                  },
                  text: 'Tickets'),
              const SizedBox(height: 5),
              LayoutSideBarButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RouteAdminTables.routeName);
                  },
                  text: 'Mesas'),
              const Divider(),
              LayoutSideBarButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteLogin.routeName, (route) => false);
                  },
                  text: 'Cerrar sesión'),
            ],
          ),
        ),
        child,
      ]),
    );
  }
}
