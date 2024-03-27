import 'package:flutter/material.dart';
import 'package:total_pos/ui/layouts/widgets/layout_waiter_drawer.dart';
import 'package:total_pos/ui/utils/layout_helper.dart';

class LayoutWaiter extends StatelessWidget {
  const LayoutWaiter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final layoutHelper = LayoutHelper(constraints);
      if (layoutHelper.isMobile) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Total POS'),
            centerTitle: true,
          ),
          drawer: const LayoutWaiterDrawer(),
          body: Column(children: [child]),
        );
      }
      return Scaffold(body: Row(children: [const LayoutWaiterDrawer(), child]));
    });
  }
}
