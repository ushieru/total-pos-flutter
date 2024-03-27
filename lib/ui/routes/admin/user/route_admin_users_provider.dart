import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/grpc/client.dart';

class RouteAdminUsersNofitier extends Notifier<List<AccountResponse>> {
  @override
  build() {
    getAccounts();
    return [];
  }

  final _grpcClient = GrpcClientSingleton();

  void getAccounts() {
    _grpcClient.accountClient
        .readAccounts(Empty())
        .then((accountsResponse) => state = accountsResponse.accounts);
  }

  void createUser(String name, String email, String username, String password,
      AccountType accountType, bool isActive) {
    _grpcClient.accountClient
        .createAccount(CreateAccountRequest(
            name: name,
            email: email,
            username: username,
            password: password,
            accountType: accountType,
            isActive: isActive))
        .then((_) => getAccounts());
  }

  void deleteUser(String userId) {
    _grpcClient.accountClient
        .deleteAccountById(AccountByIdRequest(id: userId))
        .then((_) => getAccounts());
  }
}

final routeAdminUsersProvider =
    NotifierProvider<RouteAdminUsersNofitier, List<AccountResponse>>(
        RouteAdminUsersNofitier.new);
