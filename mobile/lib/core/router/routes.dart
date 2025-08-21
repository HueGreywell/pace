import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pace/presentation/pages/landing_page.dart';
import 'package:pace/presentation/pages/login_page.dart';
import 'package:pace/presentation/pages/register_page.dart';

part 'routes.g.dart';

@TypedGoRoute<LandingRoute>(path: '/')
class LandingRoute extends GoRouteData with _$LandingRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LandingPage();
  }
}

@TypedGoRoute<RegisterRoute>(path: '/register')
class RegisterRoute extends GoRouteData with _$RegisterRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RegisterPage();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with _$LoginRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}
