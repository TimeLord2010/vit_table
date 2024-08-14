import 'package:flutter/widgets.dart';
import 'package:vit_table/data/models/vit_table_column.dart';
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
  });

  final List<VitTableColumn> columns;
  final VitTableStyle style;

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
          for (final column in columns) _buildColumn(column),
        ],
      ),
    );
  }

  Widget _buildColumn(VitTableColumn column) {
    return VitTableCell(
      column: column,
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
    );
  }
}
