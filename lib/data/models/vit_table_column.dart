import 'package:flutter/widgets.dart';

class VitTableColumn {
  final String title;

  /// The width of the column.
  ///
  /// If [expandable] is set to `true`, the this property is treated as minimum
  /// width.
  final double width;

  final bool expandable;
  final EdgeInsets cellsPadding;
  final int priority;

  VitTableColumn({
    required this.title,
    this.width = 150,
    this.expandable = false,
    this.priority = 1,
    this.cellsPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  }) {
    assert(width.isFinite);
  }
}
