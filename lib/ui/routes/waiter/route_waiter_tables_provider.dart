import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/grpc/client.dart';

class RouteWaiterTablesNofitier extends Notifier<List<Table>> {
  @override
  build() => [];

  final _grpcClient = GrpcClientSingleton();

  void getTables() {
    _grpcClient.tableClient
        .readTables(Empty())
        .then((response) => state = response.tables);
  }

  Future<String> openTable(Table table) async {
    final ticket =
        await _grpcClient.tableClient.openTable(TableByIdRequest(id: table.id));
    getTables();
    return ticket.ticketId;
  }
}

final routeWaiterTablesProvider =
    NotifierProvider<RouteWaiterTablesNofitier, List<Table>>(
        RouteWaiterTablesNofitier.new);
