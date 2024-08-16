import 'package:flutter/widgets.dart';
import 'package:vit_table/data/models/vit_table_column.dart';

/// Displays the cell of a VitTable.
///
/// This widget sets the padding and size constraints of the child widget.
class VitTableCell extends StatelessWidget {
  /// MEANT FOR INTERNAL USE ONLY.
  const VitTableCell({
    super.key,
    required this.column,
    required this.child,
    this.padding,
    this.allowExpand = true,
  });

  final VitTableColumn column;
  final Widget child;
  final EdgeInsets? padding;

  /// Indicates if the cell is allowed to expand horizontally.
  final bool allowExpand;

  Widget get content {
    return Padding(
      padding: padding ?? column.cellsPadding,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = column.width;
    if (!allowExpand || !column.expandable) {
      return SizedBox(
        width: width,
        child: content,
      );
    }
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          minWidth: width,
        ),
        child: content,
      ),
    );
  }
}
