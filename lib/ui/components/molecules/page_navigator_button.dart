import 'package:flutter/widgets.dart';
import 'package:vit_table/data/models/page_navigator_style.dart';
import 'package:vit_table/ui/components/atoms/vit_button.dart';
import 'package:vit_table/ui/theme/colors.dart';

class PageNavigatorButtom extends StatelessWidget {
  /// MEANT FOR INTERNAL USE ONLY
  const PageNavigatorButtom({
    super.key,
    required this.pageIndex,
    required this.isSelected,
    required this.onSelected,
    required this.style,
  });

  final int pageIndex;
  final bool isSelected;
  final void Function() onSelected;
  final PageNavigatorStyle? style;

  Color? get backgroundColor {
    if (isSelected) {
      var color = style?.selectedColor;
      return color ?? const Color.fromARGB(255, 85, 137, 255);
    }
    return style?.color ?? white;
  }

  @override
  Widget build(BuildContext context) {
    return VitButton(
      onPressed: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.all(5),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              (pageIndex + 1).toString(),
              style: TextStyle(
                color: isSelected ? white : black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
