import 'package:flutter/widgets.dart';
import 'package:vit_table/ui/protocols/is_mobile.dart';

class MouseHoverListener extends StatefulWidget {
  const MouseHoverListener({
    super.key,
    required this.builder,
    this.child,
    this.cursor,
    this.enabled = true,
  });

  final Widget Function(bool isMouseOver, Widget? child) builder;
  final Widget? child;
  final MouseCursor? cursor;
  final bool enabled;

  @override
  State<StatefulWidget> createState() {
    return _MouseHoverListenerState();
  }
}

class _MouseHoverListenerState extends State<MouseHoverListener> {
  bool _isMouseOver = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || isMobile()) {
      return widget.builder(true, widget.child);
    }
    return MouseRegion(
      cursor: widget.cursor ?? SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isMouseOver = true),
      onExit: (_) => setState(() => _isMouseOver = false),
      child: widget.builder(_isMouseOver, widget.child),
    );
  }
}
