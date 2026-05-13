import 'package:flutter/material.dart';
import 'package:vit_table/data/constraints.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/data/models/vit_table_reorder_mode.dart';
import 'package:vit_table/ui/components/atoms/mouse_hover_listener.dart';
import 'package:vit_table/ui/components/atoms/vit_table_cell.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';

/// Builds the row on a VitTable.
///
/// This widget hightlights the entire row when the mouse is over it.
class RowHighlighter extends StatelessWidget {
  /// MEANT FOR INTERNAL USE ONLY.
  const RowHighlighter({
    super.key,
    required this.rowIndex,
    required this.validColumns,
    required this.validCells,
    required this.style,
    this.allowExpand = true,
    this.rightSpace,
    this.isReordering = false,
    this.reorderMode = VitTableReorderMode.row,
    this.reorderIcon,
  });

  final int rowIndex;
  final List<VitTableColumn> validColumns;
  final List<Widget> validCells;
  final VitTableStyle style;

  /// Indicates if cells can expand horizontally.
  final bool allowExpand;

  final double? rightSpace;
  final bool isReordering;
  final VitTableReorderMode reorderMode;
  final Widget? reorderIcon;

  @override
  Widget build(BuildContext context) {
    var rowStyle = style.row;
    var alternatingStyle = rowStyle?.alternatingStyle;

    Decoration? getDecoration(bool isMouseOver) {
      if (isMouseOver) {
        var s = style.row?.mouseOverDecoration;
        if (s != null) return s;
      }
      if (alternatingStyle != null) {
        var isEvenAlternation = alternatingStyle.isEven;
        var hasBackground = switch (isEvenAlternation) {
          true => rowIndex % 2 == 0,
          false => rowIndex % 3 == 0,
        };
        if (hasBackground) {
          return alternatingStyle.decoration;
        }
      }
      return rowStyle?.decoration;
    }

    final cells = _cells(cells: validCells, columns: validColumns);

    Widget buildHandle() {
      final icon = reorderIcon ?? const Icon(Icons.drag_handle);
      return MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: ReorderableDragStartListener(
          index: rowIndex,
          child: SizedBox(
            width: kReorderHandleWidth,
            child: Center(child: icon),
          ),
        ),
      );
    }

    Widget rowContent;
    MouseCursor cursor;

    if (!isReordering) {
      cursor = SystemMouseCursors.basic;
      rowContent = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: cells,
      );
    } else {
      switch (reorderMode) {
        case VitTableReorderMode.row:
          cursor = SystemMouseCursors.grab;
          rowContent = ReorderableDragStartListener(
            index: rowIndex,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: cells,
            ),
          );
        case VitTableReorderMode.leading:
          cursor = SystemMouseCursors.basic;
          rowContent = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [buildHandle(), ...cells],
          );
        case VitTableReorderMode.trailing:
          cursor = SystemMouseCursors.basic;
          rowContent = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [...cells, buildHandle()],
          );
      }
    }

    return MouseHoverListener(
      builder: (isMouseOver, child) {
        return Container(
          decoration: getDecoration(isMouseOver),
          margin: rowStyle?.margin,
          constraints: BoxConstraints(minHeight: style.row?.minRowHeight ?? 40),
          child: child,
        );
      },
      cursor: cursor,
      child: rowContent,
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
        allowExpand: allowExpand,
        child: cells[i],
      ));
    }
    if (rightSpace != null) {
      items.add(SizedBox(width: rightSpace));
    }
    return items;
  }
}
