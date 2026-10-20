import '../../../../core/constants/app_constants.dart';

abstract class AuthLocalDataSource {
  Future<bool> verifyCredentials(String email, String password);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<bool> verifyCredentials(String email, String password) async {
    // Simulate a short network delay.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return email.toLowerCase() == AppConstants.dummyEmail &&
        password == AppConstants.dummyPassword;
  }
}
