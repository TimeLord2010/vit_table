import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vit_dart_extensions/vit_dart_extensions.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/ui/components/molecules/vit_table_headers.dart';
import 'package:vit_table/ui/components/molecules/vit_table_row.dart';
import 'package:vit_table/ui/components/organisms/page_navigator.dart';
import 'package:vit_table/ui/theme/colors.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';

import '../../../../../data/models/table_row_model.dart' as row;

class VitTable extends StatelessWidget {
  const VitTable({
    super.key,
    required this.columns,
    required this.rows,
    this.pageCount,
    this.currentPageIndex,
    this.onPageSelected,
    this.style = const VitTableStyle(),
  });

  final List<VitTableColumn> columns;
  final List<row.TableRowModel> rows;
  final int? pageCount, currentPageIndex;
  final void Function(int pageIndex)? onPageSelected;
  final VitTableStyle style;

  bool get hasPaginator {
    return currentPageIndex != null &&
        pageCount != null &&
        onPageSelected != null;
  }

  bool get hasInfiniteHeight {
    return style.height == null;
  }

  @override
  Widget build(BuildContext context) {
    if (!hasPaginator) {
      return _tableContainer();
    }
    return Column(
      children: [
        Expanded(
          child: _tableContainer(),
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

  Widget _tableContainer() {
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
              currentColumns.fold(0.0, (p, x) => p + x.width) + 5;
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

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: gray3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: white,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: style.minHeight ?? style.height ?? 0,
                  maxHeight: style.height ?? double.infinity,
                ),
                child: _table(currentColumns, constraints, invalidColumns),
              ),
            ),
          ),
        );
      },
    );
  }

  Column _table(
    List<VitTableColumn> currentColumns,
    BoxConstraints constraints,
    List<int> invalidColumns,
  ) {
    var rows = _rows(
      invalidColumns: invalidColumns,
      currentColumns: currentColumns,
    );
    return Column(
      children: [
        VitTableHeaders(
          columns: currentColumns,
          style: style,
        ),
        switch (hasInfiniteHeight) {
          true => rows,
          false => Expanded(child: rows),
        },
      ],
    );
  }

  Widget _rows({
    required List<int> invalidColumns,
    required List<VitTableColumn> currentColumns,
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
        style: style,
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
        if (hasInfiniteHeight)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(rows.length, (index) {
              return rowFromIndex(index);
            }),
          )
        else
          Expanded(
            child: _scrollableRows(rowFromIndex),
          ),
        if (style.innerBottom != null) style.innerBottom!,
      ],
    );
  }

  ListView _scrollableRows(Widget Function(int index) rowFromIndex) {
    return ListView.builder(
      itemBuilder: (context, index) => rowFromIndex(index),
      itemCount: rows.length,
    );
  }
}
