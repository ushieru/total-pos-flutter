import 'package:grpc/grpc.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/grpc/utils/session.dart';
import 'package:total_pos/repositories/drift/account_drift_repository.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class SessionJwt
    implements
        Session<FindAccountByUserAndPasswordResult, ServiceCall, AccountType> {
  SessionJwt({String? secret})
      : _secret = SecretKey(secret ?? 'super secret word');

  final SecretKey _secret;
  final String _issuer = 'Total_POS';

  @override
  String createSession(account) {
    final jwt = JWT(
      {'role': account.accountType},
      subject: account.id,
      issuer: _issuer,
    );
    return jwt.sign(_secret);
  }

  @override
  String? getSession(call) {
    final auth = call.clientMetadata?['authorization'];
    if (auth == null) {
      return null;
    }
    try {
      final jwt = JWT.verify(auth, _secret, issuer: _issuer);
      return jwt.subject;
    } catch (e) {
      return null;
    }
  }

  @override
  bool verifyRole(call, role) {
    final auth = call.clientMetadata?['authorization'];
    if (auth == null) {
      return false;
    }
    try {
      final jwt = JWT.verify(auth, _secret, issuer: _issuer);
      return jwt.payload['role']?.toString().toLowerCase() ==
          role.name.toLowerCase();
    } catch (e) {
      return false;
    }
  }
}
