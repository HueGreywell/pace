import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pace/presentation/widgets/buttons/cupertino_btn.dart';

const _textStyle = TextStyle(fontSize: 24, color: Colors.white);

const _padding = EdgeInsets.symmetric(horizontal: 50, vertical: 8);

class SquareButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String text;

  const SquareButton({required this.onPressed, super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CupertinoBtn(
      onPressed: onPressed,
      child: Container(
        padding: _padding,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
        child: Align(
          child: Text(
            text,
            style: _textStyle,
          ),
        ),
      ),
    );
  }
}
