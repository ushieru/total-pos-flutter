import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:total_pos/ui/routes/admin/table/route_admin_tables_provider.dart';
import 'package:total_pos/ui/widgets/dialogs/dialog_confirm.dart';

class RouteAdminTables extends ConsumerWidget {
  static const routeName = "admin.tables";
  static const routePath = "/admin/tables";
  RouteAdminTables({super.key});

  final _newTableNameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.read(routeAdminTablesProvider.notifier);
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          SizedBox(
              width: double.maxFinite,
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(children: [
                        TextFormField(
                          controller: _newTableNameController,
                          decoration: const InputDecoration(
                              labelText: 'Nombre de la nueva mesa'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () {
                              if (_newTableNameController.text.trim().isEmpty) {
                                showToast('No se permiten nombres vacios',
                                    position: ToastPosition.bottom);
                                return;
                              }
                              methods.createTable(_newTableNameController.text);
                              _newTableNameController.text = '';
                            },
                            child: const Text('Nueva mesa')),
                      ])))),
          const Expanded(
              child: Card(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TablesDraggableCanvas())))
        ]));
  }
}

class TablesDraggableCanvas extends ConsumerStatefulWidget {
  const TablesDraggableCanvas({super.key});

  @override
  TablesDraggableCanvasState createState() => TablesDraggableCanvasState();
}

class TablesDraggableCanvasState extends ConsumerState<TablesDraggableCanvas> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(routeAdminTablesProvider);
    final methods = ref.watch(routeAdminTablesProvider.notifier);
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
              children: state.map((table) {
            final offset =
                Offset(table.offsetX.toDouble(), table.offsetY.toDouble());
            final scaleOffset = offset * scale;
            return Positioned(
                left: !isVertical ? scaleOffset.dx : null,
                right: isVertical ? scaleOffset.dy : null,
                top: isVertical ? scaleOffset.dx : scaleOffset.dy,
                child: GestureDetector(
                    onPanUpdate: (details) {
                      // TODO: Vertical controller
                      final dxOffset =
                          table.offsetX + (details.delta.dx / scale);
                      final dyOffset =
                          table.offsetY + (details.delta.dy / scale);
                      final maxX = constraints.maxWidth;
                      final maxY = constraints.maxHeight;
                      if (scaleOffset.dx < 1 && details.delta.dx < 0) return;
                      if (scaleOffset.dy < 1 && details.delta.dy < 0) return;
                      if (scaleOffset.dx + scaleSize.width > maxX &&
                          details.delta.dx > 0) return;
                      if (scaleOffset.dy + scaleSize.height > maxY &&
                          details.delta.dy > 0) return;
                      setState(() {
                        table.offsetX = dxOffset.toInt();
                        table.offsetY = dyOffset.toInt();
                      });
                    },
                    child: PopupMenuButton(
                        tooltip: '',
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(child: Text('Editar nombre')),
                            PopupMenuItem(
                                onTap: () => DialogConfirm.show(
                                            context,
                                            'Eliminar mesa',
                                            'Seguro que desea eliminar la mesa: "${table.name}" con id: "${table.id}"?')
                                        .then((response) {
                                      if (!response) return;
                                      methods.deleteTable(table);
                                    }),
                                child: const Text('Eliminar')),
                          ];
                        },
                        child: SizedBox(
                          height: scaleSize.height,
                          width: scaleSize.width,
                          child: Icon(Icons.table_bar,
                              size: scaleSize.width * 0.6),
                        ))));
          }).toList()));
    });
  }
}
