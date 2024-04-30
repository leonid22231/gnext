import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/profile_page.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SliderBarMenu extends StatelessWidget{
  final ValueNotifier imageValue = ValueNotifier(GlobalsWidgets.image);
  final Function(String title) onClickItem;
  final String activeTab;
  final UserEntity userEntity;
  SliderBarMenu({required this.onClickItem,required this.activeTab,required this.userEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: GlobalsColor.blue,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w, bottom: 5.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> ProfilePage(user: userEntity,))
                      ).then((value) => imageValue.value = GlobalsWidgets.image);
                    },
                    child: Row(
                      children: [
                        ValueListenableBuilder(valueListenable: imageValue, builder: (contex,s, values){
                          return ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(25), // Image radius
                              child: Image.network(GlobalsWidgets.getUserPhoto(), fit: BoxFit.cover),
                            ),
                          );
                        }),
                        SizedBox(width: 3.w,),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("${userEntity.name} ${userEntity.surname}", textAlign: TextAlign.start,style: TextStyle(fontSize: 14.sp,color: Colors.white),),
                                      userEntity.subscription?Text(" [PLUS]", textAlign: TextAlign.start,style: TextStyle(fontSize: 14.sp,color: Color(0xffFFD700), fontWeight: FontWeight.bold)):SizedBox.shrink()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.wallet_outlined, color: Colors.white,size: 5.w,),
                                      SizedBox(width: 1.w,),
                                      Text("${userEntity.wallet.round()} ₸",style: TextStyle(fontSize: 14.sp,color: Colors.white))
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                        SizedBox(width: 3.w,),
                        Container(
                          height: 10.w,
                          width: 10.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white
                          ),
                          child: Center(
                            child: Icon(Icons.notifications_none,),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h,),
                  Row(
                    children: [
                      Icon(Icons.location_history, color: Colors.white,),
                      SizedBox(width: 2.w,),
                      Text(userEntity.location.city.name, style: TextStyle(fontSize: 14.sp,color: Colors.white))
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h,),
          GestureDetector(
            onTap: (){
              onClickItem.call("Чат");
            },
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: GlobalsColor.blue
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, color: Colors.white,),
                  SizedBox(width: 2.w,),
                  Text(S.of(context).chat,style: TextStyle(fontSize: 16.sp,color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h,),
          ...[
            userEntity.role==UserRole.USER?Menu(Image.asset("assets/icon 0.png"), S.of(context).page1):null,
            userEntity.role==UserRole.SPECIALIST?Menu(Image.asset("assets/icon 1.png"), S.of(context).page2):null,
            Menu(Image.asset("assets/icon 2.png"), S.of(context).page3),
            Menu(Image.asset("assets/icon 3.png"), S.of(context).page4),
            Menu(Image.asset("assets/icon 4.png"), S.of(context).page5),
            Menu(Image.asset("assets/icon 5.png"), S.of(context).page6),
            Menu(Image.asset("assets/icon 6.png"), S.of(context).page7),
            Menu(Image.asset("assets/icon 7.png"), S.of(context).page8),
            Menu(Image.asset("assets/icon 8.png"), S.of(context).page11),
            Menu(Image.asset("assets/icon 8.png"), S.of(context).page9),
            Menu(Image.asset("assets/icon 9.png"), S.of(context).page10),
          ]
              .map((menu) => menu!=null?_SliderMenuItem(
              title: menu.title,
              isSelected: activeTab.contains(menu.title),
              iconData: menu.iconData,
              onTap: onClickItem):SizedBox.shrink())
              .toList(),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final Image iconData;
  final Function(String)? onTap;
  final bool isSelected;
  const _SliderMenuItem(
      {Key? key,
        required this.title,
        required this.iconData,
        required this.isSelected,
        required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(isSelected)
    print("${title} ${isSelected}");
    return ListTile(
        selected: isSelected,
        selectedTileColor: Colors.blue.withOpacity(0.3),
        title: Text(title,
            style: TextStyle(
                color: Colors.black,fontSize: 15.sp, fontWeight: FontWeight.bold)),
        leading: iconData,
        onTap: () => onTap?.call(title));
  }
}
class Menu {
  final Image iconData;
  final String title;
  Menu(this.iconData, this.title);
}