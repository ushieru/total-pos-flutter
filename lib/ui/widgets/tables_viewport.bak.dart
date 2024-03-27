import 'package:flutter/material.dart' hide Table;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/ui/routes/admin/route_admin_tables_provider.dart';
import 'package:total_pos/ui/widgets/dialogs/dialog_confirm.dart';

class TableObject {
  TableObject({
    required this.table,
    required this.offset,
    required this.size,
    required this.child,
  });

  Table table;
  Offset offset;
  Size size;
  Widget child;
}

class TablesViewport extends ConsumerStatefulWidget {
  const TablesViewport({super.key, required this.tables, this.isAdmin = false});

  final List<TableObject> tables;
  final bool isAdmin;

  @override
  ConsumerState createState() => TablesViewportState();
}

class TablesViewportState extends ConsumerState<TablesViewport> {
  final baseWidth = 1600.0;
  final baseHeight = 900.0;

  @override
  Widget build(BuildContext context) {
    final methods = ref.read(routeAdminTablesProvider.notifier);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (!widget.isAdmin) {
        return TablesViewPortMobile(tables: widget.tables);
      }
      return Stack(
          children: widget.tables.map((object) {
        final scaleWidth = object.size.width / baseWidth * constraints.maxWidth;
        final scaleHeight =
            object.size.height / baseHeight * constraints.maxHeight;
        final fixedX = object.offset.dx * constraints.maxWidth / baseWidth;
        final fixedY = object.offset.dy * constraints.maxHeight / baseHeight;
        return Positioned(
            left: fixedX,
            top: fixedY,
            child: GestureDetector(
                onPanUpdate: (details) {
                  final maxOffset = Offset(constraints.maxWidth - scaleWidth,
                      constraints.maxHeight - scaleHeight);
                  final dyOffset = fixedY + details.delta.dy;
                  final dxOffset = fixedX + details.delta.dx;
                  if (dyOffset < 0 || dyOffset > maxOffset.dy) {
                    return;
                  }
                  if (dxOffset < 0 || dxOffset > maxOffset.dx) {
                    return;
                  }
                  setState(() => object.offset = Offset(
                      object.offset.dx + details.delta.dx,
                      object.offset.dy + details.delta.dy));
                },
                onPanEnd: (details) {
                  methods.updateOffset(object.table, object.offset.dx.toInt(),
                      object.offset.dy.toInt());
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
                                      'Seguro que desea eliminar la mesa: "${object.table.name}" con id: "${object.table.id}"?')
                                  .then((response) {
                                if (!response) return;
                                methods.deleteTable(object.table);
                              }),
                          child: const Text('Eliminar')),
                    ];
                  },
                  child: SizedBox(
                    width: scaleWidth,
                    height: scaleHeight,
                    child: Column(children: [
                      Icon(Icons.table_bar, size: scaleHeight * .6),
                      Text(object.table.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                )));
      }).toList());
    });
  }
}

class TablesViewPortMobile extends StatelessWidget {
  const TablesViewPortMobile({super.key, required this.tables});

  final List<TableObject> tables;
  final baseWidth = 900.0;
  final baseHeight = 1600.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
          children: tables.map((object) {
        final scaleHeight =
            object.size.height / baseHeight * constraints.maxHeight;
        final scaleWidth = object.size.width / baseWidth * constraints.maxWidth;
        final fixedX = object.offset.dx * constraints.maxWidth / baseWidth;
        final fixedY = object.offset.dy * constraints.maxHeight / baseHeight;
        return Positioned(
            top: fixedX,
            right: fixedY,
            child: SizedBox(
                height: scaleHeight, width: scaleWidth, child: object.child));
      }).toList());
    });
  }
}
