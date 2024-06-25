import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/OrderEntity.dart';
import 'package:app/api/entity/TransportationEntity.dart';
import 'package:app/api/entity/enums/Mode.dart';
import 'package:app/api/entity/enums/OrderMode.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/seconds/create_cargo.dart';
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

class SearchTransportationPage extends StatefulWidget {
  final CityEntity city;
  const SearchTransportationPage({required this.city, super.key});

  @override
  State<StatefulWidget> createState() => _SearchTransportationState();
}

class _SearchTransportationState extends State<SearchTransportationPage>
    with TickerProviderStateMixin {
  Mode selectedMode = Mode.CITY;
  late TabController _controller;
  CityEntity? otkuda;
  CityEntity? kuda;
  DateTime? date;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    otkuda = widget.city;
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ChangeTransportModeNotify(selectedMode).dispatch(context));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h)
            .copyWith(top: 0),
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
                Tab(
                  text: S.of(context).poput,
                )
              ],
            ),
            _getBody(selectedMode)
          ],
        ));
  }

  Widget _getBody(Mode mode) {
    switch (mode) {
      case Mode.NONE:
        return Expanded(
            child: SizedBox(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                children: [
                  FutureBuilder(
                      future:
                          RestClient(Dio()).findCountryByCity(widget.city.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  SizedBox(
                                    child: Column(
                                      children: [
                                        CustomDropdown<CityEntity>(
                                          items: snapshot.data!.cities,
                                          initialItem: otkuda,
                                          hintText: S.of(context).select_city,
                                          decoration: CustomDropdownDecoration(
                                            closedBorder: Border.all(
                                                color: const Color(0xffD9D9D9)),
                                            closedFillColor: Colors.transparent,
                                            expandedBorder: Border.all(
                                                color: const Color(0xffD9D9D9)),
                                            expandedFillColor: Colors.white,
                                          ),
                                          onChanged: (city) {
                                            otkuda = city;
                                            setState(() {});
                                          },
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        CustomDropdown<CityEntity>(
                                          items: snapshot.data!.cities,
                                          initialItem: kuda,
                                          hintText: S.of(context).select_city,
                                          decoration: CustomDropdownDecoration(
                                            closedBorder: Border.all(
                                                color: const Color(0xffD9D9D9)),
                                            closedFillColor: Colors.transparent,
                                            expandedBorder: Border.all(
                                                color: const Color(0xffD9D9D9)),
                                            expandedFillColor: Colors.white,
                                          ),
                                          onChanged: (city) {
                                            kuda = city;
                                            setState(() {});
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (otkuda != null && kuda != null) {
                                            CityEntity temp = otkuda!;
                                            otkuda = kuda;
                                            kuda = temp;
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(1000),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xffD9D9D9))),
                                          padding: EdgeInsets.all(2.w),
                                          child: RotatedBox(
                                            quarterTurns: 1,
                                            child: Icon(
                                                size: 8.w,
                                                Icons.swap_horiz_outlined),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                child: InputWidget(
                                  readOnly: true,
                                  required: false,
                                  showRequired: false,
                                  width: 100.w - 10.w,
                                  prefixIcon: const Icon(
                                    Icons.edit_calendar_outlined,
                                    color: Colors.black,
                                  ),
                                  hintText: date == null
                                      ? "Дата отправления"
                                      : DateFormat("dd MMMM y").format(date!),
                                  onClick: () {
                                    BottomPicker.date(
                                            title: S.of(context).date_pick,
                                            buttonContent: Text(
                                              S.of(context).ok,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            buttonSingleColor:
                                                const Color(0xff317EFA),
                                            titleStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                                color: const Color(0xff317EFA)),
                                            onSubmit: (index) {
                                              date = index;
                                              setState(() {});
                                            },
                                            bottomPickerTheme:
                                                BottomPickerTheme.morningSalad)
                                        .show(context);
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                  SizedBox(
                    height: 2.h,
                  ),
                  (kuda != null && otkuda != null)
                      ? FutureBuilder(
                          future: RestClient(Dio())
                              .searchOrders(OrderMode.EV, kuda!.id, otkuda!.id),
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
                                                        BorderRadius.circular(
                                                            1000),
                                                    child: Image.network(
                                                        height: 8.h,
                                                        width: 8.h,
                                                        fit: BoxFit.cover,
                                                        GlobalsWidgets.getPhoto(
                                                            currentOrder.creator
                                                                .photo)),
                                                  ),
                                                  Text(
                                                      "${currentOrder.creator.name} ${currentOrder.creator.surname}")
                                                ],
                                              ),
                                            ),
                                            VerticalDivider(
                                              color: Colors.black,
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(currentOrder
                                                    .addressFrom.city),
                                                Text(currentOrder
                                                    .addressTo.city),
                                                Divider(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  height: 1,
                                                ),
                                                Text("${currentOrder.price} ₸"),
                                                Divider(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  height: 1,
                                                ),
                                                Text(DateFormat("d MMMM, HH:mm")
                                                    .format(currentOrder
                                                        .startDate)),
                                                Divider(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  height: 1,
                                                ),
                                                Text(currentOrder.description!),
                                                Divider(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  height: 1,
                                                ),
                                                Text(
                                                    "Создано: ${DateFormat("d MMMM, HH:mm").format(currentOrder.createDate)}")
                                              ],
                                            )),
                                            VerticalDivider(
                                              color: Colors.black,
                                            ),
                                            CircleAvatar(
                                              radius: 8.w,
                                              backgroundColor:
                                                  GlobalsColor.blue,
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
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ));
      case Mode.CITY:
        return Expanded(
            child: SizedBox(
          child: FutureBuilder(
            future: GlobalsWidgets.role == UserRole.USER
                ? getMyTransportation(false)
                : getActiveTransportation(false),
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: const Color(0xff787878)),
                        child: Padding(
                          padding: EdgeInsets.all(2.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat("dd EE. MMM")
                                        .format(order.date.toLocal()),
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
            future: GlobalsWidgets.role == UserRole.USER
                ? getMyTransportation(true)
                : getActiveTransportation(true),
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: const Color(0xff787878)),
                        child: Padding(
                          padding: EdgeInsets.all(2.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${order.addressFrom.city} ->",
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
                                  Text(order.addressTo.city,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat("dd EE. MMM")
                                        .format(order.date.toLocal()),
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TransportationViewPage(transportation: transportationEntity)));
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
