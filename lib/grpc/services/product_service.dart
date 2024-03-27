import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/repositories/drift/category_drift_repository.dart';
import 'package:total_pos/repositories/drift/product_drift_repository.dart';

class ProductService extends ProductServiceBase {
  ProductService() : super();

  final _categoryRepository = GetIt.I.get<CategoryDriftRepository>();
  final _productRepository = GetIt.I.get<ProductDriftRepository>();

  @override
  Future<Product> createProduct(
      ServiceCall call, CreateProductRequest request) async {
    final product = await _productRepository.createProduct(
        request.name, request.description, request.price);
    return Product(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      createAt: Int64(product.createAt.millisecondsSinceEpoch),
      updateAt: Int64(product.updateAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<Products> readProducts(ServiceCall call, Empty request) async {
    final productsData = await _productRepository.readProducts();
    final products = productsData.map((pd) => Product(
        id: pd.id,
        name: pd.name,
        description: pd.description,
        price: pd.price,
        createAt: Int64(pd.createAt.millisecondsSinceEpoch),
        updateAt: Int64(pd.updateAt.millisecondsSinceEpoch)));
    return Products(products: products);
  }

  @override
  Future<Product> readProductById(
      ServiceCall call, ProductByIdRequest request) async {
    final product = await _productRepository.readProductById(request.id);
    if (product == null) {
      throw const GrpcError.notFound('Producto no encontrado');
    }
    return Product(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      createAt: Int64(product.createAt.millisecondsSinceEpoch),
      updateAt: Int64(product.updateAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<Product> updateProduct(
      ServiceCall call, UpdateProductRequest request) async {
    final productToUpdate =
        await _productRepository.readProductById(request.id);
    if (productToUpdate == null) {
      throw const GrpcError.notFound('Producto no encontrado');
    }
    final product = await _productRepository.updateProduct(
        request.id, request.name, request.description, request.price);
    return Product(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      createAt: Int64(product.createAt.millisecondsSinceEpoch),
      updateAt: Int64(product.updateAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<Product> deleteProductById(
      ServiceCall call, ProductByIdRequest request) async {
    final product = await _productRepository.readProductById(request.id);
    if (product == null) {
      throw const GrpcError.notFound('Producto no encontrado');
    }
    await _productRepository.deleteProductById(product);
    return Product(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      createAt: Int64(product.createAt.millisecondsSinceEpoch),
      updateAt: Int64(product.updateAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<Categories> readCategoriesByProductId(
      ServiceCall call, ProductByIdRequest request) async {
    final categories =
        await _productRepository.getCategoriesByProductId(request.id).get();
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
        await _productRepository.getProductsByCategoryId(request.id).get();
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
  Future<Product> createProductCategoryLink(
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
    return Product(
      id: productToUpdate.id,
      name: productToUpdate.name,
      description: productToUpdate.description,
      price: productToUpdate.price,
      createAt: Int64(productToUpdate.createAt.millisecondsSinceEpoch),
      updateAt: Int64(productToUpdate.updateAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<Product> deleteProductCategoryLink(
      ServiceCall call, RequestCategoryProduct request) async {
    final categoryToDelete =
        await _categoryRepository.readCategoryById(request.categoryId);
    if (categoryToDelete == null) {
      throw const GrpcError.notFound('Categoria no encontrada');
    }
    final productToDelete =
        await _productRepository.readProductById(request.productId);
    if (productToDelete == null) {
      throw const GrpcError.notFound('Product no encontrado');
    }
    await _productRepository.deleteCategoryProductLink(
        request.categoryId, request.productId);
    return Product(
      id: productToDelete.id,
      name: productToDelete.name,
      description: productToDelete.description,
      price: productToDelete.price,
      createAt: Int64(productToDelete.createAt.millisecondsSinceEpoch),
      updateAt: Int64(productToDelete.updateAt.millisecondsSinceEpoch),
    );
  }
}
