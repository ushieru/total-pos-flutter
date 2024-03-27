import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:total_pos/repositories/drift/drift_repository_seed.dart';

part 'drift_repository.g.dart';

@DriftDatabase(include: {
  'src/user.drift',
  'src/account.drift',
  'src/category.drift',
  'src/product.drift',
  'src/category_product.drift',
  'src/ticket.drift',
  'src/ticket_product.drift',
  'src/table.drift',
})
class DritfRepository extends _$DritfRepository {
  DritfRepository({String? dbName}) : super(_openConnection(dbName));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(beforeOpen: (details) async {
      if (details.wasCreated) await runSeed();
    });
  }
}

LazyDatabase _openConnection(String? dbName) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, dbName ?? 'post-database.sqlite'));
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
