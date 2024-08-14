import 'package:flutter/widgets.dart';

class TableRowModel {
  final List<Widget> cells;
  final EdgeInsets cellsPadding;

  const TableRowModel({
    required this.cells,
    this.cellsPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });
}
