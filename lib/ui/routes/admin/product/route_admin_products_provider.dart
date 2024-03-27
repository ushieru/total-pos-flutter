import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/grpc/client.dart';
class RouteAdminProductsNofitier extends Notifier<List<Product>> {
  RouteAdminProductsNofitier() {
    getProducts();
  }

  @override
  build() => [];

  final _grpcClient = GrpcClientSingleton();

  void getProducts() {
    _grpcClient.productClient
        .readProducts(Empty())
        .then((response) => state = response.products);
  }

  void createProduct(String name, String description, double price) {
    _grpcClient.productClient
        .createProduct(CreateProductRequest(
            name: name, description: description, price: price))
        .then((_) => getProducts());
  }

  void deleteProduct(Product product) {
    _grpcClient.productClient
        .deleteProductById(ProductByIdRequest(id: product.id))
        .then((_) => getProducts());
  }
}

final routeAdminProductsProvider =
    NotifierProvider<RouteAdminProductsNofitier, List<Product>>(
        RouteAdminProductsNofitier.new);
