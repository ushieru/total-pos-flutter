import 'package:drift/drift.dart';
import 'package:nanoid2/nanoid2.dart';
import 'drift_repository.dart';

part 'table_drift_repository.g.dart';

@DriftAccessor(include: {'src/table.drift', 'src/table_queries.drift'})
class TableDriftRepository extends DatabaseAccessor<DritfRepository>
    with _$TableDriftRepositoryMixin {
  TableDriftRepository(super.attachedDatabase);

  Future<PosTableData> createTable(String name) async {
    final table = await (into(posTable).insertReturning(PosTableCompanion(
      id: Value(nanoid()),
      name: Value(name),
      offsetX: const Value(0),
      offsetY: const Value(0),
    )));
    return table;
  }

  Future<List<PosTableData>> readTables() async {
    return await (select(posTable)).get();
  }

  Future<PosTableData?> readTableById(String id) async {
    return await (select(posTable)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<PosTableData> updateTable(String id, String name) async {
    final table = await (update(posTable)..where((tbl) => tbl.id.equals(id)))
        .writeReturning(PosTableCompanion(name: Value(name)));
    return table[0];
  }

  Future<PosTableData> updateOffset(String id, int offsetX, int offsetY) async {
    final table = await (update(posTable)..where((tbl) => tbl.id.equals(id)))
        .writeReturning(PosTableCompanion(
            offsetX: Value(offsetX), offsetY: Value(offsetY)));
    return table[0];
  }

  Future<PosTableData> openTable(
      String id, String accountId, String ticketId) async {
    final table = await (update(posTable)..where((tbl) => tbl.id.equals(id)))
        .writeReturning(PosTableCompanion(
            accountId: Value(accountId), ticketId: Value(ticketId)));
    return table[0];
  }

  Future<PosTableData> deleteTable(PosTableData posTableData) async {
    await (delete(posTable)..where((tbl) => tbl.id.equals(posTableData.id)))
        .go();
    return posTableData;
  }
}
