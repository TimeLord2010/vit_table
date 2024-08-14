import 'package:flutter/widgets.dart';

/// If no [height] is given, then this widget becomes a [Expanded] wrapper.
class AdaptativeVExpanded extends StatelessWidget {
  const AdaptativeVExpanded({
    super.key,
    required this.height,
    required this.child,
  });

  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (height != null && height!.isFinite) {
      return SizedBox(
        height: height,
        child: child,
      );
    }
    return Expanded(
      child: child,
    );
  }
}
