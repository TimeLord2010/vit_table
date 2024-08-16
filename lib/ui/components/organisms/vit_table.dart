import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vit_dart_extensions/vit_dart_extensions.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/ui/components/molecules/row_manager.dart';
import 'package:vit_table/ui/components/molecules/vit_table_headers.dart';
import 'package:vit_table/ui/components/organisms/page_navigator.dart';
import 'package:vit_table/ui/theme/colors.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';

import '../../../data/models/vit_table_row.dart' as row;

class VitTable extends StatelessWidget {
  const VitTable({
    super.key,
    required this.columns,
    required this.rows,
    this.pageCount,
    this.currentPageIndex,
    this.onPageSelected,
    this.style = const VitTableStyle(),
    this.sortColumnIndex,
    this.enableHorizontalScroll = false,
    this.isAscSort = true,
  });

  final List<VitTableColumn> columns;
  final List<row.VitTableRow> rows;
  final int? pageCount, currentPageIndex;
  final void Function(int pageIndex)? onPageSelected;
  final VitTableStyle style;
  final bool enableHorizontalScroll;
  final int? sortColumnIndex;
  final bool isAscSort;

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
          style: style,
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

        while (currentColumns.isNotEmpty && !enableHorizontalScroll) {
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

        // Creating container to build the border.
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: gray3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),

          // Preventing the contents of the inner container from overflowing.
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: white,
              constraints: BoxConstraints(
                minHeight: style.minHeight ?? style.height ?? 0,
                maxHeight: style.height ?? double.infinity,
              ),
              child: _table(
                currentColumns: currentColumns,
                invalidColumns: invalidColumns,
                maxWidth: constraints.maxWidth,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _table({
    required List<VitTableColumn> currentColumns,
    required List<int> invalidColumns,
    required double maxWidth,
  }) {
    double? width;
    if (enableHorizontalScroll) {
      var rowsWidth = currentColumns.fold(0.0, (p, x) => p + x.width);
      var value = maxWidth - rowsWidth;
      if (value > 0) {
        // We also need to subtract the border width of both sides.
        if (value >= 2) {
          width = value - 2;
        } else {
          width = value;
        }
      }
    }

    Widget rows = _rows(
      invalidColumns: invalidColumns,
      currentColumns: currentColumns,
      rightSpace: width,
    );

    var column = Column(
      children: [
        VitTableHeaders(
          columns: currentColumns,
          style: style,
          sortingColumnIndex: sortColumnIndex,
          isAscSort: isAscSort,
          rightSpace: width,
          allowExpand: !enableHorizontalScroll,
        ),
        switch (hasInfiniteHeight) {
          true => rows,
          false => Expanded(child: rows),
        },
      ],
    );

    if (enableHorizontalScroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: column,
      );
    }

    return column;
  }

  Widget _rows({
    required List<int> invalidColumns,
    required List<VitTableColumn> currentColumns,
    double? rightSpace,
  }) {
    Widget rowFromIndex(int index) {
      var row = rows.elementAt(index);
      var cells = row.cells;
      assert(
        cells.length == columns.length,
        'Number of cells must be equal to the number of columns',
      );
      var validCells = cells.removeIndices(invalidColumns.toSet());
      return RowManager(
        rowIndex: index,
        validCells: validCells,
        validColumns: currentColumns,
        style: style,
        allowExpand: !enableHorizontalScroll,
        rightSpace: rightSpace,
      );
    }

    if (rows.isEmpty) {
      if (style.onEmptyWidget != null) {
        return style.onEmptyWidget!;
      }
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
            child: ListView.builder(
              itemBuilder: (context, index) => rowFromIndex(index),
              itemCount: rows.length,
            ),
          ),
        if (style.innerBottom != null) style.innerBottom!,
      ],
    );
  }
}
