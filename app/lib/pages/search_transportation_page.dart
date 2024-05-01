import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/TransportationEntity.dart';
import 'package:app/api/entity/enums/Mode.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/seconds/transportation_page.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchTransportationPage extends StatefulWidget {
  const SearchTransportationPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchTransportationState();
}

class _SearchTransportationState extends State<SearchTransportationPage> with TickerProviderStateMixin {
  Mode selectedMode = Mode.CITY;
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h).copyWith(top: 0),
        child: Column(
          children: [
            ButtonsTabBar(
              controller: _controller,
              backgroundColor: GlobalsColor.blue,
              unselectedBackgroundColor: Colors.white,
              unselectedLabelStyle: const TextStyle(color: Colors.black),
              labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              onTap: (index) {
                selectedMode = Mode.values[index];
                ChangeTransportModeNotify(selectedMode).dispatch(context);
                setState(() {});
              },
              tabs: [
                Tab(
                  text: S.of(context).city,
                ),
                Tab(
                  text: S.of(context).no_city,
                ),
              ],
            ),
            _getBody(selectedMode)
          ],
        ));
  }

  Widget _getBody(Mode mode) {
    switch (mode) {
      case Mode.CITY:
        return Expanded(
            child: SizedBox(
          child: FutureBuilder(
            future: GlobalsWidgets.role == UserRole.USER ? getMyTransportation(false) : getActiveTransportation(false),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TransportationEntity> list = snapshot.data!;
                return ListView.separated(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    TransportationEntity order = list[index];
                    return InkWell(
                      onTap: () {
                        onClick(order);
                      },
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: const Color(0xff787878)),
                        child: Padding(
                          padding: EdgeInsets.all(2.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${order.addressFrom.street}, ${order.addressFrom.house} ->",
                                    style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${order.price.round()} ₸",
                                    style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                children: [Text("${order.addressTo.street}, ${order.addressTo.house}", style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold))],
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat("dd EE. MMM").format(order.date.toLocal()),
                                    style: TextStyle(color: const Color(0xffCFCFCF), fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat("dd MMM").format(order.createDate.toLocal()),
                                    style: TextStyle(color: const Color(0xffCFCFCF), fontSize: 14.sp, fontWeight: FontWeight.bold),
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
                );
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
            future: GlobalsWidgets.role == UserRole.USER ? getMyTransportation(true) : getActiveTransportation(true),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TransportationEntity> list = snapshot.data!;
                return ListView.separated(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    TransportationEntity order = list[index];
                    return InkWell(
                      onTap: () {
                        onClick(order);
                      },
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: const Color(0xff787878)),
                        child: Padding(
                          padding: EdgeInsets.all(2.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${order.addressFrom.city} ->",
                                    style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${order.price.round()} ₸",
                                    style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                children: [Text(order.addressTo.city, style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold))],
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat("dd EE. MMM").format(order.date.toLocal()),
                                    style: TextStyle(color: const Color(0xffCFCFCF), fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat("dd MMM").format(order.createDate.toLocal()),
                                    style: TextStyle(color: const Color(0xffCFCFCF), fontSize: 14.sp, fontWeight: FontWeight.bold),
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
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ));
    }
  }

  void onClick(TransportationEntity transportationEntity) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TransportationViewPage(transportation: transportationEntity)));
  }

  Future<List<TransportationEntity>> getMyTransportation(bool out) {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.findMyTransportation(GlobalsWidgets.uid, out);
  }

  Future<List<TransportationEntity>> getActiveTransportation(bool out) {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.findActiveTransportation(GlobalsWidgets.uid, out);
  }
}

class ChangeTransportModeNotify extends Notification {
  Mode mode;
  ChangeTransportModeNotify(this.mode);
}
