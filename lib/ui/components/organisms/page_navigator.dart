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
    this.itemSize = 40,
  });

  final PageNavigatorThemeData themeData;

  final double itemSize;

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
    var items = [
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
    return items.whereType<Widget>().toList();
  }

  Widget? _getFirstPage() {
    if (!showEdgePages && currentPageIndex <= jumpPageOffset) {
      return SizedBox(
        width: itemSize,
      );
    }
    return _getPageItem(0);
  }

  Widget? _getLastPage() {
    if (!showEdgePages && currentPageIndex > (pagesCount - 4)) {
      return SizedBox(
        width: itemSize,
      );
    }

    return _getPageItem(pagesCount - 1);
  }

  Widget _getItem(Widget child) {
    return SizedBox(
      height: itemSize,
      width: itemSize,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: child,
      ),
    );
  }

  Widget? _getPageItem(int pageIndex) {
    Widget? render() {
      if (pageIndex < 0 || pageIndex >= pagesCount) {
        return null;
      }
      return PageNavigatorButtom(
        style: themeData.style,
        pageIndex: pageIndex,
        isSelected: pageIndex == currentPageIndex,
        onSelected: () => onPageSelected(pageIndex),
      );
    }

    var render2 = render();
    if (render2 == null) {
      return null;
    }
    return _getItem(render2);
  }
}
