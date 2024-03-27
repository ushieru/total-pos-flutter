import 'package:drift/drift.dart';
import 'package:total_pos/grpc/utils/crypt.dart';
import 'package:nanoid2/nanoid2.dart';
import 'drift_repository.dart';

part 'account_drift_repository.g.dart';

@DriftAccessor(include: {
  'src/user.drift',
  'src/account.drift',
  'src/account_queries.drift'
})
class AccountDriftRepository extends DatabaseAccessor<DritfRepository>
    with _$AccountDriftRepositoryMixin {
  AccountDriftRepository(super.attachedDatabase);

  Future<(UserData, AccountData)> createAccount(
      String name,
      String email,
      String username,
      String password,
      String accountType,
      bool isActive) async {
    final user = await into(this.user).insertReturning(UserCompanion(
      id: Value(nanoid()),
      name: Value(name),
      email: Value(email),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
    final account = await into(this.account).insertReturning(AccountCompanion(
      id: Value(nanoid()),
      username: Value(username),
      password: Value(Crypt.encrypt(password)),
      accountType: Value(accountType),
      isActive: Value(isActive ? 1 : 0),
      userId: Value(user.id),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
    return (user, account);
  }

  Future<Iterable<GetAccountsWithUserResult>> readAccounts() async {
    return await (getAccountsWithUser()).get();
  }

  Future<GetAccountWithUserByAccountIdResult?> readAccountById(
      String id) async {
    return await getAccountWithUserByAccountId(id).getSingleOrNull();
  }

  Future<GetAccountWithUserByAccountIdResult> deleteAccountById(
      GetAccountWithUserByAccountIdResult account) async {
    await (delete(this.account)..where((tbl) => tbl.id.equals(account.id)))
        .go();
    return account;
  }
}
