import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/repositories/drift/account_drift_repository.dart';

class AccountService extends AccountServiceBase {
  AccountService() : super();

  final _accountRepository = GetIt.I.get<AccountDriftRepository>();

  @override
  Future<AccountResponse> createAccount(
      ServiceCall call, CreateAccountRequest request) async {
    final (user, account) = await _accountRepository.createAccount(
        request.name,
        request.email,
        request.username,
        request.password,
        request.accountType.name,
        request.isActive);
    return AccountResponse(
        id: account.id,
        username: account.username,
        accountType: AccountType.values.firstWhere(
            (element) => element.name == account.accountType,
            orElse: () => AccountType.WAITER),
        isActive: account.isActive == 1,
        userId: user.id,
        user: User(
            id: user.id,
            name: user.name,
            email: user.email,
            createdAt: Int64(user.createdAt.millisecondsSinceEpoch),
            updatedAt: Int64(user.updatedAt.millisecondsSinceEpoch)),
        createdAt: Int64(account.createdAt.millisecondsSinceEpoch),
        updatedAt: Int64(account.updatedAt.millisecondsSinceEpoch));
  }

  @override
  Future<AccountResponse> deleteAccountById(
      ServiceCall call, AccountByIdRequest request) async {
    final account = await _accountRepository.readAccountById(request.id);
    if (account == null) {
      throw const GrpcError.notFound('Cuenta no encontrada');
    }
    await _accountRepository.deleteAccountById(account);
    return AccountResponse(
        id: account.id,
        username: account.username,
        accountType: AccountType.values.firstWhere(
            (element) => element.name == account.accountType,
            orElse: () => AccountType.WAITER),
        isActive: account.isActive == 1,
        userId: account.userId,
        user: User(
            id: account.userId,
            name: account.name,
            email: account.email,
            createdAt: Int64(account.createdAt.millisecondsSinceEpoch),
            updatedAt: Int64(account.updatedAt.millisecondsSinceEpoch)),
        createdAt: Int64(account.createdAt.millisecondsSinceEpoch),
        updatedAt: Int64(account.updatedAt.millisecondsSinceEpoch));
  }

  @override
  Future<Accounts> readAccounts(ServiceCall call, Empty request) async {
    final accountsResponse = await _accountRepository.readAccounts();
    final accounts = accountsResponse.map((account) => AccountResponse(
        id: account.id,
        username: account.username,
        accountType: AccountType.values.firstWhere(
            (element) => element.name == account.accountType,
            orElse: () => AccountType.WAITER),
        isActive: account.isActive == 1,
        userId: account.userId,
        user: User(
            id: account.userId,
            name: account.name,
            email: account.email,
            createdAt: Int64(account.createdAt.millisecondsSinceEpoch),
            updatedAt: Int64(account.updatedAt.millisecondsSinceEpoch)),
        createdAt: Int64(account.createdAt.millisecondsSinceEpoch),
        updatedAt: Int64(account.updatedAt.millisecondsSinceEpoch)));
    return Accounts(accounts: accounts);
  }
}
