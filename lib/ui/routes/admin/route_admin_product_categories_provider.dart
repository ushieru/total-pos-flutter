import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/grpc/client.dart';

class RouteAdminProductCategoriesNofifier
    extends Notifier<RouteAdminProductCategoriesState> {
  @override
  build() {
    getCategories();
    return RouteAdminProductCategoriesState(Product(), [], [], []);
  }

  final _grpcClient = GrpcClientSingleton();

  Future<void> getProduct(String id) async {
    await _grpcClient.productClient
        .readProductById(ProductByIdRequest(id: id))
        .then((product) => state = state.copyWith(product: product))
        .then((state) => getCategoriesByProductId(state.product.id));
  }

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

  Future<void> addCategoryToProduct(String categoryId) async {
    await _grpcClient.productClient
        .createProductCategoryLink(RequestCategoryProduct(
            productId: state.product.id, categoryId: categoryId))
        .then((_) => getCategoriesByProductId(state.product.id));
  }

  Future<void> deleteCategoryToProduct(String categoryId) async {
    await _grpcClient.productClient
        .deleteProductCategoryLink(RequestCategoryProduct(
            productId: state.product.id, categoryId: categoryId))
        .then((_) => getCategoriesByProductId(state.product.id));
  }
}

class RouteAdminProductCategoriesState {
  RouteAdminProductCategoriesState(this.product, this.categories,
      this.productCategories, this.filtercategories);

  final Product product;
  final List<Category> categories;
  final List<Category> filtercategories;
  final List<Category> productCategories;

  RouteAdminProductCategoriesState copyWith({
    Product? product,
    List<Category>? categories,
    List<Category>? productCategories,
    List<Category>? filtercategories,
  }) {
    return RouteAdminProductCategoriesState(
        product ?? this.product,
        categories ?? this.categories,
        productCategories ?? this.productCategories,
        filtercategories ?? this.filtercategories);
  }
}

final routeAdminProductCategoriesProvider = NotifierProvider<
    RouteAdminProductCategoriesNofifier,
    RouteAdminProductCategoriesState>(RouteAdminProductCategoriesNofifier.new);
