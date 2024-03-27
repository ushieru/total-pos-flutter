import 'package:drift/drift.dart';
import 'package:nanoid2/nanoid2.dart';
import 'drift_repository.dart';

part 'product_drift_repository.g.dart';

@DriftAccessor(include: {
  'src/product.drift',
  'src/category_product.drift',
  'src/category_product_queries.drift',
})
class ProductDriftRepository extends DatabaseAccessor<DritfRepository>
    with _$ProductDriftRepositoryMixin {
  ProductDriftRepository(super.attachedDatabase);

  Future<ProductData> createProduct(
      String name, String description, double price) async {
    final product = await into(this.product).insertReturning(ProductCompanion(
        id: Value(nanoid()),
        name: Value(name),
        description: Value(description),
        price: Value(price),
        createAt: Value(DateTime.now()),
        updateAt: Value(DateTime.now())));
    return product;
  }

  Future<List<ProductData>> readProducts() async {
    return await (select(product)).get();
  }

  Future<ProductData?> readProductById(String id) async {
    return await (select(product)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<ProductData> updateProduct(
      String id, String name, String description, double price) async {
    final product = await (update(this.product)
          ..where((tbl) => tbl.id.equals(id)))
        .writeReturning(ProductCompanion(
            name: Value(name),
            description: Value(description),
            price: Value(price),
            updateAt: Value(DateTime.now())));
    return product[0];
  }

  Future<ProductData> deleteProductById(ProductData product) async {
    await (delete(this.product)..where((tbl) => tbl.id.equals(product.id)))
        .go();
    return product;
  }
}
