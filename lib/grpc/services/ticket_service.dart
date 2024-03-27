import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:get_it/get_it.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/grpc/utils/mappers/drift_grcp_mappers/criteria_mapper.dart';
import 'package:total_pos/grpc/utils/session.dart';
import 'package:total_pos/repositories/drift/product_drift_repository.dart';
import 'package:total_pos/repositories/drift/table_drift_repository.dart';
import 'package:total_pos/repositories/drift/ticket_drift_repository.dart';

class TicketService extends TicketServiceBase {
  TicketService() : super();

  final _ticketRepository = GetIt.I.get<TicketDriftRepository>();
  final _productRepository = GetIt.I.get<ProductDriftRepository>();
  final _tableRepository = GetIt.I.get<TableDriftRepository>();
  final _sessionController = GetIt.I.get<Session>();

  @override
  Future<Ticket> createTicket(ServiceCall call, Empty request) async {
    final accountId = _sessionController.getSession(call);
    final ticket = await _ticketRepository.createTicket(accountId!);
    return Ticket(
      id: ticket.id,
      accountId: ticket.accountId,
      products: [],
      ticketStatus: TicketStatus.values.firstWhere(
          (tickerStatus) => tickerStatus.name == ticket.ticketStatus),
      total: ticket.total,
      createAt: Int64(ticket.createdAt.millisecondsSinceEpoch),
      updateAt: Int64(ticket.updatedAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<Tickets> readTickets(
      ServiceCall call, ReadTicketsRequest request) async {
    final response = await _ticketRepository
        .readTickets(criteriaToRepositoryCriteria(request.criteria));
    final tickets = <Ticket>[];
    await Future.forEach(
        response,
        (ticket) async => tickets.add(Ticket(
              id: ticket.id,
              accountId: ticket.accountId,
              products: await _ticketRepository
                  .readTicketProductsByTicketId(ticket.id)
                  .then((products) => products.map((products) => TicketProduct(
                        productId: products.productId,
                        ticketId: products.ticketId,
                        name: products.name,
                        description: products.description,
                        price: products.price,
                        quantity: products.quantity,
                      ))),
              ticketStatus: TicketStatus.values.firstWhere(
                  (tickerStatus) => tickerStatus.name == ticket.ticketStatus),
              total: ticket.total,
              createAt: Int64(ticket.createdAt.millisecondsSinceEpoch),
              updateAt: Int64(ticket.updatedAt.millisecondsSinceEpoch),
            )));
    return Tickets(tickets: tickets);
  }

  @override
  Future<Ticket> readTicketById(
      ServiceCall call, TicketByIdRequest request) async {
    final ticket = await _ticketRepository.readTicketById(request.id);
    if (ticket == null) {
      throw const GrpcError.notFound('Ticket no encontrado');
    }
    final products =
        await _ticketRepository.readTicketProductsByTicketId(ticket.id);
    return Ticket(
      id: ticket.id,
      accountId: ticket.accountId,
      products: products.map((products) => TicketProduct(
            productId: products.productId,
            ticketId: products.ticketId,
            name: products.name,
            description: products.description,
            price: products.price,
            quantity: products.quantity,
          )),
      ticketStatus: TicketStatus.values.firstWhere(
          (tickerStatus) => tickerStatus.name == ticket.ticketStatus),
      total: ticket.total,
      createAt: Int64(ticket.createdAt.millisecondsSinceEpoch),
      updateAt: Int64(ticket.updatedAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<Ticket> addProduct(
      ServiceCall call, AddRemoveTicketProductRequest request) async {
    final product = await _productRepository.readProductById(request.productId);
    if (product == null) {
      throw const GrpcError.notFound('Product no encontrado');
    }
    final ticket = await _ticketRepository.readTicketById(request.ticketId);
    if (ticket == null) {
      throw const GrpcError.notFound('Ticket no encontrado');
    }
    final accountId = _sessionController.getSession(call);
    if (accountId != ticket.accountId) {
      throw const GrpcError.permissionDenied('Este ticket no es tuyo');
    }
    await _ticketRepository.addProduct(ticket.id, product);
    final products =
        await _ticketRepository.readTicketProductsByTicketId(ticket.id);
    final updatedTicket =
        await _ticketRepository.readTicketById(request.ticketId);
    return Ticket(
      id: ticket.id,
      accountId: ticket.accountId,
      products: products.map((products) => TicketProduct(
            productId: products.productId,
            ticketId: products.ticketId,
            name: products.name,
            description: products.description,
            price: products.price,
            quantity: products.quantity,
          )),
      ticketStatus: TicketStatus.values.firstWhere(
          (tickerStatus) => tickerStatus.name == ticket.ticketStatus),
      total: updatedTicket!.total,
      createAt: Int64(ticket.createdAt.millisecondsSinceEpoch),
      updateAt: Int64(updatedTicket.updatedAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<Ticket> deleteProduct(
      ServiceCall call, AddRemoveTicketProductRequest request) async {
    final product = await _productRepository.readProductById(request.productId);
    if (product == null) {
      throw const GrpcError.notFound('Product no encontrado');
    }
    final ticket = await _ticketRepository.readTicketById(request.ticketId);
    if (ticket == null) {
      throw const GrpcError.notFound('Ticket no encontrado');
    }
    final accountId = _sessionController.getSession(call);
    if (accountId != ticket.accountId) {
      throw const GrpcError.permissionDenied('Este ticket no es tuyo');
    }
    await _ticketRepository.deleteProduct(ticket.id, product.id);
    final products =
        await _ticketRepository.readTicketProductsByTicketId(ticket.id);
    final updatedTicket =
        await _ticketRepository.readTicketById(request.ticketId);
    return Ticket(
      id: ticket.id,
      accountId: ticket.accountId,
      products: products.map((products) => TicketProduct(
            productId: products.productId,
            ticketId: products.ticketId,
            name: products.name,
            description: products.description,
            price: products.price,
            quantity: products.quantity,
          )),
      ticketStatus: TicketStatus.values.firstWhere(
          (tickerStatus) => tickerStatus.name == ticket.ticketStatus),
      total: updatedTicket!.total,
      createAt: Int64(ticket.createdAt.millisecondsSinceEpoch),
      updateAt: Int64(updatedTicket.updatedAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<Ticket> payTicket(ServiceCall call, TicketByIdRequest request) async {
    final ticket = await _ticketRepository.readTicketById(request.id);
    if (ticket == null) {
      throw const GrpcError.notFound('Ticket no encontrado');
    }
    final accountId = _sessionController.getSession(call);
    if (accountId != ticket.accountId) {
      throw const GrpcError.permissionDenied('Este ticket no es tuyo');
    }
    final ticketPaid = await _ticketRepository.payTicket(ticket);
    final products =
        await _ticketRepository.readTicketProductsByTicketId(ticket.id);
    if (products.isEmpty) {
      throw const GrpcError.permissionDenied('El ticket no contiene productos');
    }
    await _tableRepository.emptyTableByAccountIdAndTicketId(
        accountId, ticket.id);
    return Ticket(
      id: ticketPaid.id,
      accountId: ticketPaid.accountId,
      products: products.map((products) => TicketProduct(
            productId: products.productId,
            ticketId: products.ticketId,
            name: products.name,
            description: products.description,
            price: products.price,
            quantity: products.quantity,
          )),
      ticketStatus: TicketStatus.values.firstWhere(
          (tickerStatus) => tickerStatus.name == ticketPaid.ticketStatus),
      total: ticketPaid.total,
      createAt: Int64(ticketPaid.createdAt.millisecondsSinceEpoch),
      updateAt: Int64(ticketPaid.updatedAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<Ticket> cancelTicketById(
      ServiceCall call, TicketByIdRequest request) async {
    final ticket = await _ticketRepository.readTicketById(request.id);
    if (ticket == null) {
      throw const GrpcError.notFound('Ticket no encontrado');
    }
    final accountId = _sessionController.getSession(call);
    if (accountId != ticket.accountId) {
      throw const GrpcError.permissionDenied('Este ticket no es tuyo');
    }
    final products =
        await _ticketRepository.readTicketProductsByTicketId(ticket.id);
    if (products.isNotEmpty) {
      throw const GrpcError.permissionDenied('El ticket contiene productos');
    }
    final ticketCanceled = await _ticketRepository.cancelTicketById(ticket);
    await _tableRepository.emptyTableByAccountIdAndTicketId(
        accountId, ticket.id);
    return Ticket(
      id: ticketCanceled.id,
      accountId: ticketCanceled.accountId,
      products: [],
      ticketStatus: TicketStatus.values.firstWhere(
          (tickerStatus) => tickerStatus.name == ticketCanceled.ticketStatus),
      total: ticketCanceled.total,
      createAt: Int64(ticketCanceled.createdAt.millisecondsSinceEpoch),
      updateAt: Int64(ticketCanceled.updatedAt.millisecondsSinceEpoch),
    );
  }
}
