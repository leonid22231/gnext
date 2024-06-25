import 'dart:async';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/CountryEntity.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/auth/code_enter_login_page.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/main_route.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  final UserRole? mode;
  const RegisterPage({this.mode, super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> with TickerProviderStateMixin {
  String? name, surname, phone, number, password;
  int selectedRole = 0;
  CountryEntity? selectedCountry;
  CityEntity? selectedCity;
  List<CityEntity>? cities;
  bool sec = false;
  File? file;
  List<UserRole> roles = [UserRole.USER, UserRole.SPECIALIST];
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    if (widget.mode != null) {
      switch (widget.mode!) {
        case UserRole.SPECIALIST:
          {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _controller.animateTo(1));
            setState(() {
              selectedRole = 1;
            });
          }
        case UserRole.USER:
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _controller.animateTo(0));
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10.h,
        centerTitle: true,
        title: Text(
          S.of(context).register,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: ButtonsTabBar(
                  controller: _controller,
                  backgroundColor: GlobalsColor.blue,
                  unselectedBackgroundColor: Colors.white,
                  unselectedLabelStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  onTap: (index) {
                    selectedRole = index;
                    setState(() {});
                  },
                  tabs: [
                    Tab(
                      text: S.of(context).user_role_1,
                    ),
                    Tab(
                      text: S.of(context).user_role_2,
                    ),
                  ],
                ),
              ),
              Text(
                S.of(context).name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                height: 8.h,
                child: TextFormField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    hintText: S.of(context).name_,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                S.of(context).surname,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                height: 8.h,
                child: TextFormField(
                  onChanged: (value) {
                    surname = value;
                  },
                  decoration: InputDecoration(
                    hintText: S.of(context).surname_,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                S.of(context).number_phone,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                height: 8.h,
                child: TextFormField(
                  onChanged: (value) {
                    phone = value;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                  ],
                  decoration: InputDecoration(
                    hintText: S.of(context).number_phone_,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                S.of(context).select_country,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 1.h,
              ),
              FutureBuilder(
                  future: getCountries(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CustomDropdown<CountryEntity>(
                        items: snapshot.data!,
                        hintText: S.of(context).select_country,
                        decoration: CustomDropdownDecoration(
                          closedBorder:
                              Border.all(color: const Color(0xffD9D9D9)),
                          closedFillColor: Colors.transparent,
                          expandedBorder:
                              Border.all(color: const Color(0xffD9D9D9)),
                          expandedFillColor: Colors.white,
                        ),
                        onChanged: (country) {
                          selectedCountry = country;
                          cities = selectedCountry!.cities;
                          setState(() {});
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
              selectedCountry == null
                  ? const SizedBox.shrink()
                  : _selectCity(cities!),
              selectedRole == 1
                  ? Text(
                      S.of(context).gos_number,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const SizedBox.shrink(),
              selectedRole == 1
                  ? SizedBox(
                      height: 1.h,
                    )
                  : const SizedBox.shrink(),
              selectedRole == 1
                  ? SizedBox(
                      height: 8.h,
                      child: TextFormField(
                        onChanged: (value) {
                          number = value;
                        },
                        decoration: InputDecoration(
                          hintText: S.of(context).gos_number_,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide:
                                  const BorderSide(color: Color(0xffD9D9D9))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide:
                                  const BorderSide(color: Color(0xffD9D9D9))),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              selectedRole == 1
                  ? SizedBox(
                      height: 2.h,
                    )
                  : const SizedBox.shrink(),
              Text(
                S.of(context).password,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                height: 8.h,
                child: TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    hintText: S.of(context).password_,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              selectedRole == 0
                  ? _photo(
                      S.of(context).photo_profile, S.of(context).photo_profile_)
                  : _photo(S.of(context).photo_gos, S.of(context).photo_gos_),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Checkbox(
                      value: sec,
                      onChanged: (value) {
                        setState(() {
                          sec = !sec;
                        });
                      }),
                  TextButton(
                    onPressed: () {
                      launchUrl(Uri.parse(
                          "https://docs.google.com/document/d/1UbERkp4OQGCNS_4lDqu9GJxZhBJHpbJxhIkxeR0GPuk/edit?usp=drivesdk"));
                    },
                    child: Text(
                      S.of(context).accept,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              SizedBox(
                height: 6.h,
                width: double.maxFinite,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xff317EFA),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9))),
                    onPressed: () async {
                      if (sec &&
                          name != null &&
                          name!.isNotEmpty &&
                          surname != null &&
                          surname!.isNotEmpty &&
                          phone != null &&
                          phone!.isNotEmpty &&
                          password != null &&
                          password!.isNotEmpty) {
                        String phoneNumber = "";
                        if (phone![0].contains("8")) {
                          phoneNumber += phone!.replaceFirst("8", "7");
                        } else {
                          phoneNumber += phone!;
                        }
                        await FirebaseAuth.instance.signInAnonymously();
                        GlobalsWidgets.uid =
                            FirebaseAuth.instance.currentUser!.uid;
                        String? messageToken;
                        if (Platform.isAndroid) {
                          messageToken =
                              await FirebaseMessaging.instance.getToken();
                        } else if (Platform.isIOS) {
                          messageToken =
                              await FirebaseMessaging.instance.getAPNSToken();
                        }
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        client
                            .register(
                                phoneNumber,
                                password!,
                                name!,
                                surname!,
                                number,
                                roles[selectedRole],
                                selectedCountry!.id,
                                selectedCity!.id,
                                GlobalsWidgets.uid,
                                messageToken!,
                                file)
                            .then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CodeEnterLoginPage(
                                    code: value,
                                    phone: phoneNumber,
                                    niceCode: () {
                                      Dio dio = Dio();
                                      RestClient client = RestClient(dio);
                                      client
                                          .loginConfirm(
                                              phoneNumber, GlobalsWidgets.uid)
                                          .then((value) async {
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        pref.setString("phone", phoneNumber);
                                        GlobalsWidgets.name = value.name;
                                        GlobalsWidgets.role = value.role;
                                        GlobalsWidgets.image = value.photo;
                                        GlobalsWidgets.surname = value.surname;
                                        if (context.mounted) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainRoute(
                                                        userEntity: value,
                                                      )),
                                              (route) => false);
                                        }
                                      });
                                    })),
                          );
                        }).onError((error, stackTrace) {
                          if (error is DioException) {
                            _displayErrorMotionToast(error.response!.data);
                          }
                        });
                      } else {
                        _displayErrorMotionToast(S.of(context).warning_1);
                      }
                    },
                    child: Text(
                      S.of(context).reg,
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<CountryEntity>> getCountries() {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.getCountries();
  }

  Widget _selectCity(List<CityEntity> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 2.h,
        ),
        Text(
          S.of(context).select_city,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 1.h,
        ),
        CustomDropdown<CityEntity>(
          items: list,
          hintText: S.of(context).select_city,
          decoration: CustomDropdownDecoration(
            closedBorder: Border.all(color: const Color(0xffD9D9D9)),
            closedFillColor: Colors.transparent,
            expandedBorder: Border.all(color: const Color(0xffD9D9D9)),
            expandedFillColor: Colors.white,
          ),
          onChanged: (city) {
            selectedCity = city;
          },
        )
      ],
    );
  }

  Widget _photo(String title, String text) {
    return InkWell(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? video =
            await picker.pickImage(source: ImageSource.gallery);
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
                Text(text,
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff797979)))
              ],
            ),
          ],
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
