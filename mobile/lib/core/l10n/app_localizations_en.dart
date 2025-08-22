// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get registerHere => 'Register here';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get email => 'Email';

  @override
  String get invalidEmail => 'Please enter a valid email address.';

  @override
  String get passwordIsTooShort => 'Password must be 6 characters.';
}
