import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final TextEditingController? textEditingController;

  final ValueChanged<String>? onChanged;

  final String? labelText;

  final String? hintText;

  final IconData leadingIconData;

  final Widget? suffix;

  final TextInputType textInputType;

  final bool isObscured;

  final TextInputAction textInputAction;

  final String? exceptionText;

  final VoidCallback? onSubmit;

  Input({
    this.suffix,
    this.textEditingController,
    this.onSubmit,
    this.onChanged,
    this.labelText,
    this.hintText,
    required this.leadingIconData,
    this.textInputType = TextInputType.text,
    this.isObscured = false,
    this.textInputAction = TextInputAction.next,
    this.exceptionText,
    super.key,
  }) {
    assert(
      textInputAction != TextInputAction.done || onSubmit != null,
      'If widget uses TextInputAction.done onSubmit can\'t be null',
    );
  }

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final _focusNode = FocusNode();

  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      keyboardType: widget.textInputType,
      obscureText: widget.isObscured,
      onFieldSubmitted: (_) => widget.onSubmit?.call(),
      textInputAction: widget.textInputAction,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        errorText: widget.exceptionText,
        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        hintText: hasFocus ? null : widget.labelText,
        prefixIcon: Icon(widget.leadingIconData, size: 23),
        suffixIcon: widget.suffix,
        border: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
      ),
    );
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus == hasFocus) return;
    setState(() => hasFocus = _focusNode.hasFocus);
  }
}
