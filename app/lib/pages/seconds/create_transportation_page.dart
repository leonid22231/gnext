import 'dart:convert';

import 'package:address_search_field/address_search_field.dart';
import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/PropertiesEntity.dart';
import 'package:app/api/entity/enums/Mode.dart';
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
  const CreateTransportationPage({required this.createMode, super.key});
  @override
  State<StatefulWidget> createState() => _CreateTransportationState();
}

class _CreateTransportationState extends State<CreateTransportationPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController kudaController = TextEditingController();
  Address? destinationAddress;
  Address? kuda;
  DateTime? dateTime1;
  String? description;
  double price = 0;
  @override
  Widget build(BuildContext context) {
    debugPrint("Create transportation mode ${widget.createMode}");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).add, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700)),
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
              InputWidget(
                readOnly: true,
                required: true,
                width: 90.w,
                hintText: destinationAddress == null ? S.of(context).create_2 : destinationAddress!.reference!,
                onClick: () => showDialog(
                    context: context,
                    builder: (context) => AddressSearchBuilder.deft(
                          geoMethods: GeoMethods(googleApiKey: GlobalsWidgets.API_KEY, language: "ru"),
                          controller: controller,
                          onDone: (address) async {
                            destinationAddress = address;
                          },
                          builder: AddressDialogBuilder(hintText: S.of(context).search, continueText: S.of(context).ok, cancelText: S.of(context).cancel, noResultsText: S.of(context).not_fount),
                        )),
              ),
              SizedBox(
                height: 1.h,
              ),
              InputWidget(
                readOnly: true,
                required: true,
                width: 90.w,
                hintText: kuda == null ? S.of(context).create_3 : kuda!.reference!,
                onClick: () => showDialog(
                    context: context,
                    builder: (context) => AddressSearchBuilder.deft(
                          geoMethods: GeoMethods(googleApiKey: GlobalsWidgets.API_KEY, language: "ru"),
                          controller: kudaController,
                          onDone: (Address address) => kuda = address,
                          builder: AddressDialogBuilder(hintText: S.of(context).search, continueText: S.of(context).ok, cancelText: S.of(context).cancel, noResultsText: S.of(context).not_fount),
                        )),
              ),
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
                hintText: dateTime1 == null ? S.of(context).date_create : DateFormat("dd MMMM y").format(dateTime1!),
                onClick: () {
                  BottomPicker.date(
                          title: S.of(context).date_pick,
                          buttonContent: Text(
                            S.of(context).ok,
                            style: const TextStyle(color: Colors.white),
                          ),
                          buttonSingleColor: const Color(0xff317EFA),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: const Color(0xff317EFA)),
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
                  InputWidget(readOnly: true, required: false, width: 15.w, hintText: "₸"),
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
                      style: OutlinedButton.styleFrom(backgroundColor: GlobalsColor.blue, side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9), side: BorderSide.none)),
                      onPressed: () async {
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        bool outcity = false;
                        if (widget.createMode == Mode.OUTCITY) {
                          outcity = true;
                        }
                        if (dateTime1 != null && description != null && price > 0 && kuda != null) {
                          http.Response dest = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=${destinationAddress!.placeId}&key=AIzaSyDiqxR05PppZDGdbTUxTMYN92dmbrEumbc&language=ru'));
                          http.Response kuda_ = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=${kuda!.placeId}&key=AIzaSyDiqxR05PppZDGdbTUxTMYN92dmbrEumbc&language=ru'));
                          String city1 = "", city2 = "";
                          String? house1, house2;
                          String? street1, street2;
                          var json_dest1 = jsonDecode(dest.body);
                          var array_dest1 = json_dest1["result"]["address_components"];
                          for (int i = 0; i < array_dest1.length; i++) {
                            var array_dest_type1 = array_dest1[i]["types"];
                            for (int j = 0; j < array_dest_type1.length; j++) {
                              if (array_dest_type1[j] == "locality") {
                                city1 = array_dest1[i]["long_name"];
                              } else if (array_dest_type1[j] == "route") {
                                street1 = array_dest1[i]["long_name"];
                              } else if (array_dest_type1[j] == "street_number") {
                                house1 = array_dest1[i]["long_name"];
                              }
                            }
                          }
                          var json_dest2 = jsonDecode(kuda_.body);
                          var array_dest2 = json_dest2["result"]["address_components"];
                          for (int i = 0; i < array_dest2.length; i++) {
                            var array_dest_type2 = array_dest2[i]["types"];
                            for (int j = 0; j < array_dest_type2.length; j++) {
                              if (array_dest_type2[j] == "locality") {
                                city2 = array_dest2[i]["long_name"];
                              } else if (array_dest_type2[j] == "route") {
                                street2 = array_dest2[i]["long_name"];
                              } else if (array_dest_type2[j] == "street_number") {
                                house2 = array_dest2[i]["long_name"];
                              }
                            }
                          }

                          AddressModel addressFrom = AddressModel(street1, house1, city1);
                          AddressModel addressTo = AddressModel(street2, house2, city2);
                          debugPrint("addressFrom $addressFrom");
                          debugPrint("addressTo $addressTo");
                          PropertiesModel properties = PropertiesModel(addressTo, addressFrom);
                          client.createTransporting(GlobalsWidgets.uid, price, description!, outcity, dateTime1!, properties).then((value) {
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
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
