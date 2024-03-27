import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/grpc/client.dart';

class RouteAdminProductNofifier extends Notifier<RouteAdminProductUpdateState> {
  @override
  build() {
    getCategories();
    return RouteAdminProductUpdateState([], [], []);
  }

  final _grpcClient = GrpcClientSingleton();

  void _filterCategories() {
    final filterCategories = state.categories
        .where((category) =>
            state.productCategories
                .firstWhereOrNull((pCategory) => pCategory.id == category.id) ==
            null)
        .toList();
    state = state.copyWith(filtercategories: filterCategories);
  }

  Future<void> getCategories() async {
    await _grpcClient.categoryClient.readCategories(Empty()).then(
        (response) => state = state.copyWith(categories: response.categories));
  }

  Future<void> getCategoriesByProductId(String id) async {
    await _grpcClient.categoryClient
        .readCategoriesByProductId(ProductByIdRequest(id: id))
        .then((response) =>
            state = state.copyWith(productCategories: response.categories))
        .then((_) => _filterCategories());
  }

  Future<void> addCategoryToProduct(Product product, String categoryId) async {
    await _grpcClient.productClient
        .createProductCategoryLink(RequestCategoryProduct(
            productId: product.id, categoryId: categoryId))
        .then((_) => getCategoriesByProductId(product.id));
  }

  Future<void> deleteCategoryToProduct(
      Product product, String categoryId) async {
    await _grpcClient.productClient
        .deleteProductCategoryLink(RequestCategoryProduct(
            productId: product.id, categoryId: categoryId))
        .then((_) => getCategoriesByProductId(product.id));
  }

  Future<void> updateProduct(
      Product product, String name, String description, double price) async {
    await _grpcClient.productClient.updateProduct(UpdateProductRequest(
        id: product.id, name: name, description: description, price: price));
  }
}

class RouteAdminProductUpdateState {
  RouteAdminProductUpdateState(
      this.categories, this.productCategories, this.filtercategories);

  final List<Category> categories;
  final List<Category> filtercategories;
  final List<Category> productCategories;

  RouteAdminProductUpdateState copyWith({
    List<Category>? categories,
    List<Category>? productCategories,
    List<Category>? filtercategories,
  }) {
    return RouteAdminProductUpdateState(
        categories ?? this.categories,
        productCategories ?? this.productCategories,
        filtercategories ?? this.filtercategories);
  }
}

final routeAdminProductUpdateProvider =
    NotifierProvider<RouteAdminProductNofifier, RouteAdminProductUpdateState>(
        RouteAdminProductNofifier.new);
