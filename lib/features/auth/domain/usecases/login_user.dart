import '../repositories/auth_repository.dart';

class LoginUser {
  const LoginUser(this._repository);

  final AuthRepository _repository;

  Future<bool> call({required String email, required String password}) {
    return _repository.login(email: email.trim(), password: password);
  }
}
