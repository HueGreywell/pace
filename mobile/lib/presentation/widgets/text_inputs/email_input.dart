import 'package:flutter/material.dart';
import 'package:pace/core/l10n/l10n_extension.dart';
import 'package:pace/presentation/widgets/text_inputs/input.dart';

class EmailInput extends StatelessWidget {
  final void Function(String) onChanged;

  final String? exceptionText;

  const EmailInput({
    required this.onChanged,
    required this.exceptionText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Input(
      leadingIconData: Icons.email_outlined,
      onChanged: onChanged,
      labelText: context.l10n.email,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.emailAddress,
      exceptionText: exceptionText,
    );
  }
}
