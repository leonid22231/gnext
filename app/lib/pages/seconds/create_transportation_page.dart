import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/PropertiesEntity.dart';
import 'package:app/api/entity/enums/Mode.dart';
import 'package:app/api/entity/enums/TransportationCategory.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/seconds/create_cargo.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

class CreateTransportationPage extends StatefulWidget {
  final Mode createMode;
  final CityEntity city;
  final TransportationCategory category;
  final bool? full;
  const CreateTransportationPage(
      {required this.createMode,
      this.full,
      required this.category,
      required this.city,
      super.key});
  @override
  State<StatefulWidget> createState() => _CreateTransportationState();
}

class _CreateTransportationState extends State<CreateTransportationPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController kudaController = TextEditingController();
  DateTime? dateTime1;
  String? description;
  double price = 0;
  CityEntity? kudaCity;
  CityEntity? otkudaCity;
  String? address1;
  String? address2;

  @override
  void initState() {
    otkudaCity = widget.city;
    super.initState();
  }

  Widget _selectCity() {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return FutureBuilder(
        future: client.findCountryByCity(widget.city.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int item = 0;
            for (int i = 0; i < snapshot.data!.cities.length; i++) {
              if (snapshot.data!.cities[i].id == otkudaCity!.id) {
                item = i;
                break;
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.full ?? true
                    ? _smallTitle("Откуда")
                    : const SizedBox.shrink(),
                widget.full ?? true
                    ? Padding(
                        padding: EdgeInsets.only(right: 5.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: 5.w,
                                child: const Center(
                                  child: Text(
                                    "*",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                )),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  S.of(context).select_city,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                CustomDropdown<CityEntity>(
                                  items: snapshot.data!.cities,
                                  initialItem: snapshot.data!.cities[item],
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
                                    otkudaCity = city;
                                  },
                                )
                              ],
                            ))
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(
                  height: 1.h,
                ),
                _smallTitle("Куда"),
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 5.w,
                          child: const Center(
                            child: Text(
                              "*",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),
                            ),
                          )),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            S.of(context).select_city,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          CustomDropdown<CityEntity>(
                            items: snapshot.data!.cities,
                            hintText: S.of(context).select_city,
                            decoration: CustomDropdownDecoration(
                              closedBorder:
                                  Border.all(color: const Color(0xffD9D9D9)),
                              closedFillColor: Colors.transparent,
                              expandedBorder:
                                  Border.all(color: const Color(0xffD9D9D9)),
                              expandedFillColor: Colors.white,
                            ),
                            onChanged: (city) {
                              kudaCity = city;
                            },
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Text("Загрузка");
          }
        });
  }

  Widget selectAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Можно записать номер дома через запятую",
                style: TextStyle(
                    fontSize: 14.sp, color: Colors.black.withOpacity(0.5)),
              ),
              Text(
                "(Пример: Лесная,8)",
                style: TextStyle(
                    fontSize: 14.sp, color: Colors.black.withOpacity(0.5)),
              ),
            ],
          ),
        ),
        widget.full ?? true ? _smallTitle("Откуда") : const SizedBox.shrink(),
        SizedBox(
          height: 1.h,
        ),
        widget.full ?? true
            ? InputWidget(
                readOnly: false,
                required: true,
                width: 90.w,
                hintText: "Улица",
                onChange: (value) {
                  address1 = value;
                },
              )
            : const SizedBox.shrink(),
        _smallTitle("Куда"),
        SizedBox(
          height: 1.h,
        ),
        InputWidget(
          readOnly: false,
          required: true,
          width: 90.w,
          hintText: "Улица",
          onChange: (value) {
            address2 = value;
          },
        ),
      ],
    );
  }

  Widget _smallTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xff797979),
            fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Create transportation mode ${widget.createMode}");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).add,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bigTitle(S.of(context).create_1),
              SizedBox(
                height: 1.h,
              ),
              widget.createMode == Mode.OUTCITY
                  ? _selectCity()
                  : selectAddress(),
              SizedBox(
                height: 2.h,
              ),
              _bigTitle(S.of(context).create_4),
              SizedBox(
                height: 1.h,
              ),
              InputWidget(
                readOnly: true,
                required: false,
                width: 90.w,
                hintText: dateTime1 == null
                    ? S.of(context).date_create
                    : DateFormat("dd MMMM y").format(dateTime1!),
                onClick: () {
                  BottomPicker.date(
                          title: S.of(context).date_pick,
                          buttonContent: Text(
                            S.of(context).ok,
                            style: const TextStyle(color: Colors.white),
                          ),
                          buttonSingleColor: const Color(0xff317EFA),
                          titleStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: const Color(0xff317EFA)),
                          onSubmit: (index) {
                            dateTime1 = index;
                            setState(() {});
                          },
                          bottomPickerTheme: BottomPickerTheme.morningSalad)
                      .show(context);
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              _requiredBigTitle(S.of(context).desc),
              SizedBox(
                height: 1.h,
              ),
              InputWidget(
                maxLength: 200,
                required: false,
                height: 30.h,
                width: 90.w,
                hintText: S.of(context).desc,
                onChange: (value) {
                  description = value;
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              _requiredBigTitle(S.of(context).pay),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  InputWidget(
                    required: false,
                    width: 25.w,
                    hintText: S.of(context).sum,
                    onChange: (value) {
                      price = double.parse(value);
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                  InputWidget(
                      readOnly: true,
                      required: false,
                      width: 15.w,
                      hintText: "₸"),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                width: 90.w,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: GlobalsColor.blue,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                              side: BorderSide.none)),
                      onPressed: () async {
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        bool outcity = false;
                        if (widget.createMode == Mode.OUTCITY) {
                          outcity = true;
                        }
                        if ((outcity &&
                                dateTime1 != null &&
                                description != null &&
                                price > 0 &&
                                kudaCity != null &&
                                otkudaCity != null) ||
                            (!outcity &&
                                dateTime1 != null &&
                                description != null &&
                                price > 0 &&
                                address1 != null &&
                                address2 != null) ||
                            (!(widget.full ?? true) &&
                                address2 != null &&
                                description != null &&
                                dateTime1 != null &&
                                price > 0)) {
                          if (!outcity) {
                            kudaCity = otkudaCity;
                          }
                          String city1 = otkudaCity!.name,
                              city2 = kudaCity!.name;
                          String? house1, house2;
                          String? street1, street2;
                          if (!outcity && (widget.full ?? true)) {
                            var tempAddress1 = address1!.split(",");
                            var tempAddress2 = address2!.split(",");
                            if (tempAddress1.length > 1) {
                              street1 = tempAddress1[0];
                              if (tempAddress1[1].isNotEmpty) {
                                house1 = tempAddress1[1];
                              }
                            } else {
                              street1 = address1;
                            }
                            if (tempAddress2.length > 1) {
                              street2 = tempAddress2[0];
                              if (tempAddress2[1].isNotEmpty) {
                                house2 = tempAddress2[1];
                              }
                            } else {
                              street2 = address2;
                            }
                          } else if (!outcity) {
                            var tempAddress2 = address2!.split(",");
                            if (tempAddress2.length > 1) {
                              street2 = tempAddress2[0];
                              if (tempAddress2[1].isNotEmpty) {
                                house2 = tempAddress2[1];
                              }
                            } else {
                              street2 = address2;
                            }
                          }
                          AddressModel addressFrom =
                              AddressModel(street1, house1, city1);
                          AddressModel addressTo =
                              AddressModel(street2, house2, city2);
                          debugPrint("addressFrom $addressFrom");
                          debugPrint("addressTo $addressTo");
                          PropertiesModel properties =
                              PropertiesModel(addressTo, addressFrom);
                          client
                              .createTransporting(
                                  GlobalsWidgets.uid,
                                  price,
                                  description!,
                                  widget.category,
                                  outcity,
                                  dateTime1!,
                                  properties)
                              .then((value) {
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            if (error is DioException) {
                              _displayErrorMotionToast(error.message!);
                            }
                          });
                        } else {
                          _displayErrorMotionToast(S.of(context).warning_1);
                        }
                      },
                      child: Text(
                        S.of(context).save_,
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _displayErrorMotionToast(String error) {
    MotionToast.error(
      title: Text(
        S.of(context).error,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(error),
      position: MotionToastPosition.top,
      barrierColor: Colors.black.withOpacity(0.3),
      width: 300,
      height: 80,
      dismissable: true,
    ).show(context);
  }

  Widget _requiredBigTitle(String title) {
    return Row(
      children: [
        SizedBox(
          width: 5.w,
          child: const Text(
            "*",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _bigTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Text(
        title,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
