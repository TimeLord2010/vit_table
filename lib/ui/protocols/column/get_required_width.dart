import 'package:vit_table/data/models/vit_table_column.dart';

double getRequiredWidth(Iterable<VitTableColumn> columns) {
  return columns.fold(0.0, (p, x) => p + x.width) + 5;
}
