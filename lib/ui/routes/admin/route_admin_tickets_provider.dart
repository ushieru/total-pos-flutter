import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/grpc/client.dart';

class RouteAdminTicketsNofitier extends Notifier<List<Ticket>> {
  RouteAdminTicketsNofitier() {
    getTickets();
  }

  @override
  build() => [];

  final _grpcClient = GrpcClientSingleton();

  void getTickets() {
    _grpcClient.ticketClient
        .readTickets(ReadTicketsRequest(
            criteria: Criteria(filters: [
          Filter(
              field_1: 'ticket_status',
              operator: FilterOperator.EQUAL,
              value: 'PAID')
        ])))
        .then((response) => state = response.tickets);
  }
}

final routeAdminTicketsProvider =
    NotifierProvider<RouteAdminTicketsNofitier, List<Ticket>>(
        RouteAdminTicketsNofitier.new);
