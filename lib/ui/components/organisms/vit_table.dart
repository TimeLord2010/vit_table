import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
import 'package:vit_table/data/models/vit_table_reorder_mode.dart';
import 'package:vit_table/ui/components/molecules/rows_manager.dart';
import 'package:vit_table/ui/components/molecules/vit_table_headers.dart';
import 'package:vit_table/ui/components/organisms/page_navigator.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';
import 'package:vit_table/ui/theme/vit_table_theme.dart';

import '../../../data/models/vit_table_row.dart' as row;

typedef ScrollbarBuilder = RawScrollbar Function(
  ScrollController? controller,
  Widget child,
);

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
    this.scrollbarBuilder,
    this.padding,
    this.isReordering = false,
    this.onReorder,
    this.reorderMode = VitTableReorderMode.row,
    this.reorderIcon,
  });

  final List<VitTableColumn> columns;
  final List<row.VitTableRow> rows;
  final int? pageCount, currentPageIndex;
  final void Function(int pageIndex)? onPageSelected;
  final VitTableStyle? style;
  final bool enableHorizontalScroll;
  final int? sortColumnIndex;
  final bool isAscSort;
  final RawScrollbar Function(ScrollController? controller, Widget child)?
      scrollbarBuilder;
  final EdgeInsets? padding;

  /// When true, rows can be dragged to reorder them.
  final bool isReordering;

  /// Called when the user drops a row at a new position.
  final void Function(int oldIndex, int newIndex)? onReorder;

  /// Controls where the drag handle is placed. Defaults to [VitTableReorderMode.row],
  /// which makes the entire row draggable.
  final VitTableReorderMode reorderMode;

  /// Icon shown as the drag handle when [reorderMode] is [VitTableReorderMode.leading]
  /// or [VitTableReorderMode.trailing]. Defaults to [Icons.drag_handle].
  final Widget? reorderIcon;

  bool get hasPaginator {
    return currentPageIndex != null &&
        pageCount != null &&
        onPageSelected != null;
  }

  /// Gets the style from the class instance or from the theme in build context.
  VitTableStyle _getStyle(BuildContext context) {
    var s = VitTableTheme.maybeOf(context);
    var defaultValue = s ?? const VitTableStyle();
    if (style != null) {
      return defaultValue.merge(style!);
    }
    return defaultValue;
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
          themeData: _getStyle(context).pageNavigatorThemeData,
          currentPageIndex: currentPageIndex!,
          pagesCount: pageCount!,
          onPageSelected: onPageSelected!,
        ),
      ],
    );
  }

  Widget _tableContainer(BuildContext context) {
    var style = _getStyle(context);
    var scrollbarBuilder = this.scrollbarBuilder ?? style.scrollbarBuilder;
    return ScrollConfiguration(
      behavior: scrollbarBuilder != null
          ? _VitScrollbarBehavior(scrollbarBuilder: scrollbarBuilder)
          : ScrollConfiguration.of(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          var totalWidth = constraints.maxWidth;

          // Column indices present here should not be rendered. We need this to remove the
          // respective cells in each row.
          // Columns become invalid if there is not enough space to display all the columns.
          var invalidColumns = <int>[];

          var currentColumns = [...columns];

          while (currentColumns.isNotEmpty && !enableHorizontalScroll) {
            // Checking if the existing width is enough to display the current list of columns
            double requiredWidth = _getRequiredWidth(currentColumns);
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
          var decoration = style.decoration;
          return Container(
            decoration: decoration,

            // Preventing the contents of the inner container from overflowing.
            child: ClipRRect(
              borderRadius: decoration is BoxDecoration
                  ? decoration.borderRadius ?? BorderRadius.zero
                  : BorderRadius.zero,
              child: Container(
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
      ),
    );
  }

  Widget _table({
    required BuildContext context,
    required List<VitTableColumn> currentColumns,
    required List<int> invalidColumns,
    required double maxWidth,
  }) {
    var rowMargin = style?.row?.margin;
    var horizontalMargin = (rowMargin?.left ?? 0) + (rowMargin?.right ?? 0);

    // Setting the right space to compensate for extras space on the right
    // side of the table in case [enableHorizontalScroll] is set to true and
    // the table is bigger than the columns width.
    double? rightSpace;
    if (enableHorizontalScroll) {
      var rowsWidth = _getRequiredWidth(currentColumns);
      var remainingHorizontalScace = maxWidth - rowsWidth;
      if (remainingHorizontalScace > 0) {
        rightSpace = remainingHorizontalScace + horizontalMargin;
      }
    }

    var requiredWidth = _getRequiredWidth(currentColumns);

    Widget column(BuildContext context, bool hasHorizontalScroll) {
      var style = _getStyle(context);
      return LayoutBuilder(
        builder: (context, constraints) {
          double width;
          if (maxWidth < requiredWidth) {
            width = requiredWidth + horizontalMargin;
          } else {
            width = maxWidth;
          }
          Widget rows = RowsManager(
            invalidColumns: invalidColumns,
            currentColumns: currentColumns,
            allowExpand: !hasHorizontalScroll,
            columns: columns,
            rows: this.rows,
            style: style,
            width: width,
            rightSpace: rightSpace,
            padding: padding,
            isReordering: isReordering,
            onReorder: onReorder,
            reorderMode: reorderMode,
            reorderIcon: reorderIcon,
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
                isReordering: isReordering,
                reorderMode: reorderMode,
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

class _VitScrollbarBehavior extends ScrollBehavior {
  const _VitScrollbarBehavior({this.scrollbarBuilder});

  final RawScrollbar Function(
    ScrollController? controller,
    Widget child,
  )? scrollbarBuilder;

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (scrollbarBuilder != null) {
      return scrollbarBuilder!(details.controller, child);
    }
    return super.buildScrollbar(context, child, details);
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        ...super.dragDevices,
      };
}

double _getRequiredWidth(Iterable<VitTableColumn> columns) {
  return columns.fold(0.0, (p, x) => p + x.width) + 5;
}
