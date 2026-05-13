import 'package:flutter/material.dart';
import 'package:vit_dart_extensions/vit_dart_extensions.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/data/models/vit_table_reorder_mode.dart';
import 'package:vit_table/data/models/vit_table_row.dart';
import 'package:vit_table/ui/components/molecules/row_highlighter.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';

class RowsManager extends StatelessWidget {
  const RowsManager({
    super.key,
    required this.currentColumns,
    required this.allowExpand,
    required this.invalidColumns,
    required this.columns,
    required this.rows,
    required this.style,
    required this.width,
    this.rightSpace,
    this.padding,
    this.isReordering = false,
    this.onReorder,
    this.reorderMode = VitTableReorderMode.row,
    this.reorderIcon,
  });

  final List<int> invalidColumns;
  final List<VitTableColumn> currentColumns;
  final List<VitTableColumn> columns;
  final List<VitTableRow> rows;
  final bool allowExpand;
  final VitTableStyle style;
  final double? rightSpace;
  final double width;
  final EdgeInsets? padding;
  final bool isReordering;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final VitTableReorderMode reorderMode;
  final Widget? reorderIcon;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      if (style.onEmptyWidget != null) {
        return style.onEmptyWidget!;
      }
      return const SizedBox(
        height: 150,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            if (constraints.maxHeight.isInfinite)
              if (isReordering)
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorder: onReorder ?? (_, __) {},
                  children: List.generate(rows.length, (index) {
                    return KeyedSubtree(
                      key: ValueKey(index),
                      child: _rowFromIndex(index),
                    );
                  }),
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(rows.length, (index) {
                    return _rowFromIndex(index);
                  }),
                )
            else
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: width,
                  ),
                  child: isReordering
                      ? ReorderableListView.builder(
                          padding: padding,
                          buildDefaultDragHandles: false,
                          onReorder: onReorder ?? (_, __) {},
                          itemBuilder: (context, index) => KeyedSubtree(
                            key: ValueKey(index),
                            child: _rowFromIndex(index),
                          ),
                          itemCount: rows.length,
                        )
                      : ListView.builder(
                          padding: padding,
                          itemBuilder: (context, index) =>
                              _rowFromIndex(index),
                          itemCount: rows.length,
                        ),
                ),
              ),
            if (style.innerBottom != null) style.innerBottom!,
          ],
        );
      },
    );
  }

  Widget _rowFromIndex(int index) {
    var row = rows.elementAt(index);
    var cells = row.cells;
    assert(
      cells.length == columns.length,
      'Number of cells must be equal to the number of columns',
    );

    var validCells = cells.removeIndices(invalidColumns.toSet());
    return RowHighlighter(
      rowIndex: index,
      validCells: validCells,
      validColumns: currentColumns,
      style: style,
      allowExpand: allowExpand,
      rightSpace: rightSpace,
      isReordering: isReordering,
      reorderMode: reorderMode,
      reorderIcon: reorderIcon,
    );
  }
}
