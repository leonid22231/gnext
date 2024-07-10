import 'dart:developer';
import 'dart:math';
import 'dart:ui';

import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/OrderEntity.dart';
import 'package:app/api/entity/PropertiesEntity.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/auth/login_page.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatPreviewPage extends StatefulWidget {
  final String title;
  const ChatPreviewPage({required this.title, super.key});

  @override
  State<StatefulWidget> createState() => ChatePreviewPageState();
}

class ChatePreviewPageState extends State<ChatPreviewPage> {
  bool click = false;
  @override
  Widget build(BuildContext context) {
    CityEntity city = CityEntity(id: 0, name: "");
    AddressEntity addressEntityTo1 = AddressEntity(0, "Лесная", "8", "");
    AddressEntity addressEntityFrom1 = AddressEntity(0, "Каурова", "152", "");
    AddressEntity addressEntityTo2 = AddressEntity(0, "Каурова", "152", "");
    AddressEntity addressEntityFrom2 = AddressEntity(0, "Лесная", "8", "");
    AddressEntity addressEntityTo3 = AddressEntity(0, "Бабкина", "2", "");
    AddressEntity addressEntityFrom3 = AddressEntity(0, "Шышкина", "12", "");
    AddressEntity addressEntityTo4 =
        AddressEntity(0, "Проспект мира", "15", "");
    AddressEntity addressEntityFrom4 =
        AddressEntity(0, "Партина железняка", "45", "");
    AddressEntity addressEntityTo5 = AddressEntity(0, "9 мая", "13", "");
    AddressEntity addressEntityFrom5 = AddressEntity(0, "Пензина", "231", "");
    AddressEntity addressEntityTo6 = AddressEntity(0, "Улица", "Дом", "");
    AddressEntity addressEntityFrom6 = AddressEntity(0, "Улица", "Дом", "");
    UserEntity creator = UserEntity(
        id: 0,
        uid: "",
        name: "",
        surname: "",
        phone: "",
        city: city,
        role: UserRole.USER,
        wallet: 0,
        subscription: false);
    List<OrderEntity> list = [
      OrderEntity(
          id: 0,
          creator: creator,
          city: city,
          addressTo: addressEntityTo1,
          addressFrom: addressEntityFrom1,
          price: Random().nextDouble() * 1000,
          customPrice: true,
          outCity: false,
          active: true,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          createDate: DateTime.now()),
      OrderEntity(
          id: 0,
          creator: creator,
          city: city,
          addressTo: addressEntityTo2,
          addressFrom: addressEntityFrom2,
          price: Random().nextDouble() * 1000,
          customPrice: true,
          outCity: false,
          active: true,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          createDate: DateTime.now()),
      OrderEntity(
          id: 0,
          creator: creator,
          city: city,
          addressTo: addressEntityTo3,
          addressFrom: addressEntityFrom3,
          price: Random().nextDouble() * 10000,
          customPrice: true,
          outCity: false,
          active: true,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          createDate: DateTime.now()),
      OrderEntity(
          id: 0,
          creator: creator,
          city: city,
          addressTo: addressEntityTo4,
          addressFrom: addressEntityFrom4,
          price: Random().nextDouble() * 1000,
          customPrice: true,
          outCity: false,
          active: true,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          createDate: DateTime.now()),
      OrderEntity(
          id: 0,
          creator: creator,
          city: city,
          addressTo: addressEntityTo5,
          addressFrom: addressEntityFrom5,
          price: Random().nextDouble() * 1000,
          customPrice: true,
          outCity: false,
          active: true,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          createDate: DateTime.now()),
      OrderEntity(
          id: 0,
          creator: creator,
          city: city,
          addressTo: addressEntityTo6,
          addressFrom: addressEntityFrom6,
          price: Random().nextDouble() * 1000,
          customPrice: true,
          outCity: false,
          active: true,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          createDate: DateTime.now())
    ];
    return Stack(
      children: [
        SizedBox(
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: ListView.separated(
              itemCount: list.length,
              itemBuilder: (context, index) {
                OrderEntity order = list[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      click = true;
                    });
                  },
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: GlobalsColor.userCardColor),
                    child: Padding(
                      padding: EdgeInsets.all(2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${order.addressFrom.street}${order.addressFrom.house != null ? "," : ""} ${order.addressFrom.house ?? ""} ->",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${order.price.round()} ₸",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Text(
                                  "${order.addressTo.street}${order.addressFrom.street != null ? "," : ""} ${order.addressTo.house ?? ""}",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${DateFormat("dd EE.").format(order.startDate.toLocal())} - ${DateFormat("dd EE, MMM").format(order.endDate.toLocal())}",
                                style: TextStyle(
                                    color: const Color(0xffCFCFCF),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat("dd MMM")
                                    .format(order.createDate.toLocal()),
                                style: TextStyle(
                                    color: const Color(0xffCFCFCF),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 2.h,
                );
              },
            ),
          ),
        ),
        click
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    click = false;
                  });
                },
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child:
                        const Opacity(opacity: 0.01, child: SizedBox.expand()),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        click
            ? InkWell(
                onTap: () {
                  setState(() {
                    click = false;
                  });
                },
                child: SizedBox(
                  height: 100.h,
                  width: 100.w,
                ),
              )
            : SizedBox.shrink(),
        click
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: Center(
                  child: Text(
                    S.of(context).register_please,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
