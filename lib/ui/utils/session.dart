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
