import 'package:flutter/widgets.dart';

class VitTableStyle {
  /// The exact height of the table.
  final double? height;

  /// The minimum height of the table.
  final double? minHeight;

  /// The height of the header.
  final double? headerHeight;

  /// The height of each row.
  final double? rowHeight;

  /// The widget to show at the bottom of the table. Shown inside the table.
  final Widget? innerBottom;

  /// Widget to show when the table is empty
  final Widget? onEmptyWidget;

  const VitTableStyle({
    this.height,
    this.minHeight,
    this.headerHeight,
    this.rowHeight,
    this.innerBottom,
    this.onEmptyWidget,
  });
}
