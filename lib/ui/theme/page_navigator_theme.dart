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
}
