import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _textStyle = TextStyle(fontSize: 24, color: Colors.white);

const _padding = EdgeInsets.symmetric(horizontal: 50, vertical: 8);

class SquareButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String text;

  const SquareButton({required this.onPressed, super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      child: Container(
        color: Colors.black,
        padding: _padding,
        child: Align(
          widthFactor: 1,
          child: Text(
            text,
            style: _textStyle,
          ),
        ),
      ),
    );
  }
}
