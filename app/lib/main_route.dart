import 'dart:io';

import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/Categories.dart';
import 'package:app/api/entity/enums/Mode.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/chats/ChatPage.dart';
import 'package:app/pages/catalog_page.dart';
import 'package:app/pages/search_page.dart';
import 'package:app/pages/search_transportation_page.dart';
import 'package:app/pages/seconds/chat_page.dart';
import 'package:app/pages/seconds/create_cargo.dart';
import 'package:app/pages/seconds/create_shop.dart';
import 'package:app/pages/seconds/create_transportation_page.dart';
import 'package:app/pages/transportation_page.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:app/utils/SliderBarMenu.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key, required this.userEntity});
  final UserEntity userEntity;
  @override
  State<StatefulWidget> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int activeTab = 0;
  final GlobalKey<SliderDrawerState> _sliderDrawerKey = GlobalKey<SliderDrawerState>();
  final GlobalKey<TransportationPageState> _transportationKey = GlobalKey<TransportationPageState>();
  final GlobalKey<CatalogPageState> _shopKey = GlobalKey<CatalogPageState>();
  String selectTab = "";
  List<String> pages = [];
  Mode selectedMode = Mode.CITY;
  Mode selectedModeEv = Mode.CITY;
  File? file;
  @override
  Widget build(BuildContext context) {
    pages = [S.of(context).page1, S.of(context).page2, S.of(context).page3, S.of(context).page4, S.of(context).page5, S.of(context).page6, S.of(context).page8, S.of(context).page11, "Чат"];
    if (widget.userEntity.role == UserRole.SPECIALIST && activeTab == 0) {
      activeTab = 1;
    }
    selectTab = pages[activeTab];
    return Scaffold(
      floatingActionButton: _getFloatButton(getIndex(context, selectTab)),
      body: SliderDrawer(
        key: _sliderDrawerKey,
        sliderOpenSize: 80.w,
        appBar: SliderAppBar(appBarColor: Colors.white, appBarPadding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top), appBarHeight: 15.h, title: Text(selectTab, maxLines: 1, softWrap: false, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700))),
        slider: SliderBarMenu(
            userEntity: widget.userEntity,
            activeTab: selectTab,
            onClickItem: (title) {
              _sliderDrawerKey.currentState!.closeSlider();
              setState(() {
                activeTab = getIndex(context, title);
              });
            }),
        child: Builder(builder: (context) => _buildWidget(context, selectTab)),
      ),
    );
  }

  void addCompany(Categories category) {
    String? temp_name;
    String? temp_phone;
    String? temp_street;
    String? temp_house;
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, state) {
              return AlertDialog(
                title: Text(
                  "Добавить комапнию",
                  style: TextStyle(fontSize: 18.sp),
                ),
                content: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Название",
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        SizedBox(
                          height: 8.h,
                          child: TextFormField(
                            onChanged: (value) {
                              temp_name = value;
                            },
                            style: TextStyle(fontSize: 16.sp),
                            decoration: InputDecoration(
                              hintText: "Введите название города",
                              hintStyle: TextStyle(fontSize: 16.sp),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Номер телефона",
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        SizedBox(
                          height: 8.h,
                          child: TextFormField(
                            onChanged: (value) {
                              temp_phone = value;
                            },
                            style: TextStyle(fontSize: 16.sp),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                            ],
                            decoration: InputDecoration(
                              hintText: "Введите номер телефона",
                              hintStyle: TextStyle(fontSize: 16.sp),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Адрес",
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Улица",
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        SizedBox(
                          height: 8.h,
                          child: TextFormField(
                            onChanged: (value) {
                              temp_street = value;
                            },
                            style: TextStyle(fontSize: 16.sp),
                            decoration: InputDecoration(
                              hintText: "Введите название",
                              hintStyle: TextStyle(fontSize: 16.sp),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Номер дома",
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        SizedBox(
                          height: 8.h,
                          child: TextFormField(
                            onChanged: (value) {
                              temp_house = value;
                            },
                            style: TextStyle(fontSize: 16.sp),
                            decoration: InputDecoration(
                              hintText: "Введите номер дома",
                              hintStyle: TextStyle(fontSize: 16.sp),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                            ),
                          ),
                        ),
                        category == Categories.auto
                            ? Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 6.h,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(backgroundColor: const Color(0xff317EFA), side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final XFile? image = await picker.pickImage(source: ImageSource.gallery, preferredCameraDevice: CameraDevice.rear);
                                      if (image != null) {
                                        file = File.fromUri(Uri.parse(image.path));
                                      }
                                    },
                                    child: const Text(
                                      "Добавить фото",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(S.of(context).cancel, style: TextStyle(color: GlobalsColor.blue, fontSize: 14.sp))),
                              SizedBox(
                                width: 5.w,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Dio dio = Dio();
                                    RestClient client = RestClient(dio);
                                    String ph = "";
                                    if (temp_phone![0].contains("8")) {
                                      ph += temp_phone!.replaceFirst("8", "7");
                                    }
                                    client.createCompany(GlobalsWidgets.uid, category, temp_name!, ph, temp_street!, temp_house!, file).then((value) => Navigator.pop(context));
                                  },
                                  child: Text(
                                    S.of(context).add,
                                    style: TextStyle(color: GlobalsColor.blue, fontSize: 14.sp),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            })).then((value) {
      setState(() {});
    });
  }

  Widget? _getFloatButton(int index) {
    //spr
    if (index == 3) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomChatPage(
                            showTitle: true,
                            title: pages[index],
                            history: true,
                            chatName: "spr",
                            subscription: widget.userEntity.subscription,
                          )));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
    //sto
    if (index == 4) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomChatPage(
                            showTitle: true,
                            title: pages[index],
                            history: true,
                            chatName: "sto",
                            subscription: widget.userEntity.subscription,
                          )));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          )
        ],
      );
    }
    //gaz
    if (index == 5) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomChatPage(
                            showTitle: true,
                            title: pages[index],
                            history: true,
                            chatName: "gaz",
                            subscription: widget.userEntity.subscription,
                          )));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          )
        ],
      );
    }
    //swap
    if (index == 7) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomChatPage(
                            showTitle: true,
                            title: pages[index],
                            history: true,
                            chatName: "swap",
                            subscription: widget.userEntity.subscription,
                          )));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          )
        ],
      );
    }
    //salon
    if (index == 10) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomChatPage(
                            showTitle: true,
                            title: pages[index],
                            history: true,
                            chatName: "salon",
                            subscription: widget.userEntity.subscription,
                          )));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          )
        ],
      );
    }
    //shop
    if (index == 8) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateShopPage())).then((value) {
                _shopKey.currentState?.update();
              });
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomChatPage(key: const Key("chat_3"), subscription: widget.userEntity.subscription, history: true, showTitle: true, title: S.of(context).page9, chatName: GlobalsWidgets.chats[2])));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
    if (index == 2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.userEntity.role == UserRole.USER
              ? FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => CreateTransportationPage(
                                  createMode: selectedModeEv,
                                )))
                        .then((value) {
                      _transportationKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  backgroundColor: const Color(0xff317EFA),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
          widget.userEntity.role == UserRole.USER
              ? SizedBox(
                  height: 2.h,
                )
              : const SizedBox.shrink(),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomChatPage(key: const Key("chat_1"), subscription: widget.userEntity.subscription, history: true, showTitle: true, title: S.of(context).page3, chatName: GlobalsWidgets.chats[0])));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          )
        ],
      );
    }
    if (index == 1 || index == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          getIndex(context, selectTab) == 0
              ? FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => CreateCargoPage(
                                  mode: selectedMode,
                                )))
                        .then((value) {
                      _transportationKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  backgroundColor: const Color(0xff317EFA),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              switch (selectedMode) {
                case Mode.CITY:
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomChatPage(
                                  showTitle: true,
                                  title: S.of(context).option2,
                                  history: true,
                                  chatName: "city",
                                  subscription: widget.userEntity.subscription,
                                )));
                    break;
                  }
                case Mode.OUTCITY:
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomChatPage(showTitle: true, title: S.of(context).option1, history: true, chatName: "outcity", subscription: widget.userEntity.subscription)));
                    break;
                  }
              }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          )
        ],
      );
    }
    return null;
  }

  int getIndex(BuildContext context, String title) {
    for (int i = 0; i < pages.length; i++) {
      if (pages[i] == title) {
        return i;
      }
    }
    return 0;
  }

  Widget _buildWidget(BuildContext context, String title) {
    if (title.contains(S.of(context).page1)) {
      return NotificationListener<ChangeModeNotify>(
          onNotification: (m) {
            selectedMode = m.mode;
            setState(() {});
            return true;
          },
          child: TransportationPage(
            sub: widget.userEntity.subscription,
            key: _transportationKey,
          ));
    } else if (title.contains(S.of(context).page2)) {
      return NotificationListener<ChangeModeNotify>(
          onNotification: (m) {
            selectedMode = m.mode;
            setState(() {});
            return true;
          },
          child: const SearchPage());
    } else if (title.contains(S.of(context).page3)) {
      return NotificationListener<ChangeTransportModeNotify>(
          onNotification: (m) {
            selectedModeEv = m.mode;
            setState(() {});
            return true;
          },
          child: const SearchTransportationPage());
    } else if (title.contains(S.of(context).page4)) {
      return const CatalogPage(
        category: Categories.info,
      );
    } else if (title.contains(S.of(context).page5)) {
      return const CatalogPage(
        category: Categories.sto,
      );
    } else if (title.contains(S.of(context).page6)) {
      return const CatalogPage(
        category: Categories.modify,
      );
    } else if (title.contains(S.of(context).page7)) {
      return CustomChatPage(key: const Key("chat_2"), subscription: widget.userEntity.subscription, history: true, showTitle: false, title: S.of(context).page7, chatName: GlobalsWidgets.chats[1]);
    } else if (title.contains(S.of(context).page8)) {
      return const CatalogPage(
        category: Categories.swap,
      );
    } else if (title.contains(S.of(context).page9)) {
      return CatalogPage(key: _shopKey, category: Categories.shop);
    } else if (title.contains(S.of(context).page10)) {
      return CustomChatPage(key: const Key("chat_4"), subscription: widget.userEntity.subscription, history: true, showTitle: false, title: S.of(context).page10, chatName: GlobalsWidgets.chats[4]);
    } else if (title.contains(S.of(context).page11)) {
      return const CatalogPage(
        category: Categories.auto,
      );
    } else if (title.contains("Чат")) {
      return ChatPage(
        user: widget.userEntity,
      );
    }

    return const SizedBox.shrink();
  }
}
