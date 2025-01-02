import 'package:flutter/widgets.dart';
import 'package:vit_table/data/models/page_navigator_theme.dart';
import 'package:vit_table/ui/components/molecules/page_navigator_button.dart';

class PageNavigator extends StatelessWidget {
  /// MEANT FOR INTERNAL USE ONLY
  const PageNavigator({
    super.key,
    required this.currentPageIndex,
    required this.pagesCount,
    required this.onPageSelected,
    required this.themeData,
  });

  final PageNavigatorThemeData themeData;

  /// The current selected page index.
  final int currentPageIndex;

  /// The total number of pages that exist.
  final int pagesCount;

  final void Function(int pageIndex) onPageSelected;

  bool get showJumpPage => themeData.options.showJumpPage;

  bool get showEdgePages => themeData.options.showEdgePages;

  int get jumpPageOffset => themeData.options.jumpPageOffset;

  @override
  Widget build(BuildContext context) {
    if (pagesCount == 0) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _getItems(),
    );
  }

  List<Widget> _getItems() {
    List<Widget?> items = [
      _getFirstPage(),
      const SizedBox(width: 10),
      if (showJumpPage) _getPageItem(currentPageIndex - jumpPageOffset),
      const SizedBox(width: 5),
      _getPageItem(currentPageIndex - 2),
      _getPageItem(currentPageIndex - 1),
      _getPageItem(currentPageIndex),
      _getPageItem(currentPageIndex + 1),
      _getPageItem(currentPageIndex + 2),
      const SizedBox(width: 5),
      if (showJumpPage && currentPageIndex < (pagesCount - 1) - jumpPageOffset)
        _getPageItem(currentPageIndex + jumpPageOffset),
      const SizedBox(width: 10),
      _getLastPage(),
    ];

    var buttons = items.whereType<PageNavigatorButtom>().toList();

    if (buttons.length > 1) {
      var first = buttons.first;
      var second = buttons[1];

      if (first.pageIndex == second.pageIndex) {
        items.removeAt(0);
      }
    }

    buttons = items.whereType<PageNavigatorButtom>().toList();

    if (buttons.length > 2) {
      var last = buttons.last;
      var secondLast = buttons[buttons.length - 2];

      if (last.pageIndex == secondLast.pageIndex) {
        items.removeLast();
      }
    }

    return items.whereType<Widget>().toList();
  }

  Widget? _getFirstPage() {
    if (!showEdgePages && currentPageIndex <= jumpPageOffset) {
      return SizedBox(
        width: themeData.style.itemSize ?? 40,
      );
    }
    return _getPageItem(0);
  }

  Widget? _getLastPage() {
    if (!showEdgePages && currentPageIndex > (pagesCount - 4)) {
      return SizedBox(
        width: themeData.style.itemSize ?? 40,
      );
    }

    return _getPageItem(pagesCount - 1);
  }

  Widget _getPageItem(int pageIndex) {
    if (pageIndex < 0 || pageIndex >= pagesCount) {
      //return const SizedBox.shrink();
      return SizedBox(
        width: themeData.style.itemSize ?? 40,
      );
    }
    return PageNavigatorButtom(
      style: themeData.style,
      pageIndex: pageIndex,
      isSelected: pageIndex == currentPageIndex,
      onSelected: () => onPageSelected(pageIndex),
    );
  }
}
