import 'package:flutter/material.dart';

class TextCTA extends StatelessWidget {
  final String question;

  final String text;

  final VoidCallback onPressed;

  const TextCTA({
    required this.question,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question),
        const Text(' '),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            text,
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
