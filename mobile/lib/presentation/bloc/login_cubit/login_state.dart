part of 'login_cubit.dart';

enum LoginStatus { initial, loading, loaded, failure }

class LoginState extends Equatable {
  final LoginStatus status;

  const LoginState({this.status = LoginStatus.initial});

  @override
  List<Object?> get props => [status];
}
