import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/auth/login_page.dart';
import 'package:app/auth/register_page.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/SliderBarMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SliderBarMenuPreload extends StatelessWidget {
  final Function(String title) onClickItem;
  final String activeTab;
  SliderBarMenuPreload({required this.onClickItem, required this.activeTab, super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(children: [
      SizedBox(
        height: 2.h,
      ),
      ...[
        Menu(Image.asset("assets/icon 0.png"), S.of(context).page1),
        Menu(Image.asset("assets/icon 3.png"), S.of(context).page4),
        Menu(Image.asset("assets/icon 4.png"), S.of(context).page5),
        Menu(Image.asset("assets/icon 5.png"), S.of(context).page6),
        //Menu(Image.asset("assets/icon 6.png"), S.of(context).page7),
        Menu(Image.asset("assets/icon 7.png"), S.of(context).page8),
        Menu(Image.asset("assets/icon 8.png"), S.of(context).page11),
        //Menu(Image.asset("assets/icon 8.png"), S.of(context).page9),
        //Menu(Image.asset("assets/icon 9.png"), S.of(context).page10),
      ].map((menu) => SliderMenuItem(title: menu.title, isSelected: activeTab.contains(menu.title), iconData: menu.iconData, onTap: onClickItem)).toList(),
      SizedBox(
        height: 2.h,
      ),
      InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        child: Ink(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: GlobalsColor.blue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(S.of(context).page3, style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold))],
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 1.h,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Container(
          height: 8.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: GlobalsColor.blue),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {
                      debugPrint("Tap add");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                    },
                    child: Ink(
                      child: Text(
                        S.of(context).preload_page1,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              const VerticalDivider(),
              Flexible(
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage(
                                    mode: UserRole.SPECIALIST,
                                  )));
                    },
                    child: Ink(
                      child: Text(
                        S.of(context).preload_page2,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 1.h,
      ),
      InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        child: Ink(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: GlobalsColor.blue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.next_plan,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(S.of(context).signin, style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 2.h,
      ),
    ]));
  }
}
