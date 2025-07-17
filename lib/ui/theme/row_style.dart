import 'package:flutter/widgets.dart';

class RowStyle {
  /// The minimum height of each row.
  final double? minRowHeight;

  final RowAlternatingStyle? alternatingStyle;

  final Decoration? mouseOverDecoration;

  final Decoration? decoration;

  final EdgeInsets? margin;

  RowStyle({
    this.minRowHeight,
    this.alternatingStyle,
    this.mouseOverDecoration,
    this.decoration,
    this.margin,
  });

  /// Merges the current RowStyle with another, prioritizing non-null values from the other instance.
  RowStyle merge(RowStyle other) {
    return RowStyle(
      minRowHeight: other.minRowHeight ?? minRowHeight,
      alternatingStyle: other.alternatingStyle ?? alternatingStyle,
      mouseOverDecoration: other.mouseOverDecoration ?? mouseOverDecoration,
      decoration: other.decoration ?? decoration,
      margin: other.margin ?? margin,
    );
  }
}

class RowAlternatingStyle {
  bool isEven;

  Decoration decoration;

  RowAlternatingStyle({
    required this.decoration,
    this.isEven = true,
  });
}
