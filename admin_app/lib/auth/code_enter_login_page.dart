import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/home_page.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeEnterLoginPage extends StatefulWidget{
  const CodeEnterLoginPage({super.key,required this.code, required this.phone});
  final String code;
  final String phone;
  @override
  State<StatefulWidget> createState() => _CodeEnterLoginPage();
}
class _CodeEnterLoginPage extends State<CodeEnterLoginPage>{
  @override
  Widget build(BuildContext context) {
    debugPrint("Code ${widget.code}");
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Введите код", style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),),
            SizedBox(height: 2.h,width: double.maxFinite,),
            Pinput(
              onCompleted: (pin){
                if(pin==widget.code){
                  Dio dio = Dio();
                  RestClient client = RestClient(dio);
                  client.loginConfirm(widget.phone, uid).then((value) async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.setString("phone", widget.phone);
                    name = value.name;
                    image = value.photo;
                    surname = value.surname;
                    if(context.mounted){
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => HomePage(user: value,)), (route) => false);
                    }
                  });
                }else{
                  _displayErrorMotionToast("Неверный код");
                }
              },
              length: 4,
            )
          ],
        ),
      ),
    );
  }
  void _displayErrorMotionToast(String error) {
    MotionToast.error(
      title: const Text(
        "Ошибка",
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