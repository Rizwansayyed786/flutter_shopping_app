abstract class AuthRepository {
  /// Returns `true` when the credentials are valid.
  Future<bool> login({required String email, required String password});
}
