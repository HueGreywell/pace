import 'package:flutter/material.dart';
import 'package:pace/presentation/widgets/text_inputs/input.dart';

class EmailInput extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const EmailInput({
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Input(
      leadingIconData: Icons.email_outlined,
      labelText: 'Email',
    );
  }
}
