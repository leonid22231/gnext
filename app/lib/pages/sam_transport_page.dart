import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/OrderEntity.dart';
import 'package:app/api/entity/TransportationEntity.dart';
import 'package:app/api/entity/enums/Mode.dart';
import 'package:app/api/entity/enums/OrderMode.dart';
import 'package:app/api/entity/enums/TransportationCategory.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/profile_page.dart';
import 'package:app/pages/seconds/create_cargo.dart';
import 'package:app/pages/seconds/order_page.dart';
import 'package:app/pages/seconds/transportation_page.dart';
import 'package:app/pages/seconds/user_profile.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SamTransportPage extends StatefulWidget {
  final bool sub;
  final CityEntity city;
  const SamTransportPage({required this.sub, required this.city, super.key});

  @override
  State<StatefulWidget> createState() => SamTransportPageState();
}

class SamTransportPageState extends State<SamTransportPage>
    with TickerProviderStateMixin {
  Mode selectedMode = Mode.CITY;
  late TabController _controller;
  CityEntity? otkuda;
  CityEntity? kuda;
  DateTime? date;
  TransportationCategory category = TransportationCategory.sam;
  List<String> res = [];
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    otkuda = widget.city;
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ChangeModeSamNotify(selectedMode).dispatch(context));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h).copyWith(top: 0),
      child: Column(
        children: [
          ButtonsTabBar(
            controller: _controller,
            backgroundColor: GlobalsColor.blue,
            unselectedBackgroundColor: Colors.white,
            unselectedLabelStyle: const TextStyle(color: Colors.black),
            labelStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            onTap: (index) {
              selectedMode = Mode.values[index];
              ChangeModeSamNotify(selectedMode).dispatch(context);
              setState(() {});
            },
            tabs: [
              Tab(
                text: S.of(context).city,
              ),
              Tab(
                text: S.of(context).no_city,
              ),
              Tab(
                text: S.of(context).services,
              ),
            ],
          ),
          _getBody(selectedMode)
        ],
      ),
    );
  }

  Widget _getBody(Mode mode) {
    switch (mode) {
      case Mode.NONE:
        return Expanded(
            child: SizedBox(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Column(
                children: [
                  FutureBuilder(
                      future: RestClient(Dio()).searchOrders(
                          OrderMode.SAM, widget.city.id, widget.city.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<OrderEntity> orders = snapshot.data!;
                          return ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, index) {
                                OrderEntity currentOrder = orders[index];
                                return Container(
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 8.h,
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(1000),
                                                child: Image.network(
                                                    height: 8.h,
                                                    width: 8.h,
                                                    fit: BoxFit.cover,
                                                    GlobalsWidgets.getPhoto(
                                                        currentOrder
                                                            .creator.photo)),
                                              ),
                                              Text(
                                                  "${currentOrder.creator.name} ${currentOrder.creator.surname}")
                                            ],
                                          ),
                                        ),
                                        const VerticalDivider(
                                          color: Colors.black,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${currentOrder.price} ₸"),
                                            Divider(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              height: 1,
                                            ),
                                            Text(currentOrder.description!),
                                            Divider(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              height: 1,
                                            ),
                                            Text(
                                                "Создано: ${DateFormat("d MMMM, HH:mm").format(currentOrder.createDate)}")
                                          ],
                                        )),
                                        const VerticalDivider(
                                          color: Colors.black,
                                        ),
                                        CircleAvatar(
                                          radius: 8.w,
                                          backgroundColor: GlobalsColor.blue,
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserProfile(
                                                                user: currentOrder
                                                                    .creator)));
                                              },
                                              icon: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 2.h,
                                  color: Colors.black,
                                );
                              },
                              itemCount: orders.length);
                        } else {
                          return const SizedBox.shrink();
                        }
                      })
                ],
              ),
            ),
          ),
        ));
      case Mode.CITY:
        return Expanded(
            child: SizedBox(
          child: FutureBuilder(
            future: getMyTransportation(false),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TransportationEntity> myList = snapshot.data!;
                return FutureBuilder(
                    future: getActiveTransportation(false),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<TransportationEntity> allList = snapshot.data!;
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GlobalsWidgets.role == UserRole.USER
                                  ? Text(S.of(context).you_orders)
                                  : const SizedBox.shrink(),
                              GlobalsWidgets.role == UserRole.USER
                                  ? ListView.separated(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: myList.length,
                                      itemBuilder: (context, index) {
                                        TransportationEntity order =
                                            myList[index];
                                        return InkWell(
                                          onTap: () {
                                            onClick(order);
                                          },
                                          child: Container(
                                            width: double.maxFinite,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                                color:
                                                    GlobalsColor.userCardColor),
                                            child: Padding(
                                              padding: EdgeInsets.all(2.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${order.addressFrom.street}${order.addressFrom.house != null ? "," : ""} ${order.addressFrom.house ?? ""} ->",
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "${order.price.round()} ₸",
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        DateFormat("dd EE. MMM")
                                                            .format(order.date
                                                                .toLocal()),
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xffCFCFCF),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        DateFormat("dd MMM")
                                                            .format(order
                                                                .createDate
                                                                .toLocal()),
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xffCFCFCF),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 2.h,
                                        );
                                      },
                                    )
                                  : const SizedBox.shrink(),
                              GlobalsWidgets.role == UserRole.USER
                                  ? Text(S.of(context).not_you_orders)
                                  : const SizedBox.shrink(),
                              ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: allList.length,
                                itemBuilder: (context, index) {
                                  TransportationEntity order = allList[index];
                                  if (myList.contains(order)) {
                                    return const SizedBox.shrink();
                                  }
                                  return InkWell(
                                    onTap: () {
                                      if (GlobalsWidgets.role ==
                                          UserRole.SPECIALIST) onClick(order);
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          color: GlobalsColor.nonUserCardColor),
                                      child: Padding(
                                        padding: EdgeInsets.all(2.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${order.addressFrom.street}${order.addressFrom.house != null ? "," : ""} ${order.addressFrom.house ?? ""} ->",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${order.price.round()} ₸",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  DateFormat("dd EE. MMM")
                                                      .format(
                                                          order.date.toLocal()),
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xffCFCFCF),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  DateFormat("dd MMM").format(
                                                      order.createDate
                                                          .toLocal()),
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xffCFCFCF),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  if (myList.contains(allList[index])) {
                                    return const SizedBox.shrink();
                                  }
                                  return SizedBox(
                                    height: 2.h,
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    });
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ));
      case Mode.OUTCITY:
        return Expanded(
            child: SizedBox(
          child: FutureBuilder(
            future: getMyTransportation(true),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TransportationEntity> myList = snapshot.data!;
                return FutureBuilder(
                    future: getActiveTransportation(true),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<TransportationEntity> allList = snapshot.data!;
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GlobalsWidgets.role == UserRole.USER
                                  ? Text(S.of(context).you_orders)
                                  : const SizedBox.shrink(),
                              GlobalsWidgets.role == UserRole.USER
                                  ? ListView.separated(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: myList.length,
                                      itemBuilder: (context, index) {
                                        TransportationEntity order =
                                            myList[index];
                                        return InkWell(
                                          onTap: () {
                                            onClick(order);
                                          },
                                          child: Container(
                                            width: double.maxFinite,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                                color:
                                                    GlobalsColor.userCardColor),
                                            child: Padding(
                                              padding: EdgeInsets.all(2.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${order.addressFrom.city} ->",
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "${order.price.round()} ₸",
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(order.addressTo.city,
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        DateFormat("dd EE. MMM")
                                                            .format(order.date
                                                                .toLocal()),
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xffCFCFCF),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        DateFormat("dd MMM")
                                                            .format(order
                                                                .createDate
                                                                .toLocal()),
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xffCFCFCF),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 2.h,
                                        );
                                      },
                                    )
                                  : const SizedBox.shrink(),
                              GlobalsWidgets.role == UserRole.USER
                                  ? Text(S.of(context).not_you_orders)
                                  : const SizedBox.shrink(),
                              ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: allList.length,
                                itemBuilder: (context, index) {
                                  TransportationEntity order = allList[index];
                                  if (myList.contains(order)) {
                                    return const SizedBox.shrink();
                                  }
                                  return InkWell(
                                    onTap: () {
                                      if (GlobalsWidgets.role ==
                                          UserRole.SPECIALIST) onClick(order);
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          color: GlobalsColor.nonUserCardColor),
                                      child: Padding(
                                        padding: EdgeInsets.all(2.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${order.addressFrom.city} ->",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${order.price.round()} ₸",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(order.addressTo.city,
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  DateFormat("dd EE. MMM")
                                                      .format(
                                                          order.date.toLocal()),
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xffCFCFCF),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  DateFormat("dd MMM").format(
                                                      order.createDate
                                                          .toLocal()),
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xffCFCFCF),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  if (myList.contains(allList[index])) {
                                    return const SizedBox.shrink();
                                  }
                                  return SizedBox(
                                    height: 2.h,
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    });
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ));
    }
  }

  update() => setState(() {});
  void onClick(TransportationEntity transportationEntity) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TransportationViewPage(
                  transportation: transportationEntity,
                  title: "самосвал",
                )));
  }

  Future<List<TransportationEntity>> getMyTransportation(bool outCity) {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.findMyTransportation(GlobalsWidgets.uid, category, outCity);
  }

  Future<List<TransportationEntity>> getActiveTransportation(bool outCity) {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.findActiveTransportation(
        GlobalsWidgets.uid, category, outCity);
  }
}

class ChangeModeSamNotify extends Notification {
  Mode mode;
  ChangeModeSamNotify(this.mode);
}

class CustomAddress {
  String street;
  String house;

  @override
  String toString() {
    return "$street, $house";
  }

  CustomAddress(this.street, this.house);
}
