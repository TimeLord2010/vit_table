import 'package:flutter/material.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
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
  });

  final List<VitTableColumn> columns;
  final VitTableStyle style;
  final int? sortingColumnIndex;
  final bool isAscSort;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: style.headerHeight,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: black,
          ),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < columns.length; i++) _buildColumn(i, columns[i]),
        ],
      ),
    );
  }

  Widget _buildColumn(int index, VitTableColumn column) {
    var isCurrentIndex = index == sortingColumnIndex;
    return VitTableCell(
      column: column,
      child: Row(
        children: [
          if (column.onSort != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: VitButton(
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
                child: switch (isCurrentIndex) {
                  true => _sortIcon(const Icon(
                      Icons.south_rounded,
                      size: 20,
                    )),
                  false => const Icon(
                      Icons.south_rounded,
                      size: 20,
                      color: Colors.grey,
                    ),
                },
              ),
            ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                column.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
