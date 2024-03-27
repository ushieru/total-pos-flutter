import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:total_pos/grpc/server.dart';
import 'package:total_pos/ui/routes/admin/route_admin_categories/route_admin_categories.dart';
import 'package:total_pos/ui/routes/admin/route_admin_categories/route_admin_categories_new.dart';
import 'package:total_pos/ui/routes/admin/route_admin_dashboard.dart';
import 'package:total_pos/ui/routes/admin/route_admin_product_categories.dart';
import 'package:total_pos/ui/routes/admin/route_admin_products.dart';
import 'package:total_pos/ui/routes/admin/route_admin_tables.dart';
import 'package:total_pos/ui/routes/admin/route_admin_tickets.dart';
import 'package:total_pos/ui/routes/admin/route_admin_users.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_dashboard.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_order_maker.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_quick_sale.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_tickets.dart';
import 'package:total_pos/ui/routes/route_login.dart';
import 'package:total_pos/ui/routes/waiter/route_waiter_order_maker.dart';
import 'package:total_pos/ui/routes/waiter/route_waiter_tables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GrpcServer().main();
  Intl.defaultLocale = 'es';
  initializeDateFormatting('es');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: OKToast(child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  PageRouteBuilder noAnimated(Widget widget) {
    return PageRouteBuilder(pageBuilder: (_, __, ___) => widget);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Total Pos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
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
    );
  }
}
