abstract class Session<T, U, V> {
  String createSession(T account);
  String? getSession(U object);
  bool verifyRole(U object, V role);
}
