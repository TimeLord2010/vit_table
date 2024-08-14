import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vit_dart_extensions/vit_dart_extensions.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/ui/components/atoms/adaptative_vexapnded.dart';
import 'package:vit_table/ui/components/molecules/vit_table_headers.dart';
import 'package:vit_table/ui/components/molecules/vit_table_row.dart';
import 'package:vit_table/ui/components/organisms/page_navigator.dart';
import 'package:vit_table/ui/theme/colors.dart';

import '../../../../../data/models/table_row_model.dart' as row;

class VitTable extends StatelessWidget {
  const VitTable({
    super.key,
    required this.columns,
    required this.rows,
    this.pageCount,
    this.currentPageIndex,
    this.onPageSelected,
    this.rowsContainerHeight,
    this.rowsContainerBottom,
    this.rowHeight,
  });

  final List<VitTableColumn> columns;
  final List<row.TableRowModel> rows;
  final double? rowsContainerHeight;
  final double? rowHeight;
  final Widget? rowsContainerBottom;
  final int? pageCount, currentPageIndex;
  final void Function(int pageIndex)? onPageSelected;

  bool get hasPaginator {
    return currentPageIndex != null &&
        pageCount != null &&
        onPageSelected != null;
  }

  @override
  Widget build(BuildContext context) {
    if (!hasPaginator) {
      return _table();
    }
    return Column(
      children: [
        Expanded(
          child: _table(),
        ),
        const SizedBox(height: 5),
        PageNavigator(
          currentPageIndex: currentPageIndex!,
          pagesCount: pageCount!,
          onPageSelected: onPageSelected!,
        ),
      ],
    );
  }

  Widget _table() {
    return LayoutBuilder(
      builder: (context, constraints) {
        var totalWidth = constraints.maxWidth;

        // Column indices present here should not be rendered. We need this to remove the
        // respective cells in each row.
        // Columns become invalid if there is not enough space to display all the columns.
        var invalidColumns = <int>[];

        var currentColumns = [...columns];

        while (currentColumns.isNotEmpty) {
          // Checking if the existing width is enough to display the current list of columns
          double requiredWidth =
              currentColumns.fold(0.0, (p, x) => p + x.width);
          if (totalWidth >= requiredWidth) {
            break;
          }

          // Finding column with least priority
          var leastPriorityColumn = currentColumns.reduce((p, x) {
            return x.priority > p.priority ? x : p;
          });

          // Keeping track of invalid columns
          var columnIndex = columns.indexOf(leastPriorityColumn);
          if (columnIndex < 0) {
            throw Exception('Column index not found');
          }
          invalidColumns.add(columnIndex);

          // Removing column to update width calculations
          currentColumns.remove(leastPriorityColumn);
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: gray3,
            ),
            color: white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              VitTableHeaders(
                columns: currentColumns,
              ),
              if (constraints.hasBoundedHeight)
                AdaptativeVExpanded(
                  height: rowsContainerHeight,
                  child: _rows(
                    invalidColumns: invalidColumns,
                    currentColumns: currentColumns,
                    isInfiniteHeight: false,
                  ),
                )
              else
                _rows(
                  invalidColumns: invalidColumns,
                  currentColumns: currentColumns,
                  isInfiniteHeight: true,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _rows({
    required List<int> invalidColumns,
    required List<VitTableColumn> currentColumns,
    required bool isInfiniteHeight,
  }) {
    Widget rowFromIndex(int index) {
      var row = rows.elementAt(index);
      var cells = row.cells;
      assert(
        cells.length == columns.length,
        'Number of cells must be equal to the number of columns',
      );
      var validCells = cells.removeIndices(invalidColumns.toSet());
      return VitTableRow(
        rowIndex: index,
        validCells: validCells,
        validColumns: currentColumns,
        height: rowHeight,
      );
    }

    if (rows.isEmpty) {
      return const SizedBox(
        height: 150,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isInfiniteHeight)
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => rowFromIndex(index),
              itemCount: rows.length,
            ),
          )
        else
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(rows.length, (index) {
              return rowFromIndex(index);
            }),
          ),
        if (rowsContainerBottom != null) rowsContainerBottom!,
      ],
    );
  }
}
