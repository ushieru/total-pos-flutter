import 'package:grpc/grpc.dart';
import 'package:total_pos/generated/protos/main.pb.dart';

class Session {
  Session(this.token, this.account);
  String token;
  AccountResponse account;
}

class SessionSingleton extends Session {
  static SessionSingleton? _session;

  SessionSingleton._(super.token, super.account);

  factory SessionSingleton() {
    return _session ??= SessionSingleton._('token', AccountResponse());
  }
}

Future<void> _authenticateGrpc(Map<String, String> metadata, String uri) async {
  metadata['authorization'] = SessionSingleton().token;
}

class AuthGrpcClientInterceptor implements ClientInterceptor {
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
      ClientMethod<Q, R> method, Q request, CallOptions options, invoker) {
    return invoker(method, request,
        options.mergedWith(CallOptions(providers: [_authenticateGrpc])));
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
      ClientMethod<Q, R> method,
      Stream<Q> requests,
      CallOptions options,
      ClientStreamingInvoker<Q, R> invoker) {
    return invoker(method, requests,
        options.mergedWith(CallOptions(providers: [_authenticateGrpc])));
  }
}