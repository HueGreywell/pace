import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final void Function(String) onChanged;

  final TextInputAction action;

  const PasswordInput({
    required this.onChanged,
    this.action = TextInputAction.done,
    super.key,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      obscureText: !_isPasswordVisible,
      textInputAction: widget.action,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline_sharp),
        border: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          tooltip: _isPasswordVisible ? 'Hide password' : 'Show password',
        ),
      ),
    );
  }
}
