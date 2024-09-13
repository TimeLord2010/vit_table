import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/ui/components/molecules/rows_manager.dart';
import 'package:vit_table/ui/components/molecules/vit_table_headers.dart';
import 'package:vit_table/ui/components/organisms/page_navigator.dart';
import 'package:vit_table/ui/protocols/column/get_required_width.dart';
import 'package:vit_table/ui/theme/colors.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';
import 'package:vit_table/ui/theme/vit_table_theme.dart';

import '../../../data/models/vit_table_row.dart' as row;

class VitTable extends StatelessWidget {
  const VitTable({
    super.key,
    required this.columns,
    required this.rows,
    this.pageCount,
    this.currentPageIndex,
    this.onPageSelected,
    this.style,
    this.sortColumnIndex,
    this.enableHorizontalScroll = false,
    this.isAscSort = true,
  });

  final List<VitTableColumn> columns;
  final List<row.VitTableRow> rows;
  final int? pageCount, currentPageIndex;
  final void Function(int pageIndex)? onPageSelected;
  final VitTableStyle? style;
  final bool enableHorizontalScroll;
  final int? sortColumnIndex;
  final bool isAscSort;

  bool get hasPaginator {
    return currentPageIndex != null &&
        pageCount != null &&
        onPageSelected != null;
  }

  VitTableStyle _getStyle(BuildContext context) {
    if (style != null) {
      return style!;
    }
    var s = VitTableTheme.maybeOf(context);
    return s ?? const VitTableStyle();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasPaginator) {
      return _tableContainer(context);
    }
    return Column(
      children: [
        Expanded(
          child: _tableContainer(context),
        ),
        const SizedBox(height: 5),
        PageNavigator(
          style: _getStyle(context),
          currentPageIndex: currentPageIndex!,
          pagesCount: pageCount!,
          onPageSelected: onPageSelected!,
        ),
      ],
    );
  }

  Widget _tableContainer(BuildContext context) {
    var style = _getStyle(context);
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
          double requiredWidth = getRequiredWidth(currentColumns);
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
                maxHeight: style.height ?? constraints.maxHeight,
              ),
              child: _table(
                context: context,
                currentColumns: currentColumns,
                invalidColumns: invalidColumns,

                // Subtracting the border sides from the available width.
                maxWidth: constraints.maxWidth - 2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _table({
    required BuildContext context,
    required List<VitTableColumn> currentColumns,
    required List<int> invalidColumns,
    required double maxWidth,
  }) {
    // Setting the right space to compensate for extras space on the right
    // side of the table in case [enableHorizontalScroll] is set to true and
    // the table is bigger than the columns width.
    double? rightSpace;
    if (enableHorizontalScroll) {
      var rowsWidth = getRequiredWidth(currentColumns);
      var value = maxWidth - rowsWidth;
      if (value > 0) {
        // We also need to subtract the border width of both sides.
        if (value >= 2) {
          rightSpace = value - 2;
        } else {
          rightSpace = value;
        }
      }
    }

    var requiredWidth = getRequiredWidth(currentColumns);

    Widget column(BuildContext context, bool hasHorizontalScroll) {
      var style = _getStyle(context);
      return LayoutBuilder(
        builder: (context, constraints) {
          Widget rows = RowsManager(
            invalidColumns: invalidColumns,
            currentColumns: currentColumns,
            allowExpand: !hasHorizontalScroll,
            columns: columns,
            rows: this.rows,
            style: style,
            width: maxWidth < requiredWidth ? requiredWidth : maxWidth,
            rightSpace: rightSpace,
          );
          return Column(
            children: [
              VitTableHeaders(
                columns: currentColumns,
                style: style,
                sortingColumnIndex: sortColumnIndex,
                isAscSort: isAscSort,
                rightSpace: rightSpace,
                allowExpand: !hasHorizontalScroll,
              ),
              switch (constraints.maxHeight.isInfinite) {
                true => rows,
                false => Expanded(child: rows),
              },
            ],
          );
        },
      );
    }

    if (enableHorizontalScroll) {
      var needsSpace = requiredWidth > maxWidth;
      if (needsSpace) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: column(context, true),
        );
      }
    }

    return column(context, false);
  }
}
