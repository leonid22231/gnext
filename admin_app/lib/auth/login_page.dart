import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/auth/code_enter_login_page.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPage();
}
class _LoginPage extends State<LoginPage>{
  String? phone;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset("assets/logo.png",
              fit: BoxFit.fill,
              height: 10.h, width: 60.w,),
            ),
            SizedBox(height: 5.h,),
            Text("Вход", style: TextStyle(color: const Color(0xff317EFA), fontSize: 20.sp, fontWeight: FontWeight.bold),),
            SizedBox(height: 2.h,),
            Text("Номер телефона", style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
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
                  hintText: "Введите номер телефона",
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
            Text("Пароль", style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
            SizedBox(height: 1.h,),
            SizedBox(
              height: 8.h,
              child: TextFormField(
                onChanged: (value){
                  password = value;
                },
                decoration: InputDecoration(
                  hintText: "Введите пароль",
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
                child: Text("Забыли пароль?", style: TextStyle(color: const Color(0xff317EFA), fontSize: 14.sp),),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xff317EFA),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    )
                ), onPressed: () { 
                  Dio dio = Dio();
                  RestClient client = RestClient(dio);
                  String phoneNumber = "";
                  if(phone![0].contains("8")){
                    phoneNumber+= phone!.replaceFirst("8", "7");
                  }else{
                    phoneNumber+= phone!;
                  }
                  client.adminLogin(phoneNumber, password!).then((value){
                    print("User uid ${value.uid}");
                    FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: "+$phoneNumber",
                        verificationCompleted: (_){
                          print("Complete");
                        },
                        verificationFailed: (_){
                          print("Failed");
                        },
                        codeSent: (_,__){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CodeEnterLoginPage(verifyId: _, userEntity: value,)),
                          );
                        },
                        codeAutoRetrievalTimeout: (_){
                          print("TimeOut");
                        }
                    );
                  }).onError((error, stackTrace){
                    print("Mb error ${error}");
                    if(error is DioException){
                     _displayErrorMotionToast(error.response!.data);
                    }
                  });
              }, child: const Text("Войти", style: TextStyle(color: Colors.white),),
                
              ),
            )
          ],
        ),
      ),
    );
  }
  void _displayErrorMotionToast(String error) {
    MotionToast.error(
      title: const Text(
        'Ошибка',
        style: TextStyle(
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