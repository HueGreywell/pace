import 'package:flutter/material.dart';
import 'package:pace/core/router/routes.dart';
import 'package:pace/presentation/widgets/buttons/square_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SquareButton(
          onPressed: () => LoginRoute().push(context),
          text: 'test',
        ),
      ),
    );
  }
}
