import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pace/core/l10n/l10n_extension.dart';
import 'package:pace/core/router/routes.dart';
import 'package:pace/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:pace/presentation/widgets/buttons/square_button.dart';
import 'package:pace/presentation/widgets/buttons/text_cta.dart';
import 'package:pace/presentation/widgets/focus_managed_scaffold.dart';
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
    final l10n = context.l10n;
    final cubit = context.read<LoginCubit>();
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return FocusManagedScaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          l10n.signIn.toUpperCase(),
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 40),
                        EmailInput(
                          onChanged: cubit.onEmailChanged,
                          exceptionText: state.email.displayError?.message(context),
                        ),
                        const SizedBox(height: 24),
                        PasswordInput(
                          label: l10n.password,
                          onChanged: cubit.onPasswordChanged,
                          exceptionText: state.password.displayError?.message(context),
                          onSubmit: cubit.onLogin,
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SquareButton(
                            onPressed: cubit.onLogin,
                            text: l10n.signIn,
                          ),
                          const SizedBox(height: 50),
                          TextCTA(
                            question: l10n.dontHaveAnAccount,
                            text: l10n.registerHere,
                            onPressed: () => RegisterRoute().push(context),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
