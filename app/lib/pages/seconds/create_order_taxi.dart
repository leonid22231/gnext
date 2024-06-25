import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/PropertiesEntity.dart';
import 'package:app/api/entity/enums/OrderMode.dart';
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
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateOrderTaxi extends StatefulWidget {
  final CityEntity city;
  final OrderMode mode;
  const CreateOrderTaxi({required this.city, required this.mode, super.key});
  @override
  State<StatefulWidget> createState() => _CreateOrderTaxiState();
}

class _CreateOrderTaxiState extends State<CreateOrderTaxi> {
  DateTime? dateTime1;
  CityEntity? kudaCity;
  CityEntity? otkudaCity;
  String? description;
  double price = 0;
  @override
  void initState() {
    otkudaCity = widget.city;
    super.initState();
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
                _smallTitle("Откуда"),
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
                            initialItem: snapshot.data!.cities[item],
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
                              otkudaCity = city;
                            },
                          )
                        ],
                      ))
                    ],
                  ),
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Новый заказ",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectCity(),
              _requiredBigTitle("Цена за место"),
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
              SizedBox(
                height: 2.h,
              ),
              _requiredBigTitle(S.of(context).create_4),
              SizedBox(
                height: 1.h,
              ),
              InputWidget(
                readOnly: true,
                required: false,
                width: 90.w,
                hintText: dateTime1 == null
                    ? "Дата и время"
                    : DateFormat("dd MMMM y").format(dateTime1!),
                onClick: () {
                  BottomPicker.dateTime(
                          use24hFormat: true,
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
                height: 1.h,
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

                        if (dateTime1 != null &&
                            description != null &&
                            price > 0 &&
                            kudaCity != null &&
                            otkudaCity != null) {
                          String? house1, house2;
                          String? street1, street2;

                          AddressModel addressFrom =
                              AddressModel(street1, house1, otkudaCity!.name);
                          AddressModel addressTo =
                              AddressModel(street2, house2, kudaCity!.name);
                          debugPrint("addressFrom ${addressFrom.toJson()}");
                          debugPrint("addressTo ${addressTo.toJson()}");
                          PropertiesModel properties =
                              PropertiesModel(addressTo, addressFrom);
                          client
                              .createOrder(
                                  GlobalsWidgets.uid,
                                  widget.mode,
                                  dateTime1!,
                                  description!,
                                  DateTime.now(),
                                  price,
                                  true,
                                  true,
                                  properties,
                                  null)
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
                      child: const Text(
                        "Создать заказ",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
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
}
