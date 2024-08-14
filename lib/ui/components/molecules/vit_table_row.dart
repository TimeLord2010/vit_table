import 'package:flutter/material.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/ui/components/atoms/mouse_hover_listener.dart';
import 'package:vit_table/ui/components/atoms/vit_table_cell.dart';
import 'package:vit_table/ui/protocols/is_mobile.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';

class VitTableRow extends StatelessWidget {
  const VitTableRow({
    super.key,
    required this.rowIndex,
    required this.validColumns,
    required this.validCells,
    required this.style,
  });

  final int rowIndex;
  final List<VitTableColumn> validColumns;
  final List<Widget> validCells;
  final VitTableStyle style;

  @override
  Widget build(BuildContext context) {
    var mouseExists = !isMobile();
    var hasBackground = rowIndex % 2 == 0;
    Color? getBackgroundColor(bool isMouseOver) {
      if (mouseExists && isMouseOver) {
        const int v = 240;
        return const Color.fromARGB(255, v, v, v);
      }
      return hasBackground ? const Color.fromARGB(255, 248, 248, 248) : null;
    }

    return MouseHoverListener(
      builder: (isMouseOver, child) {
        return Container(
          decoration: BoxDecoration(
            color: getBackgroundColor(isMouseOver),
          ),
          height: style.rowHeight ?? 40,
          child: child,
        );
      },
      cursor: SystemMouseCursors.basic,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _cells(
          cells: validCells,
          columns: validColumns,
        ),
      ),
    );
  }

  List<Widget> _cells({
    required List<Widget> cells,
    required List<VitTableColumn> columns,
  }) {
    var items = <Widget>[];
    for (int i = 0; i < cells.length; i++) {
      items.add(VitTableCell(
        column: columns[i],
        child: cells[i],
      ));
    }
    return items;
  }
}
