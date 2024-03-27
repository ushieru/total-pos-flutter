import 'package:go_router/go_router.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/ui/layouts/layout_admin.dart';
import 'package:total_pos/ui/routes/admin/category/route_admin_categories.dart';
import 'package:total_pos/ui/routes/admin/category/route_admin_categories_new.dart';
import 'package:total_pos/ui/routes/admin/category/route_admin_categories_update.dart';
import 'package:total_pos/ui/routes/admin/dashboard/route_admin_dashboard.dart';
import 'package:total_pos/ui/routes/admin/product/route_admin_product_update.dart';
import 'package:total_pos/ui/routes/admin/product/route_admin_products.dart';
import 'package:total_pos/ui/routes/admin/table/route_admin_tables.dart';
import 'package:total_pos/ui/routes/admin/ticket/route_admin_tickets.dart';
import 'package:total_pos/ui/routes/admin/user/route_admin_users.dart';

class AdminRouter {
  StatefulShellRoute get route => StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              LayoutAdmin(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                  name: RouteAdminDashboard.routeName,
                  path: RouteAdminDashboard.routePath,
                  builder: (context, state) => const RouteAdminDashboard())
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: RouteAdminUsers.routeName,
                  path: RouteAdminUsers.routePath,
                  builder: (context, state) => const RouteAdminUsers())
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: RouteAdminCategories.routeName,
                  path: RouteAdminCategories.routePath,
                  builder: (context, state) => const RouteAdminCategories(),
                  routes: [
                    GoRoute(
                      name: RouteAdminCategoriesNew.routeName,
                      path: RouteAdminCategoriesNew.routePath,
                      builder: (context, state) => RouteAdminCategoriesNew(),
                    ),
                    GoRoute(
                      name: RouteAdminCategoriesUpdate.routeName,
                      path: RouteAdminCategoriesUpdate.routePath,
                      builder: (context, state) => RouteAdminCategoriesUpdate(
                          category: state.extra as Category),
                    ),
                  ])
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: RouteAdminProduct.routeName,
                  path: RouteAdminProduct.routePath,
                  builder: (context, state) => const RouteAdminProduct(),
                  routes: [
                    GoRoute(
                      name: RouteAdminProductUpdate.routeName,
                      path: RouteAdminProductUpdate.routePath,
                      builder: (context, state) => RouteAdminProductUpdate(
                          product: state.extra as dynamic),
                    )
                  ])
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: RouteAdminTickets.routeName,
                  path: RouteAdminTickets.routePath,
                  builder: (context, state) => const RouteAdminTickets())
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  name: RouteAdminTables.routeName,
                  path: RouteAdminTables.routePath,
                  builder: (context, state) => RouteAdminTables())
            ]),
          ]);
}
