import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/grpc/client.dart';

class OrderMakerProviderNofifier extends Notifier<OrderMakerState> {
  OrderMakerProviderNofifier();

  @override
  build() {
    getCategories();
    return OrderMakerState(null, [], [], null, false);
  }

  final _grpcClient = GrpcClientSingleton();

  loadTicket(String ticketId) {
    _grpcClient.ticketClient
        .readTicketById(TicketByIdRequest(id: ticketId))
        .then((ticket) =>
            state = state.copyWith(ticket: ticket, isLoading: false));
  }

  getCategories() {
    _grpcClient.categoryClient.readCategories(Empty()).then((response) {
      final categories = response.categories;
      if (categories.isNotEmpty) {
        getProductsByCategoryId(categories.first);
      }
      state = state.copyWith(categories: categories);
    });
  }

  getProductsByCategoryId(Category category) {
    state = state.copyWith(currentCategory: category);
    _grpcClient.productClient
        .readProductsByCategoryId(CategoryByIdRequest(id: category.id))
        .then(
            (response) => state = state.copyWith(products: response.products));
  }

  addProcuct(String productId) {
    _grpcClient.ticketClient
        .addProduct(AddRemoveTicketProductRequest(
            ticketId: state.ticket!.id, productId: productId))
        .then((ticket) => state = state.copyWith(ticket: ticket));
  }

  deleteProduct(String productId) {
    _grpcClient.ticketClient
        .deleteProduct(AddRemoveTicketProductRequest(
            ticketId: state.ticket!.id, productId: productId))
        .then((ticket) => state = state.copyWith(ticket: ticket));
  }

  Future<void> cancelOrder() async {
    if (state.ticket == null) return;
    await _grpcClient.ticketClient
        .cancelTicketById(TicketByIdRequest(id: state.ticket!.id));
  }

  Future<void> payOrder() async {
    if (state.ticket == null) return;
    await _grpcClient.ticketClient
        .payTicket(TicketByIdRequest(id: state.ticket!.id));
  }
}

class OrderMakerState {
  OrderMakerState(this.ticket, this.categories, this.products,
      this.currentCategory, this.isLoading);
  final Ticket? ticket;
  final List<Category> categories;
  final Category? currentCategory;
  final List<Product> products;
  final bool isLoading;

  copyWith({
    Ticket? ticket,
    List<Category>? categories,
    List<Product>? products,
    Category? currentCategory,
    bool? isLoading,
  }) {
    return OrderMakerState(
        ticket ?? this.ticket,
        categories ?? this.categories,
        products ?? this.products,
        currentCategory ?? this.currentCategory,
        isLoading ?? this.isLoading);
  }
}

final orderMakerProvider =
    NotifierProvider<OrderMakerProviderNofifier, OrderMakerState>(
        OrderMakerProviderNofifier.new);
