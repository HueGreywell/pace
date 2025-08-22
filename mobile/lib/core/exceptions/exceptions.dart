import 'package:flutter/material.dart';
import 'package:pace/core/l10n/l10n_extension.dart';
import 'package:pace/presentation/forms/password_form.dart';

abstract class AppException {
  final dynamic error;

  final StackTrace? stackTrace;

  const AppException({this.error, this.stackTrace});

  String message(BuildContext context);
}

class EmailValidationException extends AppException {
  const EmailValidationException();

  @override
  String message(BuildContext context) {
    return context.l10n.invalidEmail;
  }
}

class PasswordValidationException extends AppException {
  const PasswordValidationException();

  @override
  String message(BuildContext context) {
    return context.l10n.passwordIsTooShort;
  }
}
