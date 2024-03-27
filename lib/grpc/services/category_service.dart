import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:total_pos/repositories/drift/category_drift_repository.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/repositories/drift/product_drift_repository.dart';

class CategoryService extends CategoryServiceBase {
  CategoryService() : super();

  final _categoryRepository = GetIt.I.get<CategoryDriftRepository>();
  final _productRepository = GetIt.I.get<ProductDriftRepository>();

  @override
  Future<Category> createCategory(
      ServiceCall call, CreateCategoryRequest request) async {
    final category = await _categoryRepository.createCategory(request.name);
    return Category(
        id: category.id,
        name: category.name,
        createAt: Int64(category.createAt.millisecondsSinceEpoch),
        updateAt: Int64(category.updateAt.millisecondsSinceEpoch));
  }

  @override
  Future<Categories> readCategories(ServiceCall call, Empty request) async {
    final categoriesData = await _categoryRepository.readCategories();
    final categories = categoriesData.map((category) => Category(
        id: category.id,
        name: category.name,
        createAt: Int64(category.createAt.millisecondsSinceEpoch),
        updateAt: Int64(category.updateAt.millisecondsSinceEpoch)));
    return Categories(categories: categories);
  }

  @override
  Future<Category> readCategoryById(
      ServiceCall call, CategoryByIdRequest request) async {
    final category = await _categoryRepository.readCategoryById(request.id);
    if (category == null) {
      throw const GrpcError.notFound('Categoria no encontrada');
    }
    return Category(
        id: category.id,
        name: category.name,
        createAt: Int64(category.createAt.millisecondsSinceEpoch),
        updateAt: Int64(category.updateAt.millisecondsSinceEpoch));
  }

  @override
  Future<Category> updateCategory(
      ServiceCall call, UpdateCategoryRequest request) async {
    final categoryToUpdate =
        await _categoryRepository.readCategoryById(request.id);
    if (categoryToUpdate == null) {
      throw const GrpcError.notFound('Categoria no encontrada');
    }
    final category =
        await _categoryRepository.updateCategory(request.id, request.name);
    return Category(
        id: category.id,
        name: category.name,
        createAt: Int64(category.createAt.millisecondsSinceEpoch),
        updateAt: Int64(category.updateAt.millisecondsSinceEpoch));
  }

  @override
  Future<Category> deleteCategoryById(
      ServiceCall call, CategoryByIdRequest request) async {
    final categoryToUpdate =
        await _categoryRepository.readCategoryById(request.id);
    if (categoryToUpdate == null) {
      throw const GrpcError.notFound('Categoria no encontrada');
    }
    final category = await _categoryRepository.deleteCategory(request.id);
    return Category(
        id: category.id,
        name: category.name,
        createAt: Int64(category.createAt.millisecondsSinceEpoch),
        updateAt: Int64(category.updateAt.millisecondsSinceEpoch));
  }

  @override
  Future<Categories> readCategoriesByProductId(
      ServiceCall call, ProductByIdRequest request) async {
    final categories =
        await _categoryRepository.getCategoriesByProductId(request.id).get();
    return Categories(
        categories: categories.map((category) => Category(
            id: category.id,
            name: category.name,
            createAt: Int64(category.createAt.millisecondsSinceEpoch),
            updateAt: Int64(category.updateAt.millisecondsSinceEpoch))));
  }

  @override
  Future<Products> readProductsByCategoryId(
      ServiceCall call, CategoryByIdRequest request) async {
    final products =
        await _categoryRepository.getProductsByCategoryId(request.id).get();
    return Products(
        products: products.map((product) => Product(
            id: product.id,
            name: product.name,
            description: product.description,
            price: product.price,
            createAt: Int64(product.createAt.millisecondsSinceEpoch),
            updateAt: Int64(product.updateAt.millisecondsSinceEpoch))));
  }

  @override
  Future<Category> createProductCategoryLink(
      ServiceCall call, RequestCategoryProduct request) async {
    final categoryToUpdate =
        await _categoryRepository.readCategoryById(request.categoryId);
    if (categoryToUpdate == null) {
      throw const GrpcError.notFound('Categoria no encontrada');
    }
    final productToUpdate =
        await _productRepository.readProductById(request.productId);
    if (productToUpdate == null) {
      throw const GrpcError.notFound('Product no encontrado');
    }
    await _categoryRepository.insertCategoryProductLink(
        request.categoryId, request.productId);
    return Category(
      id: categoryToUpdate.id,
      name: categoryToUpdate.name,
      createAt: Int64(categoryToUpdate.createAt.millisecondsSinceEpoch),
      updateAt: Int64(categoryToUpdate.updateAt.millisecondsSinceEpoch),
    );
  }
}
