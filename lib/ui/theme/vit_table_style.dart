import 'package:flutter/widgets.dart';
import 'package:vit_table/ui/theme/row_style.dart';

import 'page_navigator_theme.dart';

class VitTableStyle {
  /// The exact height of the table.
  final double? height;

  /// The minimum height of the table.
  final double? minHeight;

  /// The height of the header.
  final double? headerHeight;

  final Decoration? decoration;

  /// The widget to show at the bottom of the table. Shown inside the table.
  final Widget? innerBottom;

  /// Widget to show when the table is empty
  final Widget? onEmptyWidget;

  final PageNavigatorThemeData pageNavigatorThemeData;

  final RowStyle? rowStyle;

  final RawScrollbar Function(
    ScrollController? controller,
    Widget child,
  )? scrollbarBuilder;

  const VitTableStyle({
    this.height,
    this.minHeight,
    this.headerHeight,
    this.rowStyle,
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
      headerHeight: other.headerHeight ?? headerHeight,
      rowStyle: other.rowStyle != null
          ? (rowStyle?.merge(other.rowStyle!) ?? other.rowStyle)
          : rowStyle,
      innerBottom: other.innerBottom ?? innerBottom,
      onEmptyWidget: other.onEmptyWidget ?? onEmptyWidget,
      scrollbarBuilder: other.scrollbarBuilder ?? scrollbarBuilder,
      decoration: other.decoration ?? decoration,
      pageNavigatorThemeData:
          pageNavigatorThemeData.merge(other.pageNavigatorThemeData),
    );
  }
}
