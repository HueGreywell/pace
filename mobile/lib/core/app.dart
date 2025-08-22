import 'package:flutter/material.dart';
import 'package:pace/core/l10n/app_localizations.dart';
import 'package:pace/core/router/router.dart';
import 'package:pace/presentation/res/theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final router = AppRouter.router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: [const Locale('en')],
      routerConfig: router,
    );
  }
}
