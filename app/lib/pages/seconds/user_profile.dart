import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/seconds/chat_page.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatelessWidget{
  final UserEntity user;
  const UserProfile({required this.user,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).user, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60.h,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xff317EFA),
              ),
              child: Padding(
                padding: EdgeInsets.all(2.h),
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(50), // Image radius
                        child: Image.network(GlobalsWidgets.getPhoto(user.photo), fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    Text("${user.name} ${user.surname}", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),),
                    SizedBox(height: 1.h,),
                    Text("+${user.phone}", textAlign: TextAlign.start,style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                    SizedBox(height: 1.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_history, color: Colors.white,size: 10.w,),
                        SizedBox(width: 3.w,),
                        Text("${user.location.city}",style: TextStyle(fontSize: 18.sp,color: Colors.white))
                      ],
                    ),
                    const Spacer(),
                    GlobalsWidgets.uid!=user.uid?SizedBox(
                      width: double.maxFinite,
                      height: 5.h,
                      child: OutlinedButton(
                          onPressed: (){
                              Dio dio = Dio();
                              RestClient client = RestClient(dio);
                              client.findChat(GlobalsWidgets.uid, user.uid, null).then((value){
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: user.name, chatName: value)));
                              });
                          },
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white)
                          ),
                          child: Text(S.of(context).typing, style: const TextStyle(color: Colors.white),)),

                    ):const SizedBox.shrink(),
                    SizedBox(height: 1.h,),
                    GlobalsWidgets.uid!=user.uid?SizedBox(
                      width: double.maxFinite,
                      height: 5.h,
                      child: OutlinedButton(
                          onPressed: (){
                            launchUrl(Uri.parse("tel://+${user.phone}"));
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              backgroundColor: Colors.white
                          ),
                          child: Text(S.of(context).call, style: const TextStyle(color: Color(0xff317EFA)),)),

                    ):const SizedBox.shrink()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
