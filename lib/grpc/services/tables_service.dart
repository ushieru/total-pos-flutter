import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/grpc/services/mappers/pos_table_data_to_grpc_table_mapper.dart';
import 'package:total_pos/grpc/utils/session.dart';
import 'package:total_pos/repositories/drift/table_drift_repository.dart';
import 'package:total_pos/repositories/drift/ticket_drift_repository.dart';

class TableService extends TableServiceBase {
  TableService() : super();

  final _tableRepository = GetIt.I.get<TableDriftRepository>();
  final _ticketRepository = GetIt.I.get<TicketDriftRepository>();
  final _sessionController = GetIt.I.get<Session>();

  @override
  Future<Table> createTable(
      ServiceCall call, CreateTableRequest request) async {
    final table = await _tableRepository.createTable(request.name);
    return PosTableDataToGrpcTableMapper(table).map();
  }

  @override
  Future<Table> deleteTable(ServiceCall call, TableByIdRequest request) async {
    final table = await _tableRepository.readTableById(request.id);
    if (table == null) {
      throw const GrpcError.notFound('Mesa no encontrada');
    }
    if (table.ticketId?.isNotEmpty ?? false) {
      throw const GrpcError.notFound('Esta mesa no esta vacia');
    }
    await _tableRepository.deleteTable(table);
    return PosTableDataToGrpcTableMapper(table).map();
  }

  @override
  Future<Table> openTable(ServiceCall call, TableByIdRequest request) async {
    final response = await _tableRepository.readTableById(request.id);
    if (response == null) {
      throw const GrpcError.notFound('Mesa no encontrada');
    }
    final accountId = _sessionController.getSession(call);
    final ticket = await _ticketRepository.createTicket(accountId!);
    final table =
        await _tableRepository.openTable(request.id, accountId, ticket.id);
    return PosTableDataToGrpcTableMapper(table).map();
  }

  @override
  Future<Tables> readTables(ServiceCall call, Empty request) async {
    final tables = await _tableRepository.readTables();
    return Tables(
        tables: tables.map((e) => PosTableDataToGrpcTableMapper(e).map()));
  }

  @override
  Future<Table> updateOffset(
      ServiceCall call, UpdateOffsetRequest request) async {
    final table = await _tableRepository.readTableById(request.id);
    if (table == null) {
      throw const GrpcError.notFound('Mesa no encontrada');
    }
    final updatedTable = await _tableRepository.updateOffset(
        request.id, request.offsetX, request.offsetY);
    return PosTableDataToGrpcTableMapper(updatedTable).map();
  }

  @override
  Future<Table> updateTable(
      ServiceCall call, UpdateTableRequest request) async {
    final table = await _tableRepository.readTableById(request.id);
    if (table == null) {
      throw const GrpcError.notFound('Mesa no encontrada');
    }
    final updatedTable =
        await _tableRepository.updateTable(request.id, request.name);
    return PosTableDataToGrpcTableMapper(updatedTable).map();
  }
}
