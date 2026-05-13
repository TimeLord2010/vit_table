import 'package:flutter/material.dart';
import 'package:vit_table/data/constraints.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/data/models/vit_table_reorder_mode.dart';
import 'package:vit_table/ui/components/atoms/vit_button.dart';
import 'package:vit_table/ui/components/atoms/vit_table_cell.dart';
import 'package:vit_table/ui/theme/colors.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';

/// Build the header of a VitTable.
///
/// Creates the text in bold of each column and draws a line below it.
class VitTableHeaders extends StatelessWidget {
  const VitTableHeaders({
    super.key,
    required this.columns,
    required this.style,
    this.sortingColumnIndex,
    this.isAscSort = true,
    this.rightSpace,
    this.allowExpand = true,
    this.isReordering = false,
    this.reorderMode = VitTableReorderMode.row,
  });

  final List<VitTableColumn> columns;
  final VitTableStyle style;
  final int? sortingColumnIndex;
  final bool isAscSort;
  final double? rightSpace;

  /// Indicates that headers can expand.
  final bool allowExpand;
  final bool isReordering;
  final VitTableReorderMode reorderMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: style.header?.height ?? kDefaultHeaderHeight,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: black,
          ),
        ),
      ),
      child: Row(
        children: [
          if (isReordering && reorderMode == VitTableReorderMode.leading)
            const SizedBox(width: kReorderHandleWidth),
          for (int i = 0; i < columns.length; i++) _buildColumn(i, columns[i]),
          if (isReordering && reorderMode == VitTableReorderMode.trailing)
            const SizedBox(width: kReorderHandleWidth),
          if (rightSpace != null) SizedBox(width: rightSpace!),
        ],
      ),
    );
  }

  Widget _buildColumn(int index, VitTableColumn column) {
    var isCurrentIndex = index == sortingColumnIndex;
    var sortIconAtRight = style.header?.showSortIconRight ?? true;
    return VitTableCell(
      column: column,
      allowExpand: allowExpand,
      child: Row(
        children: [
          if (!sortIconAtRight && column.onSort != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _sortButton(isCurrentIndex, column),
            ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: column.title,
            ),
          ),
          if (sortIconAtRight && column.onSort != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: _sortButton(isCurrentIndex, column),
            )
        ],
      ),
    );
  }

  VitButton _sortButton(bool isCurrentIndex, VitTableColumn column) {
    var headerStyle = style.header;
    Widget Function(bool? isAscending) iconBuilder = headerStyle?.sortIcon ??
        (bool? isAsc) {
          if (isAsc != null) {
            return _sortIcon(const Icon(
              Icons.south_rounded,
              size: 20,
            ));
          }
          return const Icon(
            Icons.south_rounded,
            size: 20,
            color: Colors.grey,
          );
        };
    return VitButton(
        onPressed: () {
          var asc = isAscSort;
          if (isCurrentIndex) {
            asc = !isAscSort;
          } else {
            asc = true;
          }
          var sortFn = column.onSort;
          if (sortFn != null) sortFn(asc);
        },
        child: iconBuilder(isCurrentIndex ? isAscSort : null));
  }

  Widget _sortIcon(Widget child) {
    var duration = const Duration(milliseconds: 250);
    if (isAscSort) {
      return AnimatedRotation(
        turns: 0.5,
        duration: duration,
        child: child,
      );
    } else {
      return AnimatedRotation(
        turns: 0,
        duration: duration,
        child: child,
      );
    }
  }
}
