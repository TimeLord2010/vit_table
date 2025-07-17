import 'package:vit_table/ui/theme/page_navigator_options.dart';

import 'page_navigator_style.dart';

class PageNavigatorThemeData {
  const PageNavigatorThemeData({
    PageNavigatorStyle? style,
    PageNavigatorOptions? options,
  })  : style = style ?? const PageNavigatorStyle(),
        options = options ?? const PageNavigatorOptions();

  final PageNavigatorStyle style;
  final PageNavigatorOptions options;

  /// Merges the current PageNavigatorThemeData with another, prioritizing non-null values from the other instance.
  PageNavigatorThemeData merge(PageNavigatorThemeData other) {
    return PageNavigatorThemeData(
      style: PageNavigatorStyle(
        selectedColor: other.style.selectedColor ?? style.selectedColor,
        color: other.style.color ?? style.color,
        itemSize: other.style.itemSize ?? style.itemSize,
      ),
      options: PageNavigatorOptions(
        jumpPageOffset: other.options.jumpPageOffset,
        showEdgePages: other.options.showEdgePages,
        showJumpPage: other.options.showJumpPage,
      ),
    );
  }
}
