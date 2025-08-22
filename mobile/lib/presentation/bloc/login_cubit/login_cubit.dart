import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pace/presentation/forms/email_form.dart';
import 'package:pace/presentation/forms/password_form.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void onEmailChanged(String value) {
    final email = EmailForm.pure(value);
    emit(state.copyWith(email: email));
  }

  void onPasswordChanged(String value) {
    final password = PasswordForm.pure(value);
    emit(state.copyWith(password: password));
  }

  void onLogin() {
    try {
      if (state.isNotValid) return _emitExceptions();
      emit(state.copyWith(status: LoginStatus.loading));
      //Call api
      emit(state.copyWith(status: LoginStatus.loaded));
    } catch (_) {
      //TODO LOG ERROR
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }

  void _emitExceptions() {
    final email = EmailForm.dirty(state.email.value);
    final password = PasswordForm.dirty(state.password.value);
    emit(state.copyWith(email: email, password: password));
  }
}
