import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/auth/code_enter_login_page.dart';
import 'package:app/auth/register_page.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/main_route.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? phone, password;
  UserEntity? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).signin,
              style: TextStyle(
                  color: const Color(0xff317EFA),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold),
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
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  if (phone != null && phone!.isNotEmpty) {
                    Dio dio = Dio();
                    RestClient client = RestClient(dio);
                    String phoneNumber = "";
                    if (phone![0].contains("8")) {
                      phoneNumber += phone!.replaceFirst("8", "7");
                    } else {
                      phoneNumber += phone!;
                    }
                    client.forgotPassword(phoneNumber).then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CodeEnterLoginPage(
                                    code: value,
                                    phone: phoneNumber,
                                    niceCode: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                                builder: (context, state) {
                                              return AlertDialog(
                                                title: Text(
                                                  S
                                                      .of(context)
                                                      .enter_new_password,
                                                  style: TextStyle(
                                                      fontSize: 16.sp),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 8.h,
                                                      child: TextFormField(
                                                        onChanged: (value) {
                                                          password = value;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: S
                                                              .of(context)
                                                              .password_,
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Color(
                                                                          0xffD9D9D9))),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Color(
                                                                          0xffD9D9D9))),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelLarge,
                                                    ),
                                                    child:
                                                        Text(S.of(context).ok),
                                                    onPressed: () async {
                                                      Dio dio = Dio();
                                                      RestClient client =
                                                          RestClient(dio);
                                                      await FirebaseAuth
                                                          .instance
                                                          .signInAnonymously();
                                                      GlobalsWidgets.uid =
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid;
                                                      client
                                                          .forgotPasswordConfirm(
                                                              phoneNumber,
                                                              password!,
                                                              GlobalsWidgets
                                                                  .uid)
                                                          .then((value) async {
                                                        SharedPreferences pref =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        pref.setString("phone",
                                                            phoneNumber);
                                                        user = value;
                                                        GlobalsWidgets.name =
                                                            value.name;
                                                        GlobalsWidgets.role =
                                                            value.role;
                                                        GlobalsWidgets.image =
                                                            value.photo;
                                                        GlobalsWidgets.surname =
                                                            value.surname;
                                                        if (context.mounted) {
                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              MainRoute(
                                                                                userEntity: user!,
                                                                              )),
                                                                  (route) =>
                                                                      false);
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelLarge,
                                                    ),
                                                    child: Text(
                                                        S.of(context).cancel),
                                                    onPressed: () {
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const LoginPage()),
                                                          (route) => false);
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                          });
                                    },
                                  )));
                    }).onError((error, stackTrace) {
                      if (error is DioException) {
                        _displayErrorMotionToast(error.response!.data);
                      }
                    });
                  } else {
                    _displayErrorMotionToast(S.of(context).warning_2);
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topRight,
                ),
                child: Text(
                  S.of(context).forgot_password,
                  style: TextStyle(
                      color: const Color(0xff317EFA), fontSize: 14.sp),
                ),
              ),
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
                  onPressed: () {
                    Dio dio = Dio();
                    RestClient client = RestClient(dio);
                    if (phone != null &&
                        phone!.isNotEmpty &&
                        password != null &&
                        password!.isNotEmpty) {
                      String phoneNumber = "";
                      if (phone![0].contains("8")) {
                        phoneNumber += phone!.replaceFirst("8", "7");
                      } else {
                        phoneNumber += phone!;
                      }
                      debugPrint(phoneNumber);
                      client.login(phoneNumber, password!).then((value) async {
                        await FirebaseAuth.instance.signInAnonymously();
                        GlobalsWidgets.uid =
                            FirebaseAuth.instance.currentUser!.uid;
                        String? messageToken =
                            await FirebaseMessaging.instance.getToken();
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setString("phone", phoneNumber);
                        GlobalsWidgets.name = value.name;
                        GlobalsWidgets.role = value.role;
                        GlobalsWidgets.image = value.photo;
                        GlobalsWidgets.surname = value.surname;
                        client
                            .setUserUid(phoneNumber, GlobalsWidgets.uid)
                            .then((value) {
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MainRoute(userEntity: value)),
                                (route) => false);
                          }
                        });
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
                    S.of(context).signin,
                    style: const TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 6.h,
              width: double.maxFinite,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Color(0xff317EFA)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage(
                                mode: UserRole.USER,
                              )),
                    );
                  },
                  child: Text(
                    "${S.of(context).register} ${S.of(context).user_role_1}",
                    style: const TextStyle(color: Color(0xff317EFA)),
                  )),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 6.h,
              width: double.maxFinite,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Color(0xff317EFA)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const RegisterPage(mode: UserRole.SPECIALIST)),
                    );
                  },
                  child: Text(
                    "${S.of(context).register} ${S.of(context).user_role_2}",
                    style: const TextStyle(color: Color(0xff317EFA)),
                  )),
            )
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
