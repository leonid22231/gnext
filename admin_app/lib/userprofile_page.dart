import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/api/entity/enums/UserRole.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:admin_app/utils/globals.dart';
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
                        child: Image.network(getPhoto(user.photo), fit: BoxFit.cover),
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
                    SizedBox(height: 2.h,),
                    InkWell(
                      onTap: (){
                          showDialog(context: context, builder: (context)=>AlertDialog(
                            title: const Text("Изменить роль"),
                            content: CustomDropdown<UserRole>(
                              items: UserRole.values,
                              hintText: "Выберите роль",
                              initialItem: user.role,
                              decoration: CustomDropdownDecoration(
                                closedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                closedFillColor: Colors.transparent,
                                expandedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                expandedFillColor: Colors.white,
                              ),
                              onChanged: (role) {
                                Dio dio = Dio();
                                RestClient client = RestClient(dio);
                                client.changeRole(user.uid, role);
                              },
                            ),
                          )).then((value) => Navigator.of(context).pop());
                      },
                      splashColor: Colors.black,
                      child: Container(
                        height: 8.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border:Border.all(color: Colors.white, width: 1.w)
                        ),
                        child: Center(
                          child: Text(getRole(user.role), style: TextStyle(fontSize: 16.sp, color: Colors.white),),
                        ),
                      ),
                    ),
                    const Spacer(),
                    //SizedBox(height: 1.h,),
                    uid!=user.uid?SizedBox(
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
                          child: Text(S.of(context).call, style: TextStyle(fontSize: 16.sp,color: const Color(0xff317EFA)),)),

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
