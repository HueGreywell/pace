import 'package:formz/formz.dart';
import 'package:pace/core/exceptions/exceptions.dart';

class PasswordForm extends FormzInput<String, PasswordValidationException> {
  const PasswordForm.pure([super.value = '']) : super.pure();

  const PasswordForm.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationException? validator(String value) {
    return value.length >= 6 ? null : const PasswordValidationException();
  }
}
