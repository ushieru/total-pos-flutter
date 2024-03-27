import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:total_pos/repositories/criteria/criteria.dart';
import 'package:nanoid2/nanoid2.dart';
import 'drift_repository.dart';

part 'ticket_drift_repository.g.dart';

@DriftAccessor(include: {'src/ticket.drift', 'src/ticket_product.drift'})
class TicketDriftRepository extends DatabaseAccessor<DritfRepository>
    with _$TicketDriftRepositoryMixin {
  TicketDriftRepository(super.attachedDatabase);

  Future<TicketData> createTicket(String accountId) {
    return into(ticket).insertReturning(TicketCompanion(
      id: Value(nanoid()),
      accountId: Value(accountId),
      ticketStatus: const Value('OPEN'),
      total: const Value(0),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<List<TicketData>> readTickets(Criteria criteria) {
    final buffer = StringBuffer();
    criteria.filters.forEachIndexed((i, filter) {
      if (i != 0) buffer.write(' AND ');
      buffer.write(filter.toString());
    });
    if (buffer.isNotEmpty) {
      return customSelect('SELECT * FROM "ticket" WHERE ${buffer.toString()}',
          variables: criteria.filters.map((f) => Variable(f.value)).toList(),
          readsFrom: {ticket}).asyncMap(ticket.mapFromRow).get();
    }
    return (select(ticket)).get();
  }

  Future<TicketData?> readTicketById(String id) async {
    return (select(ticket)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<TicketProductData>> readTicketProductsByTicketId(String id) {
    return (select(ticketProduct)..where((tbl) => tbl.ticketId.equals(id)))
        .get();
  }

  Future<void> addProduct(String ticketId, ProductData product) async {
    whereFilter(TicketProduct tbl) =>
        tbl.ticketId.equals(ticketId) & tbl.productId.equals(product.id);

    final ticketProduct = await (select(this.ticketProduct)..where(whereFilter))
        .getSingleOrNull();
    if (ticketProduct == null) {
      await into(this.ticketProduct).insert(TicketProductCompanion(
        id: Value(nanoid()),
        ticketId: Value(ticketId),
        productId: Value(product.id),
        name: Value(product.name),
        description: Value(product.description),
        price: Value(product.price),
        quantity: const Value(1),
      ));
      await _calculateTotal(ticketId);
      return;
    }
    await (update(this.ticketProduct)..where(whereFilter)).write(
        TicketProductCompanion(quantity: Value(ticketProduct.quantity + 1)));
    await _calculateTotal(ticketId);
  }

  Future<void> deleteProduct(String ticketId, String productId) async {
    whereFilter(TicketProduct tbl) =>
        tbl.ticketId.equals(ticketId) & tbl.productId.equals(productId);

    final ticketProduct = await (select(this.ticketProduct)..where(whereFilter))
        .getSingleOrNull();
    if (ticketProduct == null) {
      await _calculateTotal(ticketId);
      return;
    }
    if (ticketProduct.quantity == 1) {
      await (delete(this.ticketProduct)..where(whereFilter)).go();
    }
    await (update(this.ticketProduct)..where(whereFilter)).write(
        TicketProductCompanion(quantity: Value(ticketProduct.quantity - 1)));
    await _calculateTotal(ticketId);
  }

  Future<TicketData> payTicket(TicketData ticket) async {
    final ticketResponse = await (update(this.ticket)
          ..where((tbl) => tbl.id.equals(ticket.id)))
        .writeReturning(const TicketCompanion(ticketStatus: Value('PAID')));
    return ticketResponse[0];
  }

  Future<TicketData> cancelTicketById(TicketData ticket) async {
    final ticketResponse = await (update(this.ticket)
          ..where((tbl) => tbl.id.equals(ticket.id)))
        .writeReturning(const TicketCompanion(ticketStatus: Value('CANCEL')));
    return ticketResponse[0];
  }

  Future<void> _calculateTotal(String ticketId) async {
    final products = await (select(ticketProduct)
          ..where((tbl) => tbl.ticketId.equals(ticketId)))
        .get();
    double total = 0;
    for (final product in products) {
      total += product.price * product.quantity;
    }
    await (update(ticket)..where((tbl) => tbl.id.equals(ticketId)))
        .writeReturning(TicketCompanion(total: Value(total)));
  }
}
