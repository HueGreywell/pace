import 'package:formz/formz.dart';
import 'package:pace/core/exceptions/exceptions.dart';

class EmailForm extends FormzInput<String, EmailValidationException> {
  const EmailForm.pure([super.value = '']) : super.pure();

  const EmailForm.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(r'^[\w+.-]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  EmailValidationException? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : const EmailValidationException();
  }
}
