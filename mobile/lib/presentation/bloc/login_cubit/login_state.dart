part of 'login_cubit.dart';

enum LoginStatus { initial, loading, loaded, failure }

class LoginState extends Equatable with FormzMixin {
  final LoginStatus status;

  final EmailForm email;

  final PasswordForm password;

  const LoginState({
    this.status = LoginStatus.initial,
    this.password = const PasswordForm.pure(),
    this.email = const EmailForm.pure(),
  });

  @override
  List<Object?> get props => [status, email, password];

  @override
  List<FormzInput> get inputs => [email, password];

  LoginState copyWith({
    LoginStatus? status,
    EmailForm? email,
    PasswordForm? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
