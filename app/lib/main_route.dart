import 'dart:developer';
import 'dart:io';

import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/Categories.dart';
import 'package:app/api/entity/enums/Mode.dart';
import 'package:app/api/entity/enums/OrderMode.dart';
import 'package:app/api/entity/enums/TransportationCategory.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/assen_transport_page.dart';
import 'package:app/pages/auto_transport_page.dart';
import 'package:app/pages/chats/ChatPage.dart';
import 'package:app/pages/catalog_page.dart';
import 'package:app/pages/ex_transport_page.dart';
import 'package:app/pages/man_transport_page.dart';
import 'package:app/pages/pog_transport_page.dart';
import 'package:app/pages/sam_transport_page.dart';
import 'package:app/pages/search_page.dart';
import 'package:app/pages/search_transportation_page.dart';
import 'package:app/pages/seconds/chat_page.dart';
import 'package:app/pages/seconds/create_cargo.dart';
import 'package:app/pages/seconds/create_order_taxi.dart';
import 'package:app/pages/seconds/create_service.dart';
import 'package:app/pages/seconds/create_shop.dart';
import 'package:app/pages/seconds/create_transportation_page.dart';
import 'package:app/pages/seconds/my_services_page.dart';
import 'package:app/pages/seconds/my_taxi_orders.dart';
import 'package:app/pages/taxi_page.dart';
import 'package:app/pages/transportation_page.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:app/utils/SliderBarMenu.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  final GlobalKey<TransportationPageState> _transportationKey =
      GlobalKey<TransportationPageState>();

  final GlobalKey<TaxiPageState> _taxiKey = GlobalKey<TaxiPageState>();
  final GlobalKey<ManTransportPageState> _manKey =
      GlobalKey<ManTransportPageState>();
  final GlobalKey<ExTransportPageState> _exKey =
      GlobalKey<ExTransportPageState>();
  final GlobalKey<SamTransportPageState> _samKey =
      GlobalKey<SamTransportPageState>();
  final GlobalKey<AutoTransportPageState> _autoKey =
      GlobalKey<AutoTransportPageState>();
  final GlobalKey<PogTransportPageState> _pogKey =
      GlobalKey<PogTransportPageState>();

  final GlobalKey<AssenTransportPageState> _assenKey =
      GlobalKey<AssenTransportPageState>();
  String selectTab = "";
  List<String> pages = [];
  Mode selectedMode = Mode.CITY;
  Mode selectedModeEv = Mode.CITY;
  Mode selectedModeTaxi = Mode.OUTCITY;
  Mode selectedModeMan = Mode.CITY;
  Mode selectedModeAssen = Mode.CITY;
  //only
  Mode selectedModeEx = Mode.CITY;
  //only
  Mode selectedModeAuto = Mode.OUTCITY;
  Mode selectedModeSam = Mode.CITY;
  //only
  Mode selectedModePog = Mode.CITY;
  File? file;

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
      S.of(context).page11,
      S.of(context).page12,
      S.of(context).page13,
      "Чат"
    ];
    if (widget.userEntity.role == UserRole.SPECIALIST && activeTab == 0) {
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
            appBarPadding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            appBarHeight: 15.h,
            title: Text(selectTab,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700))),
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

  Widget? _getFloatButton(int index) {
    log("Index $index");

    //манипулятор
    if (index == 3 && widget.userEntity.role == UserRole.USER) {
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
                                  category: TransportationCategory.man,
                                  city: widget.userEntity.city,
                                  createMode: selectedModeMan,
                                )))
                        .then((value) {
                      _manKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: const Color(0xff317EFA),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    } else if (index == 3 &&
        selectedModeMan == Mode.NONE &&
        widget.userEntity.role == UserRole.SPECIALIST) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            label: const Text(
              "Мои услуги",
              style: TextStyle(color: Colors.white),
            ),
            heroTag: "btn3",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const MyServicesPage(
                            mode: OrderMode.MAN,
                          )))
                  .then((value) {
                _transportationKey.currentState?.update();
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          ),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateService(
                            city: widget.userEntity.city,
                            mode: OrderMode.MAN,
                          )));
            },
            label: SizedBox(
              width: 100.w - 20.w,
              child: const Center(
                child: Text(
                  "Создать услугу +",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          )
        ],
      );
    } else if (index == 3 &&
        widget.userEntity.role == UserRole.SPECIALIST &&
        selectedModeMan != Mode.NONE) {
      return null;
    }
    //эксковатор
    if (index == 6 && widget.userEntity.role == UserRole.USER) {
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
                                  category: TransportationCategory.ex,
                                  city: widget.userEntity.city,
                                  createMode: selectedModeEx,
                                  full: false,
                                )))
                        .then((value) {
                      _exKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: const Color(0xff317EFA),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    } else if (index == 6 &&
        selectedModeEx == Mode.NONE &&
        widget.userEntity.role == UserRole.SPECIALIST) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            label: const Text(
              "Мои услуги",
              style: TextStyle(color: Colors.white),
            ),
            heroTag: "btn3",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const MyServicesPage(
                            mode: OrderMode.EX,
                          )))
                  .then((value) {
                _transportationKey.currentState?.update();
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          ),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateService(
                            city: widget.userEntity.city,
                            mode: OrderMode.EX,
                          )));
            },
            label: SizedBox(
              width: 100.w - 20.w,
              child: const Center(
                child: Text(
                  "Создать услугу +",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          )
        ],
      );
    } else if (index == 6 &&
        widget.userEntity.role == UserRole.SPECIALIST &&
        selectedModeEx != Mode.NONE) {
      return null;
    }
    //самосвал
    if (index == 4 && widget.userEntity.role == UserRole.USER) {
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
                                  category: TransportationCategory.sam,
                                  city: widget.userEntity.city,
                                  createMode: selectedModeSam,
                                )))
                        .then((value) {
                      _samKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: const Color(0xff317EFA),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    } else if (index == 4 &&
        selectedModeSam == Mode.NONE &&
        widget.userEntity.role == UserRole.SPECIALIST) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            label: const Text(
              "Мои услуги",
              style: TextStyle(color: Colors.white),
            ),
            heroTag: "btn3",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const MyServicesPage(
                            mode: OrderMode.SAM,
                          )))
                  .then((value) {
                _transportationKey.currentState?.update();
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          ),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateService(
                            city: widget.userEntity.city,
                            mode: OrderMode.SAM,
                          )));
            },
            label: SizedBox(
              width: 100.w - 20.w,
              child: const Center(
                child: Text(
                  "Создать услугу +",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          )
        ],
      );
    } else if (index == 4 &&
        widget.userEntity.role == UserRole.SPECIALIST &&
        selectedModeSam != Mode.NONE) {
      return null;
    }
    //автовоз
    if (index == 5 && widget.userEntity.role == UserRole.USER) {
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
                                  category: TransportationCategory.auto,
                                  city: widget.userEntity.city,
                                  createMode: selectedModeAuto,
                                )))
                        .then((value) {
                      _autoKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: const Color(0xff317EFA),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    } else if (index == 5 &&
        selectedModeAuto == Mode.NONE &&
        widget.userEntity.role == UserRole.SPECIALIST) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            label: const Text(
              "Мои услуги",
              style: TextStyle(color: Colors.white),
            ),
            heroTag: "btn3",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const MyServicesPage(
                            mode: OrderMode.AUTO,
                          )))
                  .then((value) {
                _transportationKey.currentState?.update();
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          ),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateService(
                            city: widget.userEntity.city,
                            mode: OrderMode.AUTO,
                          )));
            },
            label: SizedBox(
              width: 100.w - 20.w,
              child: const Center(
                child: Text(
                  "Создать услугу +",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          )
        ],
      );
    } else if (index == 5 &&
        widget.userEntity.role == UserRole.SPECIALIST &&
        selectedModeAuto != Mode.NONE) {
      return null;
    }

    //погрузчик
    if (index == 7 && widget.userEntity.role == UserRole.USER) {
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
                                  category: TransportationCategory.pog,
                                  city: widget.userEntity.city,
                                  full: false,
                                  createMode: selectedModePog,
                                )))
                        .then((value) {
                      _pogKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: const Color(0xff317EFA),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    } else if (index == 7 &&
        selectedModePog == Mode.NONE &&
        widget.userEntity.role == UserRole.SPECIALIST) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            label: const Text(
              "Мои услуги",
              style: TextStyle(color: Colors.white),
            ),
            heroTag: "btn3",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const MyServicesPage(
                            mode: OrderMode.POG,
                          )))
                  .then((value) {
                _transportationKey.currentState?.update();
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          ),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateService(
                            city: widget.userEntity.city,
                            mode: OrderMode.POG,
                          )));
            },
            label: SizedBox(
              width: 100.w - 20.w,
              child: const Center(
                child: Text(
                  "Создать услугу +",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          )
        ],
      );
    } else if (index == 7 &&
        widget.userEntity.role == UserRole.SPECIALIST &&
        selectedModePog != Mode.NONE) {
      return null;
    }
    //taxi
    if (index == 9 && selectedModeTaxi != Mode.NONE) {
      log("Taxi mode $selectedModeTaxi");
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
                                  category: TransportationCategory.taxi,
                                  city: widget.userEntity.city,
                                  createMode: Mode.OUTCITY,
                                )))
                        .then((value) {
                      _taxiKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: const Color(0xff317EFA),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    } else if (index == 9 &&
        selectedModeTaxi == Mode.NONE &&
        widget.userEntity.role == UserRole.USER) {
      return FloatingActionButton.extended(
        label: const Text(
          "Мои заказы",
          style: TextStyle(color: Colors.white),
        ),
        heroTag: "btn3",
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const MyTaxiOrdersPage(
                        mode: OrderMode.TAXI,
                      )))
              .then((value) {
            _taxiKey.currentState?.update();
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: const Color(0xff317EFA),
      );
    } else if (index == 9 &&
        selectedModeTaxi == Mode.NONE &&
        widget.userEntity.role == UserRole.SPECIALIST) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            label: const Text(
              "Мои заказы",
              style: TextStyle(color: Colors.white),
            ),
            heroTag: "btn3",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const MyTaxiOrdersPage(
                            mode: OrderMode.TAXI,
                          )))
                  .then((value) {
                _transportationKey.currentState?.update();
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          ),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateOrderTaxi(
                            city: widget.userEntity.city,
                            mode: OrderMode.TAXI,
                          )));
            },
            label: SizedBox(
              width: 100.w - 20.w,
              child: const Center(
                child: Text(
                  "Создать заказ +",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          )
        ],
      );
    }
    //assen
    if (index == 10 && selectedModeAssen != Mode.NONE) {
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
                                  category: TransportationCategory.assen,
                                  city: widget.userEntity.city,
                                  createMode: selectedModeAssen,
                                )))
                        .then((value) {
                      _assenKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
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
          // FloatingActionButton(
          //   heroTag: "btn2",
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => CustomChatPage(
          //                 key: const Key("chat_1"),
          //                 subscription: widget.userEntity.subscription,
          //                 history: true,
          //                 showTitle: true,
          //                 title: S.of(context).page13,
          //                 chatName: GlobalsWidgets.chats[0])));
          //   },
          //   shape:
          //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          //   backgroundColor: const Color(0xff317EFA),
          //   child: const Icon(
          //     Icons.chat,
          //     color: Colors.white,
          //   ),
          // )
        ],
      );
    } else if (index == 10 &&
        selectedModeAssen == Mode.NONE &&
        widget.userEntity.role == UserRole.USER) {
      return FloatingActionButton.extended(
        label: const Text(
          "Мои заказы",
          style: TextStyle(color: Colors.white),
        ),
        heroTag: "btn3",
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const MyTaxiOrdersPage(
                        mode: OrderMode.ASSEN,
                      )))
              .then((value) {
            _assenKey.currentState?.update();
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: const Color(0xff317EFA),
      );
    } else if (index == 10 &&
        selectedModeAssen == Mode.NONE &&
        widget.userEntity.role == UserRole.SPECIALIST) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            label: const Text(
              "Мои услуги",
              style: TextStyle(color: Colors.white),
            ),
            heroTag: "btn3",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const MyServicesPage(
                            mode: OrderMode.ASSEN,
                          )))
                  .then((value) {
                _assenKey.currentState?.update();
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          ),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateService(
                            city: widget.userEntity.city,
                            mode: OrderMode.ASSEN,
                          )));
            },
            label: SizedBox(
              width: 100.w - 20.w,
              child: const Center(
                child: Text(
                  "Создать услугу +",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          )
        ],
      );
    }
    //eva
    if (index == 2 && selectedModeEv != Mode.NONE) {
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
                                  category: TransportationCategory.ev,
                                  city: widget.userEntity.city,
                                  createMode: selectedModeEv,
                                )))
                        .then((value) {
                      _transportationKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomChatPage(
                          key: const Key("chat_1"),
                          subscription: widget.userEntity.subscription,
                          history: true,
                          showTitle: true,
                          title: S.of(context).page3,
                          chatName: GlobalsWidgets.chats[0])));
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          )
        ],
      );
    } else if (index == 2 &&
        selectedModeEv == Mode.NONE &&
        widget.userEntity.role == UserRole.USER) {
      return FloatingActionButton.extended(
        label: const Text(
          "Мои заказы",
          style: TextStyle(color: Colors.white),
        ),
        heroTag: "btn3",
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const MyTaxiOrdersPage(
                        mode: OrderMode.EV,
                      )))
              .then((value) {
            _transportationKey.currentState?.update();
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: const Color(0xff317EFA),
      );
    } else if (index == 2 &&
        selectedModeEv == Mode.NONE &&
        widget.userEntity.role == UserRole.SPECIALIST) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            label: const Text(
              "Мои заказы",
              style: TextStyle(color: Colors.white),
            ),
            heroTag: "btn3",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const MyTaxiOrdersPage(
                            mode: OrderMode.EV,
                          )))
                  .then((value) {
                _transportationKey.currentState?.update();
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          ),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateOrderTaxi(
                            city: widget.userEntity.city,
                            mode: OrderMode.EV,
                          )));
            },
            label: SizedBox(
              width: 100.w - 20.w,
              child: const Center(
                child: Text(
                  "Создать заказ +",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          )
        ],
      );
    }
    if ((index == 1 || index == 0) && selectedMode != Mode.NONE) {
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
                                  city: widget.userEntity.city,
                                  mode: selectedMode,
                                )))
                        .then((value) {
                      _transportationKey.currentState?.update();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomChatPage(
                                showTitle: true,
                                title: S.of(context).option1,
                                history: true,
                                chatName: "outcity",
                                subscription: widget.userEntity.subscription)));
                    break;
                  }
                default:
                  null;
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          )
        ],
      );
    } else if ((index == 1 || index == 0) &&
        selectedMode == Mode.NONE &&
        widget.userEntity.role == UserRole.USER) {
      return FloatingActionButton.extended(
        label: const Text(
          "Мои заказы",
          style: TextStyle(color: Colors.white),
        ),
        heroTag: "btn3",
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const MyTaxiOrdersPage(
                        mode: OrderMode.NEW,
                      )))
              .then((value) {
            _transportationKey.currentState?.update();
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: const Color(0xff317EFA),
      );
    } else if ((index == 1 || index == 0) &&
        selectedMode == Mode.NONE &&
        widget.userEntity.role == UserRole.SPECIALIST) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            label: const Text(
              "Мои заказы",
              style: TextStyle(color: Colors.white),
            ),
            heroTag: "btn3",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const MyTaxiOrdersPage(
                            mode: OrderMode.NEW,
                          )))
                  .then((value) {
                _transportationKey.currentState?.update();
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          ),
          SizedBox(
            height: 2.h,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateOrderTaxi(
                            mode: OrderMode.NEW,
                            city: widget.userEntity.city,
                          )));
            },
            label: SizedBox(
              width: 100.w - 20.w,
              child: const Center(
                child: Text(
                  "Создать заказ +",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color(0xff317EFA),
          )
        ],
      );
    }
    return null;
  }

//TAB
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
            city: widget.userEntity.city,
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
          child: SearchPage(
            city: widget.userEntity.city,
            sub: widget.userEntity.subscription,
          ));
    } else if (title.contains(S.of(context).page3)) {
      return NotificationListener<ChangeTransportModeNotify>(
          onNotification: (m) {
            selectedModeEv = m.mode;
            setState(() {});
            return true;
          },
          child: SearchTransportationPage(
            category: TransportationCategory.ev,
            city: widget.userEntity.city,
          ));
    } else if (title.contains(S.of(context).page4)) {
      return NotificationListener<ChangeModeManNotify>(
          onNotification: (m) {
            selectedModeMan = m.mode;
            setState(() {});
            return true;
          },
          child: ManTransportPage(
            sub: widget.userEntity.subscription,
            city: widget.userEntity.city,
          ));
    } else if (title.contains(S.of(context).page5)) {
      return NotificationListener<ChangeModeSamNotify>(
          onNotification: (m) {
            selectedModeSam = m.mode;
            setState(() {});
            return true;
          },
          child: SamTransportPage(
              sub: widget.userEntity.subscription,
              city: widget.userEntity.city));
    } else if (title.contains(S.of(context).page6)) {
      return NotificationListener<ChangeModeAutoNotify>(
          onNotification: (m) {
            selectedModeAuto = m.mode;
            setState(() {});
            return true;
          },
          child: AutoTransportPage(
              sub: widget.userEntity.subscription,
              city: widget.userEntity.city));
    } else if (title.contains(S.of(context).page7)) {
      return NotificationListener<ChangeModeExNotify>(
          onNotification: (m) {
            selectedModeEx = m.mode;
            setState(() {});
            return true;
          },
          child: ExTransportPage(
            sub: widget.userEntity.subscription,
            city: widget.userEntity.city,
          ));
    } else if (title.contains(S.of(context).page8)) {
      return NotificationListener<ChangeModePogNotify>(
          onNotification: (m) {
            selectedModePog = m.mode;
            setState(() {});
            return true;
          },
          child: PogTransportPage(
              sub: widget.userEntity.subscription,
              city: widget.userEntity.city));
    } else if (title.contains(S.of(context).page10)) {
      return CustomChatPage(
          key: const Key("chat_4"),
          subscription: widget.userEntity.subscription,
          history: true,
          showTitle: false,
          title: S.of(context).page10,
          chatName: GlobalsWidgets.chats[4]);
    } else if (title.contains(S.of(context).page11)) {
      return const CatalogPage(
        category: Categories.auto,
      );
    } else if (title.contains("Чат")) {
      return ChatPage(
        user: widget.userEntity,
      );
    } else if (title.contains(S.of(context).page12)) {
      return NotificationListener<ChangeModeTaxiNotify>(
          onNotification: (m) {
            selectedModeTaxi = m.mode;
            setState(() {});
            return true;
          },
          child: TaxiPage(
              sub: widget.userEntity.subscription,
              city: widget.userEntity.city));
    } else if (title.contains(S.of(context).page13)) {
      return NotificationListener<ChangeModeAssenNotify>(
          onNotification: (m) {
            selectedModeAssen = m.mode;
            setState(() {});
            return true;
          },
          child: AssenTransportPage(
              sub: widget.userEntity.subscription,
              city: widget.userEntity.city));
    }
    return const SizedBox.shrink();
  }

  // void addCompany(Categories category) {
  //   String? temp_name;
  //   String? temp_phone;
  //   String? temp_street;
  //   String? temp_house;
  //   showDialog(
  //       context: context,
  //       builder: (context) => StatefulBuilder(builder: (context, state) {
  //             return AlertDialog(
  //               title: Text(
  //                 "Добавить комапнию",
  //                 style: TextStyle(fontSize: 18.sp),
  //               ),
  //               content: Container(
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Название",
  //                         style: TextStyle(
  //                             fontSize: 14.sp, fontWeight: FontWeight.bold),
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       SizedBox(
  //                         height: 8.h,
  //                         child: TextFormField(
  //                           onChanged: (value) {
  //                             temp_name = value;
  //                           },
  //                           style: TextStyle(fontSize: 16.sp),
  //                           decoration: InputDecoration(
  //                             hintText: "Введите название города",
  //                             hintStyle: TextStyle(fontSize: 16.sp),
  //                             enabledBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(9),
  //                                 borderSide: const BorderSide(
  //                                     color: Color(0xffD9D9D9))),
  //                             focusedBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(9),
  //                                 borderSide: const BorderSide(
  //                                     color: Color(0xffD9D9D9))),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       Text(
  //                         "Номер телефона",
  //                         style: TextStyle(
  //                             fontSize: 14.sp, fontWeight: FontWeight.bold),
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       SizedBox(
  //                         height: 8.h,
  //                         child: TextFormField(
  //                           onChanged: (value) {
  //                             temp_phone = value;
  //                           },
  //                           style: TextStyle(fontSize: 16.sp),
  //                           keyboardType: const TextInputType.numberWithOptions(
  //                               decimal: true),
  //                           inputFormatters: [
  //                             FilteringTextInputFormatter.allow(
  //                                 RegExp('[0-9.,]+')),
  //                           ],
  //                           decoration: InputDecoration(
  //                             hintText: "Введите номер телефона",
  //                             hintStyle: TextStyle(fontSize: 16.sp),
  //                             enabledBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(9),
  //                                 borderSide: const BorderSide(
  //                                     color: Color(0xffD9D9D9))),
  //                             focusedBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(9),
  //                                 borderSide: const BorderSide(
  //                                     color: Color(0xffD9D9D9))),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           "Адрес",
  //                           style: TextStyle(
  //                               fontSize: 16.sp, fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       Text(
  //                         "Улица",
  //                         style: TextStyle(
  //                             fontSize: 14.sp, fontWeight: FontWeight.bold),
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       SizedBox(
  //                         height: 8.h,
  //                         child: TextFormField(
  //                           onChanged: (value) {
  //                             temp_street = value;
  //                           },
  //                           style: TextStyle(fontSize: 16.sp),
  //                           decoration: InputDecoration(
  //                             hintText: "Введите название",
  //                             hintStyle: TextStyle(fontSize: 16.sp),
  //                             enabledBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(9),
  //                                 borderSide: const BorderSide(
  //                                     color: Color(0xffD9D9D9))),
  //                             focusedBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(9),
  //                                 borderSide: const BorderSide(
  //                                     color: Color(0xffD9D9D9))),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       Text(
  //                         "Номер дома",
  //                         style: TextStyle(
  //                             fontSize: 14.sp, fontWeight: FontWeight.bold),
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       SizedBox(
  //                         height: 8.h,
  //                         child: TextFormField(
  //                           onChanged: (value) {
  //                             temp_house = value;
  //                           },
  //                           style: TextStyle(fontSize: 16.sp),
  //                           decoration: InputDecoration(
  //                             hintText: "Введите номер дома",
  //                             hintStyle: TextStyle(fontSize: 16.sp),
  //                             enabledBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(9),
  //                                 borderSide: const BorderSide(
  //                                     color: Color(0xffD9D9D9))),
  //                             focusedBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(9),
  //                                 borderSide: const BorderSide(
  //                                     color: Color(0xffD9D9D9))),
  //                           ),
  //                         ),
  //                       ),
  //                       category == Categories.auto
  //                           ? Align(
  //                               alignment: Alignment.center,
  //                               child: SizedBox(
  //                                 height: 6.h,
  //                                 child: OutlinedButton(
  //                                   style: OutlinedButton.styleFrom(
  //                                       backgroundColor:
  //                                           const Color(0xff317EFA),
  //                                       side: BorderSide.none,
  //                                       shape: RoundedRectangleBorder(
  //                                           borderRadius:
  //                                               BorderRadius.circular(5))),
  //                                   onPressed: () async {
  //                                     final ImagePicker picker = ImagePicker();
  //                                     final XFile? image =
  //                                         await picker.pickImage(
  //                                             source: ImageSource.gallery,
  //                                             preferredCameraDevice:
  //                                                 CameraDevice.rear);
  //                                     if (image != null) {
  //                                       file =
  //                                           File.fromUri(Uri.parse(image.path));
  //                                     }
  //                                   },
  //                                   child: const Text(
  //                                     "Добавить фото",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                 ),
  //                               ),
  //                             )
  //                           : const SizedBox.shrink(),
  //                       Align(
  //                         alignment: Alignment.centerRight,
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             TextButton(
  //                                 onPressed: () {
  //                                   Navigator.pop(context);
  //                                 },
  //                                 child: Text(S.of(context).cancel,
  //                                     style: TextStyle(
  //                                         color: GlobalsColor.blue,
  //                                         fontSize: 14.sp))),
  //                             SizedBox(
  //                               width: 5.w,
  //                             ),
  //                             TextButton(
  //                                 onPressed: () {
  //                                   Dio dio = Dio();
  //                                   RestClient client = RestClient(dio);
  //                                   String ph = "";
  //                                   if (temp_phone![0].contains("8")) {
  //                                     ph += temp_phone!.replaceFirst("8", "7");
  //                                   }
  //                                   client
  //                                       .createCompany(
  //                                           GlobalsWidgets.uid,
  //                                           category,
  //                                           temp_name!,
  //                                           ph,
  //                                           temp_street!,
  //                                           temp_house!,
  //                                           file)
  //                                       .then(
  //                                           (value) => Navigator.pop(context));
  //                                 },
  //                                 child: Text(
  //                                   S.of(context).add,
  //                                   style: TextStyle(
  //                                       color: GlobalsColor.blue,
  //                                       fontSize: 14.sp),
  //                                 )),
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           })).then((value) {
  //     setState(() {});
  //   });
  // }
}
