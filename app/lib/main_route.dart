import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/Categories.dart';
import 'package:app/api/entity/enums/Mode.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/chats/ChatPage.dart';
import 'package:app/pages/catalog_page.dart';
import 'package:app/pages/search_page.dart';
import 'package:app/pages/seconds/chat_page.dart';
import 'package:app/pages/seconds/create_cargo.dart';
import 'package:app/pages/transportation_page.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:app/utils/SliderBarMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainRoute extends StatefulWidget{
  const MainRoute({super.key, required this.userEntity});
  final UserEntity userEntity;
  @override
  State<StatefulWidget> createState() => _MainRouteState();

}
class _MainRouteState extends State<MainRoute>{
  int activeTab = 0;
  final GlobalKey<SliderDrawerState> _sliderDrawerKey = GlobalKey<SliderDrawerState>();
  final GlobalKey<TransportationPageState> _transportationKey = GlobalKey<TransportationPageState>();
  String selectTab = "";
  List<String> pages = [];
  Mode selectedMode = Mode.CITY;
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    pages = [
      S.of(context).page1,
      S.of(context).page2,
      S.of(context).page3,
      S.of(context).page4,
      S.of(context).page5,
      S.of(context).page6,
      S.of(context).page7,
      S.of(context).page8,
      S.of(context).page9,
      S.of(context).page10,
      S.of(context).page11,
      "Чат"
    ];
    if(widget.userEntity.role==UserRole.SPECIALIST && activeTab==0){
      activeTab = 1;
    }
    selectTab = pages[activeTab];
    return Scaffold(
      floatingActionButton: _getFloatButton(getIndex(context, selectTab)),
      body: SliderDrawer(
          key: _sliderDrawerKey,
          sliderOpenSize: 80.w,
          appBar: SliderAppBar(
              appBarColor: Colors.white,
              appBarPadding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
              appBarHeight: 15.h,
              title: Text(selectTab,maxLines: 1,softWrap: false,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700))),
          slider: SliderBarMenu(
            userEntity: widget.userEntity,
              activeTab: selectTab,
              onClickItem: (title){
                _sliderDrawerKey.currentState!.closeSlider();
                setState(() {
                  activeTab = getIndex(context, title);
                });
              }),
          child: Builder(builder: (context)=>_buildWidget(context, selectTab)),
        ),
    );
  }
  Widget? _getFloatButton(int index){
    //spr
    if(index == 3){
      return FloatingActionButton(
        heroTag: "btn2",
        onPressed: (){
          Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: pages[index],history: true, chatName: "spr", readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription,)));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        backgroundColor: const Color(0xff317EFA),
        child: const Icon(Icons.chat, color: Colors.white,),
      );
    }
    //sto
    if(index == 4){
      return FloatingActionButton(
        heroTag: "btn2",
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: pages[index],history: true, chatName: "sto", readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription,)));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        backgroundColor: const Color(0xff317EFA),
        child: const Icon(Icons.chat, color: Colors.white,),
      );
    }
    //gaz
    if(index == 5){
      return FloatingActionButton(
        heroTag: "btn2",
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: pages[index],history: true, chatName: "gaz", readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription,)));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        backgroundColor: const Color(0xff317EFA),
        child: const Icon(Icons.chat, color: Colors.white,),
      );
    }
    //swap
    if(index == 7){
      return FloatingActionButton(
        heroTag: "btn2",
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: pages[index],history: true, chatName: "swap", readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription,)));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        backgroundColor: const Color(0xff317EFA),
        child: const Icon(Icons.chat, color: Colors.white,),
      );
    }
    //salon
    if(index == 10){
      return FloatingActionButton(
        heroTag: "btn2",
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: pages[index],history: true, chatName: "salon", readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription,)));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        backgroundColor: const Color(0xff317EFA),
        child: const Icon(Icons.chat, color: Colors.white,),
      );
    }
    if(index == 1 || index == 0){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          getIndex(context, selectTab)==0?FloatingActionButton(
            heroTag: "btn1",
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder:(context)=> CreateCargoPage(mode: selectedMode,))
              ).then((value){
                _transportationKey.currentState?.update();
              });
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
            ),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(Icons.add, color: Colors.white,),
          ):const SizedBox.shrink(),
          SizedBox(height: 2.h,),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: (){
              switch(selectedMode){
                case Mode.CITY: {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: "По городу",history: true, chatName: "city", readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription,)));
                  break;
                }
                case Mode.OUTCITY: {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: "Межгород",history: true, chatName: "outcity", readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription)));
                  break;
                }
              }
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
            ),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(Icons.chat, color: Colors.white,),
          )
        ],
      );
    }
    return null;
  }
  int getIndex(BuildContext context, String title){
    if(title.contains(S.of(context).page1)){
      return 0;
    }else if(title.contains(S.of(context).page2)){
      return 1;
    }else if(title.contains(S.of(context).page3)){
      return 2;
    }else if(title.contains(S.of(context).page4)){
      return 3;
    }else if(title.contains(S.of(context).page5)){
      return 4;
    }else if(title.contains(S.of(context).page6)){
      return 5;
    }else if(title.contains(S.of(context).page7)){
      return 6;
    }else if(title.contains(S.of(context).page8)){
      return 7;
    }else if(title.contains(S.of(context).page9)){
      return 8;
    }else if(title.contains(S.of(context).page10)){
      return 9;
    }else if(title.contains(S.of(context).page11)){
      return 10;
    }else if(title.contains("Чат")){
      return 11;
    }
    return 0;
  }
  Widget _buildWidget(BuildContext context, String title){
    if(title.contains(S.of(context).page1)){
      return NotificationListener<ChangeModeNotify>(
          onNotification: (m){
            selectedMode = m.mode;
            setState(() {

            });
            return true;
          },child: TransportationPage(key: _transportationKey,))
      ;
    }else if(title.contains(S.of(context).page2)){
      return NotificationListener<ChangeModeNotify>(
          onNotification: (m){
            selectedMode = m.mode;
            setState(() {

            });
            return true;
          },child: const SearchPage());
    }else if(title.contains(S.of(context).page3)){
      return CustomChatPage(key: const Key("chat_1"),readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription,history: true,showTitle: false, title: S.of(context).page3, chatName: GlobalsWidgets.chats[0]);
    }else if(title.contains(S.of(context).page4)){
      return CatalogPage(category: Categories.info,);
    }else if(title.contains(S.of(context).page5)){
      return CatalogPage(category: Categories.sto,);
    }else if(title.contains(S.of(context).page6)){
      return CatalogPage(category: Categories.modify,);
    }else if(title.contains(S.of(context).page7)){
      return CustomChatPage(key: const Key("chat_2"),readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription,history: true,showTitle: false, title: S.of(context).page7, chatName: GlobalsWidgets.chats[1]);
    }else if(title.contains(S.of(context).page8)){
      return CatalogPage(category: Categories.swap,);
    }else if(title.contains(S.of(context).page9)){
      return CustomChatPage(key: const Key("chat_3"),readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription,history: true,showTitle: false, title: S.of(context).page9, chatName: GlobalsWidgets.chats[2]);
    }else if(title.contains(S.of(context).page10)){
      return CustomChatPage(key: const Key("chat_4"),readOnlyUser: UserRole.SPECIALIST,subscription: widget.userEntity.subscription,history: true,showTitle: false, title: S.of(context).page10, chatName: GlobalsWidgets.chats[4]);
    }else if(title.contains(S.of(context).page11)){
      return CatalogPage(category: Categories.auto,);
    }else if(title.contains("Чат")){
      return ChatPage(user: widget.userEntity,);
    }

    return const SizedBox.shrink();
  }
}
