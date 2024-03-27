import 'dart:async';
import 'package:grpc/grpc.dart';

abstract class BaseInterceptor {
  BaseInterceptor({
    this.skipMethods,
    this.onlyMethods,
  }) : assert(() {
          if (skipMethods != null && onlyMethods != null) return false;
          if (skipMethods == null && onlyMethods == null) return false;
          return true;
        }());

  List<String>? skipMethods;
  List<String>? onlyMethods;

  FutureOr<GrpcError?> _interceptorPre(ServiceCall call, ServiceMethod method) {
    if (skipMethods != null) {
      if (skipMethods!.contains(method.name)) {
        return null;
      }
    }
    if (onlyMethods != null) {
      if (onlyMethods!.contains(method.name)) {
        return intercep(call, method);
      }
      return null;
    }
    return intercep(call, method);
  }

  FutureOr<GrpcError?> intercep(ServiceCall call, ServiceMethod method);

  Interceptor get interceptor =>
      (call, method) async => await _interceptorPre(call, method);
}
