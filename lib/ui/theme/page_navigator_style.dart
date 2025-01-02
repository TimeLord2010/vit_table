import 'dart:ui';

class PageNavigatorStyle {
  const PageNavigatorStyle({
    this.selectedColor,
    this.color,
    this.itemSize,
  });

  /// The color used in the selected page button.
  final Color? selectedColor;

  /// The color used in the unselected page button.
  final Color? color;

  final double? itemSize;
}
