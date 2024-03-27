import 'package:flutter/material.dart';
import 'package:total_pos/ui/layouts/layout_cashier.dart';

class RouteCashierDashboard extends StatelessWidget {
  static const routeName = "/cashier/dashboard";
  const RouteCashierDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutCashier(child: Container());
  }
}
