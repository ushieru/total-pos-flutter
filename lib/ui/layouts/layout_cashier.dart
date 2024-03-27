import 'package:flutter/material.dart';
import 'package:total_pos/ui/layouts/widgets/layout_cashier_drawer.dart';
import 'package:total_pos/ui/utils/layout_helper.dart';

class LayoutCashier extends StatelessWidget {
  const LayoutCashier({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final layoutHelper = LayoutHelper(constraints);
      if (layoutHelper.isMobile) {
        return Scaffold(
            drawer: const LayoutCashierDrawer(), appBar: AppBar(), body: child);
      }
      return Scaffold(
          body: Row(children: [const LayoutCashierDrawer(), child]));
    });
  }
}
