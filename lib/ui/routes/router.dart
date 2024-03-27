import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:total_pos/ui/routes/admin/admin_router.dart';
import 'package:total_pos/ui/routes/route_login.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', redirect: (context, state) => RouteLogin.routePath),
    GoRoute(
        name: RouteLogin.routeName,
        path: RouteLogin.routePath,
        builder: (BuildContext context, GoRouterState state) {
          return const RouteLogin();
        }),
    AdminRouter().route,
  ],
);

/** 
 
      initialRoute: RouteLogin.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteLogin.routeName:
            return noAnimated(const RouteLogin());
          case RouteAdminDashboard.routeName:
            return noAnimated(const RouteAdminDashboard());
          case RouteAdminUsers.routeName:
            return noAnimated(const RouteAdminUsers());
          case RouteAdminCategories.routeName:
            return noAnimated(const RouteAdminCategories());
          case RouteAdminCategoriesNew.routeName:
            return noAnimated(RouteAdminCategoriesNew());
          case RouteAdminProduct.routeName:
            return noAnimated(const RouteAdminProduct());
          case RouteAdminProductCategories.routeName:
            final args =
                settings.arguments as RouteAdminProductCategoriesArguments?;
            if (args == null) {
              throw 'Olvidaste pasar RouteAdminProductCategoriesArguments'
                  'como argumento para RouteAdminProductCategories?';
            }
            return noAnimated(RouteAdminProductCategories(
              productId: args.productId,
            ));
          case RouteAdminTickets.routeName:
            return noAnimated(const RouteAdminTickets());
          case RouteAdminTables.routeName:
            return noAnimated(RouteAdminTables());
          case RouteCashierDashboard.routeName:
            return noAnimated(const RouteCashierDashboard());
          case RouteCashierQuickSale.routeName:
            return noAnimated(const RouteCashierQuickSale());
          case RouteCashierOrderMaker.routeName:
            final ticketId = settings.arguments as String?;
            if (ticketId == null) {
              throw 'Olvidaste pasar ticketId como argumento'
                  'para RouteCashierOrderMaker?';
            }
            return noAnimated(RouteCashierOrderMaker(ticketId: ticketId));
          case RouteCashierTickets.routeName:
            return noAnimated(RouteCashierTickets());
          case RouteWaiterTables.routeName:
            return noAnimated(RouteWaiterTables());
          case RouteWaiterOrderMaker.routeName:
            final ticketId = settings.arguments as String?;
            if (ticketId == null) {
              throw 'Olvidaste pasar ticketId como argumento'
                  'para RouteCashierOrderMaker?';
            }
            return noAnimated(RouteWaiterOrderMaker(ticketId: ticketId));
          default:
            if (settings.name != '/') {
              showToast(
                  'Ruta: ${settings.name} no encontrada, consulte al desarrollador');
            }
            return noAnimated(const RouteLogin());
        }
      },
*/