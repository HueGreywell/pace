import 'package:flutter/cupertino.dart';

class CupertinoBtn extends StatelessWidget {
  final Widget child;

  final VoidCallback onPressed;

  const CupertinoBtn({
    required this.child,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed: () {
        FocusScope.of(context).unfocus();
        onPressed();
      },
      child: child,
    );
  }
}
