import 'package:drift/drift.dart';
import 'package:nanoid2/nanoid2.dart';
import 'drift_repository.dart';

part 'category_drift_repository.g.dart';

@DriftAccessor(include: {
  'src/category.drift',
  'src/category_product.drift',
  'src/category_product_queries.drift',
})
class CategoryDriftRepository extends DatabaseAccessor<DritfRepository>
    with _$CategoryDriftRepositoryMixin {
  CategoryDriftRepository(super.attachedDatabase);

  Future<CategoryData> createCategory(String name) async {
    final category =
        await into(this.category).insertReturning(CategoryCompanion(
      id: Value(nanoid()),
      name: Value(name),
      createAt: Value(DateTime.now()),
      updateAt: Value(DateTime.now()),
    ));
    return category;
  }

  Future<Iterable<CategoryData>> readCategories() async {
    return await (select(category)).get();
  }

  Future<CategoryData?> readCategoryById(String id) async {
    return await (select(category)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<CategoryData> updateCategory(String id, String name) async {
    final category = await (update(this.category)
          ..where((tbl) => tbl.id.equals(id)))
        .writeReturning(CategoryCompanion(
            name: Value(name), updateAt: Value(DateTime.now())));
    return category[0];
  }

  Future<CategoryData> deleteCategory(String id) async {
    final categories = await (delete(category)
          ..where((tbl) => tbl.id.equals(id)))
        .goAndReturn();
    return categories[0];
  }
}
