import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/grpc/client.dart';
import 'package:total_pos/ui/utils/session.dart';

class RouteCashierTicketsProviderNofifier extends Notifier<List<Ticket>> {
  @override
  build() => [];

  final _grpcClient = GrpcClientSingleton();

  getTickets() {
    _grpcClient.ticketClient
        .readTickets(ReadTicketsRequest(
            criteria: Criteria(filters: [
      Filter(
          field_1: 'account_id',
          operator: FilterOperator.EQUAL,
          value: SessionSingleton().account.id),
      Filter(
          field_1: 'ticket_status',
          operator: FilterOperator.EQUAL,
          value: 'OPEN')
    ])))
        .then((response) {
      state = response.tickets;
    });
  }
}

final routeCashierTicketsProvider =
    NotifierProvider<RouteCashierTicketsProviderNofifier, List<Ticket>>(
        RouteCashierTicketsProviderNofifier.new);
