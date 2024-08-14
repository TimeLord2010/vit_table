import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:vit_table/ui/components/molecules/page_navigator_button.dart';
import 'package:vit_table/ui/theme/vit_table_style.dart';

class PageNavigator extends StatelessWidget {
  /// MEANT FOR INTERNAL USE ONLY
  const PageNavigator({
    super.key,
    required this.currentPageIndex,
    required this.pagesCount,
    required this.onPageSelected,
    required this.style,
    this.itemSize = 40,
    this.jumpPageOffset = 9,
    this.showEdgePages = false,
    this.showJumpPage = true,
  });

  final VitTableStyle style;

  final double itemSize;

  /// The current selected page index.
  final int currentPageIndex;

  /// The total number of pages that exist.
  final int pagesCount;

  /// How far the page jump is set. Default is 10.
  ///
  /// For more information, see docs on [showPageJump].
  final int jumpPageOffset;

  /// Indicates if the jump page is shown.
  ///
  /// A jump page is a page which is too far to be shown, but it is being deplayed.
  ///
  /// For example, if the current page is 1, then 2 and 3 should also be shown.
  /// But to facilitate the usability, the page 10 is also shown in case the
  /// user wishes to go far ahead at one. In this example, page 10 is a page
  /// jump.
  ///
  /// By default, the page jump is 10, but this can change using the
  /// [jumpPageOffset].
  final bool showJumpPage;

  /// Indicates if the first and last pages are always shown.
  final bool showEdgePages;

  final void Function(int pageIndex) onPageSelected;

  int get actualJump {
    // if (pagesCount < jumpPageOffset) {
    //   return pagesCount - 1;
    // }
    return jumpPageOffset;
  }

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
      const Gap(10),
      _getPageItem(currentPageIndex - actualJump),
      const Gap(5),
      _getPageItem(currentPageIndex - 2),
      _getPageItem(currentPageIndex - 1),
      _getPageItem(currentPageIndex),
      _getPageItem(currentPageIndex + 1),
      _getPageItem(currentPageIndex + 2),
      const Gap(5),
      if (currentPageIndex < (pagesCount - 1) - actualJump)
        _getPageItem(currentPageIndex + actualJump),
      const Gap(10),
      _getLastPage(),
    ];
    return items.whereType<Widget>().toList();
  }

  Widget? _getFirstPage() {
    if (currentPageIndex <= actualJump) {
      return SizedBox(
        width: itemSize,
      );
    }
    return _getPageItem(0);
  }

  Widget? _getLastPage() {
    if (currentPageIndex > (pagesCount - 4)) {
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
        style: style,
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
