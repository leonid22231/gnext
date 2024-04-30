import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import "package:admin_app/utils/globals.dart";
class CodeEnterLoginPage extends StatefulWidget{
  CodeEnterLoginPage({super.key,required this.verifyId,required this.userEntity});
  String verifyId;
  UserEntity userEntity;
  @override
  State<StatefulWidget> createState() => _CodeEnterLoginPage();
}
class _CodeEnterLoginPage extends State<CodeEnterLoginPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Введите код", style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),),
              SizedBox(height: 2.h,),
              Pinput(
                onCompleted: (pin){
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verifyId, smsCode: pin);
                  FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                    uid = FirebaseAuth.instance.currentUser!.uid;
                    name = widget.userEntity.name;
                    surname = widget.userEntity.surname;
                    image = widget.userEntity.photo;
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) => HomePage(user: widget.userEntity)), (route) => false);
                  });
                },
                length: 6,
              )
            ],
          ),
        ),
      ),
    );
  }
}