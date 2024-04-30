import 'package:app/generated/l10n.dart';
import 'package:app/utils/SliderBarMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SliderBarMenuPreload extends StatelessWidget {
  final Function(String title) onClickItem;
  final String activeTab;
  SliderBarMenuPreload(
      {required this.onClickItem, required this.activeTab, super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      SizedBox(
        height: 2.h,
      ),
      ...[
        Menu(Image.asset("assets/icon 0.png"), S.of(context).preload_page1),
        Menu(Image.asset("assets/icon 2.png"), S.of(context).page3),
        Menu(Image.asset("assets/icon 0.png"), S.of(context).preload_page2),
      ]
          .map((menu) => menu != null
              ? SliderMenuItem(
                  title: menu.title,
                  isSelected: activeTab.contains(menu.title),
                  iconData: menu.iconData,
                  onTap: onClickItem)
              : const SizedBox.shrink())
          .toList(),
    ]));
  }
}
