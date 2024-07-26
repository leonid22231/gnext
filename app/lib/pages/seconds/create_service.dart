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

class CreateService extends StatefulWidget {
  final CityEntity city;
  final OrderMode mode;
  const CreateService({required this.city, required this.mode, super.key});
  @override
  State<StatefulWidget> createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  DateTime? dateTime1;
  CityEntity? kudaCity;
  CityEntity? otkudaCity;
  String? description;
  double price = 0;
  @override
  void initState() {
    otkudaCity = widget.city;
    kudaCity = widget.city;
    dateTime1 = DateTime.now();
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
          "Новая услуга",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _requiredBigTitle("Цена"),
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
                        "Создать услугу",
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
