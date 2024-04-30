import 'package:app/api/RestClient.dart';
import 'package:app/auth/code_enter_login_page.dart';
import 'package:app/auth/register_page.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>{
  String? phone, password;
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).signin, style: TextStyle(color: const Color(0xff317EFA), fontSize: 22.sp, fontWeight: FontWeight.bold),),
              SizedBox(height: 2.h,),
              Text(S.of(context).number_phone, style: const TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 1.h,),
              SizedBox(
                height: 8.h,
                child: TextFormField(
                  onChanged: (value){
                    phone = value;
                  },
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                  decoration: InputDecoration(
                      hintText: S.of(context).number_phone_,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(color: Color(0xffD9D9D9))
                      ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h,),
              Text(S.of(context).password, style: const TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 1.h,),
              SizedBox(
                height: 8.h,
                child: TextFormField(
                  onChanged: (value){
                    password = value;
                  },
                  decoration: InputDecoration(
                      hintText: S.of(context).password_,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(color: Color(0xffD9D9D9))
                      ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: (){

                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.topRight,
                  ),
                  child: Text(S.of(context).forgot_password, style: TextStyle(color: const Color(0xff317EFA), fontSize: 14.sp),),
                ),
              ),
              SizedBox(height: 3.h,),
              SizedBox(
                height: 6.h,
                width: double.maxFinite,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xff317EFA),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)
                    )
                  ),
                    onPressed: (){
                      Dio dio = Dio();
                      RestClient client = RestClient(dio);
                      String phoneNumber = "";
                      if(phone![0].contains("8")){
                        phoneNumber+= phone!.replaceFirst("8", "7");
                      }else{
                        phoneNumber+= phone!;
                      }
                      if(phone!=null && phone!.isNotEmpty && password!=null && password!.isNotEmpty){
                        debugPrint(phoneNumber);
                        client.login(phoneNumber, password!).then((value) async {
                          await FirebaseAuth.instance.signInAnonymously();
                          GlobalsWidgets.uid = FirebaseAuth.instance.currentUser!.uid;
                          if(context.mounted){
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => CodeEnterLoginPage(code: value,phone: phoneNumber,)), (route) => false);
                          }
                        }).onError((error, stackTrace){
                          if(error is DioException){
                            _displayErrorMotionToast(error.response!.data);
                          }
                        });
                      }else{
                        _displayErrorMotionToast(S.of(context).warning_1);
                      }
                    }, child: Text(S.of(context).signin, style: const TextStyle(color: Colors.white),)),
              ),
              SizedBox(height: 2.h,),
              SizedBox(
                height: 6.h,
                width: double.maxFinite,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Color(0xff317EFA)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)
                        )
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    }, child: Text(S.of(context).register, style: const TextStyle(color: Color(0xff317EFA)),)),
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