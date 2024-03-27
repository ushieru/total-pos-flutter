import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:total_pos/grpc/interceptors/base_interceptor.dart';
import 'package:total_pos/grpc/utils/session.dart';

class AuthInterceptor extends BaseInterceptor {
  AuthInterceptor({super.onlyMethods, super.skipMethods});

  final _sessionController = GetIt.I.get<Session>();

  @override
  FutureOr<GrpcError?> intercep(ServiceCall call, ServiceMethod method) {
    final session = _sessionController.getSession(call);
    if (session == null) {
      return const GrpcError.unauthenticated('unauthenticated');
    }
    return null;
  }
}
