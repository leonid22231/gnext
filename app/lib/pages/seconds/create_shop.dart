import 'dart:io';

import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/enums/Categories.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateShopPage extends StatefulWidget {
  const CreateShopPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateShopState();
}

class _CreateShopState extends State<CreateShopPage> {
  File? file;
  String? name, number, street, house;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).create_shop),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${S.of(context).create_shop_name_}*",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              SizedBox(height: 1.h),
              SizedBox(
                height: 8.h,
                child: TextFormField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    hintText: S.of(context).create_shop_name,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "${S.of(context).number_phone}*",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              SizedBox(height: 1.h),
              SizedBox(
                height: 8.h,
                child: TextFormField(
                  onChanged: (value) {
                    number = value;
                  },
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                  ],
                  decoration: InputDecoration(
                    hintText: S.of(context).number_phone_,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "${S.of(context).create_shop_street_}*",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              SizedBox(height: 1.h),
              SizedBox(
                height: 8.h,
                child: TextFormField(
                  onChanged: (value) {
                    street = value;
                  },
                  decoration: InputDecoration(
                    hintText: S.of(context).create_shop_street,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "${S.of(context).create_shop_house_}*",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              SizedBox(height: 1.h),
              SizedBox(
                height: 8.h,
                child: TextFormField(
                  onChanged: (value) {
                    house = value;
                  },
                  decoration: InputDecoration(
                    hintText: S.of(context).create_shop_house,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              _photo("${S.of(context).add_photo}*", S.of(context).files_photo),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                height: 6.h,
                width: double.maxFinite,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(backgroundColor: const Color(0xff317EFA), side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                    onPressed: () {
                      if (name != null && name!.isNotEmpty && number != null && number!.isNotEmpty && street != null && street!.isNotEmpty && house != null && house!.isNotEmpty) {
                        if (file != null) {
                          String numberPhone = "";
                          if (number![0].contains("8")) {
                            numberPhone += number!.replaceFirst("8", "7");
                          } else {
                            numberPhone += number!;
                          }
                          Dio dio = Dio();
                          RestClient client = RestClient(dio);
                          client.createCompany(GlobalsWidgets.uid, Categories.shop, name!, numberPhone, street!, house!, file).then((value) => Navigator.pop(context));
                        } else {
                          _displayErrorMotionToast(S.of(context).warning_3, context);
                        }
                      } else {
                        _displayErrorMotionToast(S.of(context).warning_1, context);
                      }
                    },
                    child: Text(
                      S.of(context).create,
                      style: const TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _displayErrorMotionToast(String error, BuildContext context) {
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

  Widget _photo(String title, String text) {
    return InkWell(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? video = await picker.pickImage(source: ImageSource.gallery);
        debugPrint("Media ${video!.name}");
        file = File.fromUri(Uri.parse(video.path));
      },
      child: Ink(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  size: 10.w,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(text, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xff797979)))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
