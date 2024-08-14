import 'package:flutter/material.dart';

class VitButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;

  const VitButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onPressed == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: child,
      ),
    );
  }
}
