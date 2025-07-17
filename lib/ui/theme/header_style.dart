import 'package:flutter/widgets.dart';

class HeaderStyle {
  /// The height of the header.
  final double? height;

  final Widget Function(bool? isAscending)? sortIcon;

  final bool showSortIconRight;

  HeaderStyle({
    this.height,
    this.sortIcon,
    this.showSortIconRight = true,
  });

  HeaderStyle merge(HeaderStyle? style) {
    return HeaderStyle(
      height: style?.height ?? height,
      sortIcon: style?.sortIcon ?? sortIcon,
    );
  }
}
