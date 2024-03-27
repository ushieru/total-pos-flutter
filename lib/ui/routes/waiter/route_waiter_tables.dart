import 'package:flutter/material.dart' hide Table;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/ui/layouts/layout_waiter.dart';
import 'package:total_pos/ui/routes/waiter/route_waiter_order_maker.dart';
import 'package:total_pos/ui/routes/waiter/route_waiter_tables_provider.dart';
import 'package:total_pos/ui/utils/functions.dart';
import 'package:total_pos/ui/utils/session.dart';

class RouteWaiterTables extends ConsumerWidget {
  static const routeName = "/waiter/tables";
  RouteWaiterTables({super.key});

  final onceGetTables = once();
  final getTablesEvery =
      every(const Duration(seconds: 5), 'RouteWaiterTables:getTables');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routeWaiterTablesProvider);
    final methods = ref.watch(routeWaiterTablesProvider.notifier);
    onceGetTables(() {
      methods.getTables();
      getTablesEvery((cancel) {
        if (!context.mounted) {
          cancel();
          return;
        }
        methods.getTables();
      });
    });
    return LayoutWaiter(
        child: Expanded(
            child: Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TablesCanvas(tables: state)))));
  }
}

class TablesCanvas extends ConsumerWidget {
  const TablesCanvas({super.key, required this.tables});

  final List<Table> tables;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.watch(routeWaiterTablesProvider.notifier);
    return LayoutBuilder(builder: (context, constraints) {
      var baseCanvasSize = const Size(0, 0);
      var isVertical = false;
      if (constraints.maxWidth > constraints.maxHeight) {
        baseCanvasSize = const Size(1600, 900);
        isVertical = false;
      } else {
        baseCanvasSize = const Size(900, 1600);
        isVertical = true;
      }
      final scale = (constraints.maxWidth / baseCanvasSize.width +
              constraints.maxHeight / baseCanvasSize.height) /
          2;
      final scaleSize = const Size(100, 100) * scale;
      return Container(
          color: Colors.black26,
          child: Stack(
              children: tables.map((table) {
            final sessionId = SessionSingleton().account.id;
            final isEmptyTable = table.accountId.isEmpty;
            final isMyTable = table.accountId == sessionId;
            final tableColor = isEmptyTable
                ? Colors.white
                : isMyTable
                    ? Colors.green
                    : Colors.red;
            final offset =
                Offset(table.offsetX.toDouble(), table.offsetY.toDouble());
            final scaleOffset = offset * scale;
            return Positioned(
                left: !isVertical ? scaleOffset.dx : null,
                right: isVertical ? scaleOffset.dy : null,
                top: isVertical ? scaleOffset.dx : scaleOffset.dy,
                child: SizedBox(
                  height: scaleSize.height,
                  width: scaleSize.width,
                  child: IconButton(
                    color: tableColor,
                    iconSize: scaleSize.width * 0.6,
                    icon: const Icon(Icons.table_bar),
                    onPressed: () {
                      if (!isEmptyTable && !isMyTable) {
                        showToast('Esta mesa no es tuya',
                            position: ToastPosition.bottom);
                      }
                      if (isEmptyTable) {
                        methods.openTable(table).then((ticketId) =>
                            Navigator.pushReplacementNamed(
                                context, RouteWaiterOrderMaker.routeName,
                                arguments: ticketId));
                      }
                      if (isMyTable) {
                        Navigator.pushReplacementNamed(
                            context, RouteWaiterOrderMaker.routeName,
                            arguments: table.ticketId);
                      }
                    },
                  ),
                ));
          }).toList()));
    });
  }
}
