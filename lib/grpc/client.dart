import 'package:grpc/grpc.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/grpc/interceptors/client/auth_interceptor.dart';

class GrpcClientSingleton {
  GrpcClientSingleton._(
    this.client,
    this.authClient,
    this.categoryClient,
    this.accountClient,
    this.productClient,
    this.ticketClient,
    this.tableClient,
  );

  factory GrpcClientSingleton({
    String? host,
    int? port,
  }) {
    final client = ClientChannel(
      host ?? 'localhost',
      port: port ?? 8080,
      options: ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        codecRegistry: CodecRegistry(codecs: const [
          GzipCodec(),
          IdentityCodec(),
        ]),
      ),
    );
    final authGrpcInterceptor = AuthGrpcClientInterceptor();
    return _grpcClientSingleton ??= GrpcClientSingleton._(
      client,
      AuthServiceClient(client),
      CategoryServiceClient(client, interceptors: [authGrpcInterceptor]),
      AccountServiceClient(client, interceptors: [authGrpcInterceptor]),
      ProductServiceClient(client, interceptors: [authGrpcInterceptor]),
      TicketServiceClient(client, interceptors: [authGrpcInterceptor]),
      TableServiceClient(client, interceptors: [authGrpcInterceptor]),
    );
  }

  static GrpcClientSingleton? _grpcClientSingleton;

  final ClientChannel client;
  final CategoryServiceClient categoryClient;
  final AuthServiceClient authClient;
  final AccountServiceClient accountClient;
  final ProductServiceClient productClient;
  final TicketServiceClient ticketClient;
  final TableServiceClient tableClient;
}
