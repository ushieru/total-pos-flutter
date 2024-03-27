import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:get_it/get_it.dart';
import 'package:total_pos/grpc/interceptors/auth_interceptor.dart';
import 'package:total_pos/grpc/services/account_service.dart';
import 'package:total_pos/grpc/services/product_service.dart';
import 'package:total_pos/grpc/services/tables_service.dart';
import 'package:total_pos/grpc/services/ticket_service.dart';
import 'package:total_pos/grpc/utils/jwt_session.dart';
import 'package:total_pos/grpc/utils/session.dart';
import 'package:total_pos/repositories/drift/account_drift_repository.dart';
import 'package:total_pos/repositories/drift/category_drift_repository.dart';
import 'package:total_pos/repositories/drift/drift_repository.dart';
import 'package:total_pos/grpc/services/auth_service.dart';
import 'package:total_pos/grpc/services/category_service.dart';
import 'package:total_pos/repositories/drift/product_drift_repository.dart';
import 'package:total_pos/repositories/drift/table_drift_repository.dart';
import 'package:total_pos/repositories/drift/ticket_drift_repository.dart';

class GrpcServer {
  Server? server;

  Future<void> main() async {
    bootstrap();
    server ??= Server.create(
      services: [
        AuthService(),
        AccountService(),
        CategoryService(),
        ProductService(),
        TicketService(),
        TableService(),
      ],
      interceptors: [
        AuthInterceptor(skipMethods: ['Login']).interceptor
      ],
    );
    await server!.serve(port: 8080);
    print('Server listening on port ${server!.port}...');
  }

  Future<void> stop() async {
    if (server == null) return;
    await server!.shutdown();
    print('Shutdown server');
  }

  void bootstrap() {
    final getIt = GetIt.I;
    getIt.registerSingleton<DritfRepository>(DritfRepository());
    getIt.registerSingleton<Session>(SessionJwt());
    getIt.registerSingleton<CategoryDriftRepository>(
        CategoryDriftRepository(getIt.get<DritfRepository>()));
    getIt.registerSingleton<AccountDriftRepository>(
        AccountDriftRepository(getIt.get<DritfRepository>()));
    getIt.registerSingleton<ProductDriftRepository>(
        ProductDriftRepository(getIt.get<DritfRepository>()));
    getIt.registerSingleton<TicketDriftRepository>(
        TicketDriftRepository(getIt.get<DritfRepository>()));
    getIt.registerSingleton<TableDriftRepository>(
        TableDriftRepository(getIt.get<DritfRepository>()));
  }
}
