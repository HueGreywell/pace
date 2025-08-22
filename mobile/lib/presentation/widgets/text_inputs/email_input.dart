import 'package:flutter/material.dart';
import 'package:pace/core/l10n/l10n_extension.dart';
import 'package:pace/presentation/widgets/text_inputs/input.dart';

class EmailInput extends StatelessWidget {
  final void Function(String) onChanged;

  const EmailInput({
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Input(
      leadingIconData: Icons.email_outlined,
      onChanged: onChanged,
      labelText: context.l10n.email,
    );
  }
}
