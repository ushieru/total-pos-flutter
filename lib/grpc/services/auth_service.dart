import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/grpc/utils/session.dart';
import 'package:total_pos/repositories/drift/account_drift_repository.dart';
import 'package:total_pos/grpc/utils/crypt.dart';

class AuthService extends AuthServiceBase {
  AuthService() : super();

  final _authRepository = GetIt.I.get<AccountDriftRepository>();
  final _sessionController = GetIt.I.get<Session>();

  @override
  Future<LoginResponse> login(ServiceCall call, LoginRequest request) async {
    final account = await (_authRepository.findAccountByUserAndPassword(
            request.username, Crypt.encrypt(request.password)))
        .getSingleOrNull();
    if (account == null) {
      throw const GrpcError.notFound('Error en usuario o contraseña');
    }
    if (account.isActive == 0) {
      throw const GrpcError.unavailable(
          'Cuenta deshabilitada contacte al administrador');
    }
    final token = _sessionController.createSession(account);
    return LoginResponse(
        token: token,
        account: AccountResponse(
          id: account.id,
          accountType: AccountType.values.firstWhere(
              (element) => element.name == account.accountType,
              orElse: () => AccountType.WAITER),
        ));
  }
}
