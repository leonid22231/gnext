import 'package:app/api/RestClient.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/main_route.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeEnterLoginPage extends StatefulWidget{
  const CodeEnterLoginPage({super.key,required this.code, required this.phone, required this.niceCode});
  final String code;
  final String phone;
  final Function() niceCode;
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
            Text(S.of(context).enter_code, style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),),
            SizedBox(height: 2.h,width: double.maxFinite,),
            Pinput(
              onCompleted: (pin){
                if(pin==widget.code){
                  widget.niceCode.call();
                }else{
                  _displayErrorMotionToast(S.of(context).code_error);
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