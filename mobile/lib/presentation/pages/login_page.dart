import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pace/core/router/routes.dart';
import 'package:pace/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:pace/presentation/widgets/buttons/square_button.dart';
import 'package:pace/presentation/widgets/buttons/text_cta.dart';
import 'package:pace/presentation/widgets/text_inputs/email_input.dart';
import 'package:pace/presentation/widgets/text_inputs/password_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('SIGN IN', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
              const SizedBox(height: 40),
              const EmailInput(),
              const SizedBox(height: 24),
              PasswordInput(
                onChanged: (s) {},
              ),
              const SizedBox(height: 24),
              TextCTA(
                question: 'Don\'t have an account?',
                text: 'Register here',
                onPressed: () => RegisterRoute().push(context),
              ),
              const SizedBox(height: 50),
              SquareButton(onPressed: () {}, text: 'login'),
            ],
          ),
        ),
      ),
    );
  }
}
