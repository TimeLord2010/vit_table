import 'package:flutter/widgets.dart';
import 'package:vit_table/ui/components/atoms/vit_button.dart';
import 'package:vit_table/ui/theme/colors.dart';

class PageNavigatorButtom extends StatelessWidget {
  const PageNavigatorButtom({
    super.key,
    required this.pageIndex,
    required this.isSelected,
    required this.onSelected,
  });

  final int pageIndex;
  final bool isSelected;
  final void Function() onSelected;

  Color? get backgroundColor {
    if (isSelected) {
      return primary3;
    }
    return white;
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
