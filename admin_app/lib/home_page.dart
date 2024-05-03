import 'dart:async';

import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/auth/login_page.dart';
import 'package:admin_app/pages/control_chatfilter_page.dart';
import 'package:admin_app/pages/control_chats_page.dart';
import 'package:admin_app/pages/control_companies_page.dart';
import 'package:admin_app/pages/control_location_page.dart';
import 'package:admin_app/pages/control_users_page.dart';
import 'package:admin_app/pages/control_wallet_page.dart';
import 'package:admin_app/utils/ActionModel.dart';
import 'package:admin_app/utils/StatisticModel.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:text_scroll/text_scroll.dart';

class HomePage extends StatefulWidget {
  UserEntity user;
  HomePage({required this.user, super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List<ActionModel> actions = [];
  @override
  Widget build(BuildContext context) {
    actions = [
      ActionModel(name: "Локации", description: "Здесь вы можете управлять странами и городами", icon: Icons.location_city_outlined, child: ControlLocationPage()),
      ActionModel(name: "Управление пользователями", description: "Здесь вы можете управлять пользователями сервиса", icon: Icons.person, child: ControlUsersPage()),
      ActionModel(
          name: "Чаты",
          description: "Здесь вы можете управлять чатами",
          icon: Icons.chat_outlined,
          child: ControlLocationPage(
            selectMode: true,
          ),
          secondChild: ControlChatsPage),
      ActionModel(
          name: "Компании",
          description: "Здесь вы можете управлять компаниями",
          icon: Icons.featured_play_list_outlined,
          child: ControlLocationPage(
            selectMode: true,
          ),
          secondChild: ControlCompaniesPage),
      ActionModel(name: "Фильтр чата", description: "Здесь вы можете добавить слова, которые запрещены в чате", icon: Icons.filter_alt_outlined, child: ControlChatFilterPage()),
      ActionModel(
          name: "Кошельки",
          description: "Здесь вы можете управлять кошельками пользователей",
          icon: Icons.wallet_outlined,
          child: ControlUsersPage(
            selectMode: true,
          ),
          secondChild: ControlWalletPage),
    ];
    UserEntity user = widget.user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Админ панель GNext",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: mainColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(15), boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                          child: Padding(
                            padding: EdgeInsets.all(2.h),
                            child: Column(
                              children: [
                                ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(10.w), // Image radius
                                    child: Image.network(getUserPhoto(), fit: BoxFit.cover),
                                  ),
                                ),
                                Text(
                                  "${user.name} ${user.surname}",
                                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text(
                                  "+${user.phone}",
                                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Container(
                                  height: 4.h,
                                  width: 20.w,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Color(0xFFAEB4B7), width: 0.3.w)),
                                  child: Center(
                                    child: Text(
                                      getRole(user.role),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                InkWell(
                                  onTap: () async {
                                    uid = "";
                                    name = "";
                                    surname = "";
                                    image = null;
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                                  },
                                  child: Container(
                                    height: 4.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.red),
                                    child: Center(
                                      child: Text(
                                        "Выход",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 2.w,
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(15), boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                          child: Padding(
                            padding: EdgeInsets.all(2.h),
                            child: FutureBuilder(
                              future: getStat(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  StatisticModel stat = snapshot.data!;
                                  return Column(
                                    children: [
                                      Text(
                                        "Статистика:",
                                        style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      _value("Всего пользователей", "${stat.userCount}"),
                                      _value("Чаты", "${stat.chatCount}"),
                                      _value("Сообщения", "${stat.messagesCount}"),
                                      _value("Страны", "${stat.countryCount}"),
                                      _value("Города", "${stat.cityCount}"),
                                      _value("Все заказы", "${stat.allOrders}"),
                                      _value("Активные заказы", "${stat.activeOrders}"),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Text(
                                        "Статистика:",
                                        style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      _value("Всего пользователей", "100"),
                                      _value("Чаты", "100"),
                                      _value("Сообщения", "100"),
                                      _value("Страны", "2"),
                                      _value("Города", "2"),
                                      _value("Все заказы", "2"),
                                      _value("Активные заказы", "2"),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 8.h,
                width: double.maxFinite,
                decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(50), boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
                child: Center(
                  child: Text(
                    "Возможности",
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                child: Builder(builder: (context) {
                  double max = 100.w - 4.w;
                  int count = (max / 30.w).floor();
                  return GridView.count(
                    primary: false,
                    crossAxisCount: count,
                    crossAxisSpacing: 2.w,
                    mainAxisSpacing: 2.w,
                    shrinkWrap: true,
                    children: actions.map((e) => action(e.icon, e.name, e.description, e.child, e.secondChild)).toList(),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget action(IconData icon, String name, String description, StatefulWidget child, var secondChild) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => child)).then((value) {
          if (secondChild != null) {
            if (secondChild == ControlChatsPage && value != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ControlChatsPage(
                            city: value,
                          )));
            } else if (secondChild == ControlCompaniesPage && value != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ControlCompaniesPage(
                            city: value,
                          )));
            } else if (secondChild == ControlWalletPage && value != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ControlWalletPage(
                            user: value,
                          )));
            }
          }
          setState(() {});
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            children: [
              Icon(
                icon,
                size: 6.w,
                color: Colors.white,
              ),
              SizedBox(
                height: 3.h,
                child: TextScroll(
                  name,
                  mode: TextScrollMode.endless,
                  velocity: const Velocity(pixelsPerSecond: Offset(100, 0)),
                  delayBefore: const Duration(milliseconds: 500),
                  numberOfReps: 3,
                  pauseBetween: const Duration(milliseconds: 50),
                  style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16.sp),
                  textAlign: TextAlign.center,
                  selectable: false,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                  child: Text(
                "*$description",
                style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.8)),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<StatisticModel> getStat() {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.getStat();
  }

  Widget _value(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$name:",
          style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
