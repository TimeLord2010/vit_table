import 'package:flutter/widgets.dart';

class VitTableColumn {
  final String title;

  /// The width of the column.
  ///
  /// If [expandable] is set to `true`, the this property is treated as minimum
  /// width.
  final double width;

  /// Indicates that the column can be expanded if there are extra horizontal
  /// space.
  ///
  /// Has no effect if VitTable.enableHorizontalScroll is set to true.
  final bool expandable;

  final EdgeInsets cellsPadding;

  /// Used to hide columns.
  ///
  /// If there is not enough space, the column with the greatest priority
  /// will vanish first.
  ///
  /// Has no effect if VitTable.enableHorizontalScroll is set to true.
  final int priority;

  final void Function(bool asc)? onSort;

  VitTableColumn({
    required this.title,
    this.onSort,
    this.width = 150,
    this.expandable = false,
    this.priority = 1,
    this.cellsPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  }) {
    assert(width.isFinite);
  }
}
