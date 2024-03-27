import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/grpc/client.dart';

class RouteAdminCateogiresNofitier extends Notifier<List<Category>> {
  RouteAdminCateogiresNofitier() {
    getCategories();
  }

  @override
  build() => [];

  final _grpcClient = GrpcClientSingleton();

  void getCategories() {
    _grpcClient.categoryClient
        .readCategories(Empty())
        .then((categoriesResponse) => state = categoriesResponse.categories);
  }

  void createCategory(String name) {
    _grpcClient.categoryClient
        .createCategory(CreateCategoryRequest(name: name))
        .then((_) => getCategories());
  }

  void deleteCategory(String id) {
    _grpcClient.categoryClient
        .deleteCategoryById(CategoryByIdRequest(id: id))
        .then((_) => getCategories());
  }
}

final routeAdminCateogiresProvider =
    NotifierProvider<RouteAdminCateogiresNofitier, List<Category>>(
        RouteAdminCateogiresNofitier.new);
