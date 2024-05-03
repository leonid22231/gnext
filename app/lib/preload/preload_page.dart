import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/auth/login_page.dart';
import 'package:app/auth/register_page.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/seconds/chat_preview.dart';
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
  int activeTab = 0;
  final GlobalKey<SliderDrawerState> _sliderDrawerKey = GlobalKey<SliderDrawerState>();
  final GlobalKey<TransportationPageState> _transportationKey = GlobalKey<TransportationPageState>();
  String selectTab = "";
  List<String> pages = [];
  @override
  Widget build(BuildContext context) {
    pages = [
      S.of(context).page1,
      S.of(context).page4,
      S.of(context).page5,
      S.of(context).page6,
      S.of(context).page8,
      S.of(context).page11,
    ];
    selectTab = pages[activeTab];
    return Scaffold(
      body: SliderDrawer(
        key: _sliderDrawerKey,
        sliderOpenSize: 80.w,
        appBar: SliderAppBar(appBarColor: Colors.white, appBarPadding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top), appBarHeight: 15.h, title: Text(selectTab, maxLines: 1, softWrap: false, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700))),
        slider: SliderBarMenuPreload(
            activeTab: selectTab,
            onClickItem: (title) {
              _sliderDrawerKey.currentState!.closeSlider();
              setState(() {
                activeTab = getIndex(context, title);
              });
            }),
        child: _body(activeTab),
      ),
    );
  }

  Widget _body(int index) {
    return ChatPreviewPage(title: selectTab);
  }

  int getIndex(BuildContext context, String title) {
    for (int i = 0; i < pages.length; i++) {
      if (pages[i] == title) {
        debugPrint("Index id $i");
        return i;
      }
    }
    debugPrint("Index id 0");
    return 0;
  }
}
