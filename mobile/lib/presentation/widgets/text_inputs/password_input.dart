import 'package:flutter/material.dart';
import 'package:pace/presentation/widgets/text_inputs/input.dart';

class PasswordInput extends StatefulWidget {
  final void Function(String) onChanged;

  final TextInputAction action;

  final String label;

  final String? exceptionText;

  final VoidCallback? onSubmit;

  const PasswordInput({
    required this.onChanged,
    required this.label,
    this.onSubmit,
    this.action = TextInputAction.done,
    this.exceptionText,
    super.key,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Input(
      labelText: widget.label,
      leadingIconData: Icons.lock_outline_sharp,
      isObscured: _isObscured,
      exceptionText: widget.exceptionText,
      textInputAction: widget.action,
      onSubmit: widget.onSubmit,
      suffix: IconButton(
        onPressed: () => setState(() => _isObscured = !_isObscured),
        icon: Icon(
          _isObscured ? Icons.visibility : Icons.visibility_off,
          color: Colors.black,
          size: 23,
        ),
      ),
    );
  }
}
