import 'package:flutter/widgets.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';

/// A class that holds the logic to insert [VitTableStyle] into the
/// widget tree as well as getting it using a [BuildContext].
class VitTableTheme extends StatelessWidget {
  /// Creates a instance of the class that holds the logic to insert
  /// [VitTableStyle] into the widget tree as well as getting it using
  /// a [BuildContext].
  const VitTableTheme({
    super.key,
    required this.child,
    required this.data,
  });

  /// The data of the theme.
  final VitTableStyle data;

  /// Any widget
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  /// Gets the [VitTableStyle] from the [BuildContext] if any.
  static VitTableStyle? maybeOf(BuildContext context) {
    var child = context.findAncestorWidgetOfExactType<VitTableTheme>();
    return child?.data;
  }

  /// Gets the [VitTableStyle] from the [BuildContext].
  /// This method throws an exception if no data is found.
  static VitTableStyle of(BuildContext context) {
    var data = maybeOf(context);
    if (data == null) {
      throw StateError('No VitTableStyle found on context');
    }
    return data;
  }
}
