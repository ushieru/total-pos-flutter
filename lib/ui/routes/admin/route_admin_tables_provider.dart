import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/grpc/client.dart';

class RouteAdminTablesNofitier extends Notifier<List<Table>> {
  RouteAdminTablesNofitier() {
    getTables();
  }

  @override
  build() => [];

  final _grpcClient = GrpcClientSingleton();

  void getTables() {
    _grpcClient.tableClient
        .readTables(Empty())
        .then((response) => state = response.tables);
  }

  void createTable(String name) async {
    _grpcClient.tableClient
        .createTable(CreateTableRequest(name: name))
        .then((_) => getTables());
  }

  void updateTable(Table table, String name) async {
    _grpcClient.tableClient
        .updateTable(UpdateTableRequest(id: table.id, name: name))
        .then((_) => getTables());
  }

  void updateOffset(Table table, int offsetX, int offsetY) async {
    _grpcClient.tableClient
        .updateOffset(UpdateOffsetRequest(
            id: table.id, offsetX: offsetX, offsetY: offsetY))
        .then((_) => getTables());
  }

  void deleteTable(Table table) async {
    _grpcClient.tableClient
        .deleteTable(TableByIdRequest(id: table.id))
        .then((_) => getTables())
        .catchError((error) {
      if (error is GrpcError) {
        showToast(error.message ?? '', position: ToastPosition.bottom);
      }
    });
  }
}

final routeAdminTablesProvider =
    NotifierProvider<RouteAdminTablesNofitier, List<Table>>(
        RouteAdminTablesNofitier.new);
