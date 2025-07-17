import 'package:flutter/widgets.dart';
import 'package:vit_table/ui/theme/header_style.dart';
import 'package:vit_table/ui/theme/row_style.dart';

import 'page_navigator_theme.dart';

class VitTableStyle {
  /// The exact height of the table.
  final double? height;

  /// The minimum height of the table.
  final double? minHeight;

  final Decoration? decoration;

  /// The widget to show at the bottom of the table. Shown inside the table.
  final Widget? innerBottom;

  /// Widget to show when the table is empty
  final Widget? onEmptyWidget;

  final PageNavigatorThemeData pageNavigatorThemeData;

  final RowStyle? row;

  final HeaderStyle? header;

  final RawScrollbar Function(
    ScrollController? controller,
    Widget child,
  )? scrollbarBuilder;

  const VitTableStyle({
    this.height,
    this.minHeight,
    this.header,
    this.row,
    this.innerBottom,
    this.onEmptyWidget,
    this.scrollbarBuilder,
    this.decoration,
    PageNavigatorThemeData? pageNavigatorThemeData,
  }) : pageNavigatorThemeData =
            pageNavigatorThemeData ?? const PageNavigatorThemeData();

  /// Merges the current VitTableStyle with another, prioritizing non-null values from the other instance.
  VitTableStyle merge(VitTableStyle other) {
    return VitTableStyle(
      height: other.height ?? height,
      minHeight: other.minHeight ?? minHeight,
      header: header?.merge(other.header),
      row: other.row != null ? (row?.merge(other.row!) ?? other.row) : row,
      innerBottom: other.innerBottom ?? innerBottom,
      onEmptyWidget: other.onEmptyWidget ?? onEmptyWidget,
      scrollbarBuilder: other.scrollbarBuilder ?? scrollbarBuilder,
      decoration: other.decoration ?? decoration,
      pageNavigatorThemeData:
          pageNavigatorThemeData.merge(other.pageNavigatorThemeData),
    );
  }
}
