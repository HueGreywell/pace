import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pace/presentation/widgets/buttons/square_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _View();
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SquareButton(
          onPressed: context.pop,
          text: 'test',
        ),
      ),
    );
  }
}
