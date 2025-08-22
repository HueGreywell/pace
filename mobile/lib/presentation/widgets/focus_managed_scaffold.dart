import 'package:flutter/material.dart';

class FocusManagedScaffold extends StatelessWidget {
  final Widget body;

  const FocusManagedScaffold({
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: body,
      ),
    );
  }
}
