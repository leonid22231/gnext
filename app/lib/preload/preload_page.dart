import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/auth/login_page.dart';
import 'package:app/auth/register_page.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/transportation_page.dart';
import 'package:app/utils/SliderBarMenu.dart';
import 'package:app/utils/SliderBarMenuPreload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PreloadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreloadPageState();
}

class _PreloadPageState extends State<PreloadPage> {
  int activeTab = 1;
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  final GlobalKey<TransportationPageState> _transportationKey =
      GlobalKey<TransportationPageState>();
  String selectTab = "";
  List<String> pages = [];
  @override
  Widget build(BuildContext context) {
    pages = [
      S.of(context).preload_page1,
      S.of(context).page3,
      S.of(context).preload_page2,
    ];
    selectTab = pages[activeTab];
    return Scaffold(
      body: SliderDrawer(
        key: _sliderDrawerKey,
        sliderOpenSize: 80.w,
        appBar: SliderAppBar(
            appBarColor: Colors.white,
            appBarPadding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            appBarHeight: 15.h,
            title: Text(selectTab,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700))),
        slider: SliderBarMenuPreload(
            activeTab: selectTab,
            onClickItem: (title) {
              _sliderDrawerKey.currentState!.closeSlider();
              if (getIndex(context, title) == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              } else if (getIndex(context, title) == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const RegisterPage(mode: UserRole.SPECIALIST)));
              } else {
                setState(() {
                  activeTab = getIndex(context, title);
                });
              }
            }),
        child: const SizedBox.shrink(),
      ),
    );
  }

  int getIndex(BuildContext context, String title) {
    if (title.contains(S.of(context).preload_page1)) {
      return 0;
    } else if (title.contains(S.of(context).page3)) {
      return 1;
    } else if (title.contains(S.of(context).preload_page2)) {
      return 2;
    }
    return 0;
  }
}
