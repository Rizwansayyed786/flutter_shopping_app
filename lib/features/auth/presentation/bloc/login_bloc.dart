import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/usecases/login_user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required LoginUser loginUser})
      : _loginUser = loginUser,
        super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<TogglePasswordVisibility>(
      (event, emit) =>
          emit(state.copyWith(obscurePassword: !state.obscurePassword)),
    );
    on<LoginSubmitted>(_onSubmitted);
  }

  final LoginUser _loginUser;

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final error = Validators.email(event.email);
    emit(state.copyWith(
      email: event.email,
      emailError: error,
      clearEmailError: error == null,
      status: LoginStatus.initial,
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final error = Validators.password(event.password);
    emit(state.copyWith(
      password: event.password,
      passwordError: error,
      clearPasswordError: error == null,
      status: LoginStatus.initial,
    ));
  }

  Future<void> _onSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    if (!state.isValid || state.isSubmitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    final success =
        await _loginUser(email: state.email, password: state.password);
    emit(state.copyWith(
      status: success ? LoginStatus.success : LoginStatus.failure,
      errorMessage: success ? null : 'Invalid email or password',
    ));
  }
}
