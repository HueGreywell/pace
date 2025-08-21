import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController? textEditingController;

  final ValueChanged<String>? onChanged;

  final String? Function(String?)? validator;

  final String? labelText;

  final String? hintText;

  final IconData leadingIconData;

  final TextInputType textInputType;

  final bool isObscured;

  final FocusNode? focusNode;

  final TextInputAction textInputAction;

  const Input({
    this.textEditingController,
    this.onChanged,
    this.validator,
    this.labelText,
    this.hintText,
    required this.leadingIconData,
    this.textInputType = TextInputType.text,
    this.isObscured = false,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      focusNode: focusNode,
      keyboardType: textInputType,
      obscureText: isObscured,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(leadingIconData),
        border: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
