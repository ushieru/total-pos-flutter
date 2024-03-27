import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/repositories/drift/drift_repository.dart';

class PosTableDataToGrpcTableMapper {
  PosTableDataToGrpcTableMapper(this.posTableData);

  final PosTableData posTableData;

  Table map() {
    return Table(
      id: posTableData.id,
      name: posTableData.name,
      offsetX: posTableData.offsetX,
      offsetY: posTableData.offsetY,
      accountId: posTableData.accountId,
      ticketId: posTableData.ticketId,
    );
  }
}
