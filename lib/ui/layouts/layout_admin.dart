import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:total_pos/ui/layouts/widgets/layout_sidebar_button.dart';
import 'package:total_pos/ui/routes/route_login.dart';
import 'package:total_pos/ui/utils/layout_helper.dart';

class LayoutAdmin extends StatelessWidget {
  const LayoutAdmin({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final helper = LayoutHelper(constraints);
      if (helper.isMobile) {
        return Scaffold(
          appBar: AppBar(title: const Text('Administrador'), centerTitle: true),
          drawer: LayoutAdminDrawer(navigationShell: navigationShell),
          body: navigationShell,
        );
      }

      return Scaffold(
        body: Row(children: [
          LayoutAdminDrawer(navigationShell: navigationShell),
          Expanded(child: navigationShell),
        ]),
      );
    });
  }
}

class LayoutAdminDrawer extends StatelessWidget {
  const LayoutAdminDrawer({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
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
                navigationShell.goBranch(0,
                    initialLocation: 0 == navigationShell.currentIndex);
              },
              text: 'Dashboard'),
          const SizedBox(height: 5),
          LayoutSideBarButton(
              onPressed: () {
                navigationShell.goBranch(1,
                    initialLocation: 1 == navigationShell.currentIndex);
              },
              text: 'Usuarios'),
          const SizedBox(height: 5),
          LayoutSideBarButton(
              onPressed: () {
                navigationShell.goBranch(2,
                    initialLocation: 2 == navigationShell.currentIndex);
              },
              text: 'Categorias'),
          const SizedBox(height: 5),
          LayoutSideBarButton(
              onPressed: () {
                navigationShell.goBranch(3,
                    initialLocation: 3 == navigationShell.currentIndex);
              },
              text: 'Productos'),
          const SizedBox(height: 5),
          LayoutSideBarButton(
              onPressed: () {
                navigationShell.goBranch(4,
                    initialLocation: 4 == navigationShell.currentIndex);
              },
              text: 'Tickets'),
          const SizedBox(height: 5),
          LayoutSideBarButton(
              onPressed: () {
                navigationShell.goBranch(5,
                    initialLocation: 5 == navigationShell.currentIndex);
              },
              text: 'Mesas'),
          const Divider(),
          LayoutSideBarButton(
              onPressed: () {
                context.replaceNamed(RouteLogin.routeName);
              },
              text: 'Cerrar sesión'),
        ],
      ),
    );
  }
}
