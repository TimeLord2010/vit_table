import 'package:flutter/widgets.dart';

class VitTableRow {
  final List<Widget> cells;
  final EdgeInsets cellsPadding;

  const VitTableRow({
    required this.cells,
    this.cellsPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });
}
