import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/CountryEntity.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/auth/login_page.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/main_route.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget{
  final UserEntity user;
  const ProfilePage({required this.user,super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePage();
}
class _ProfilePage extends State<ProfilePage>{
  @override
  Widget build(BuildContext context) {
    UserEntity user = widget.user;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff317EFA)
              ),
              child: Padding(
                padding: EdgeInsets.all(3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? video = await picker.pickImage(source: ImageSource.gallery);
                            debugPrint("Media ${video!.name}");
                            File file = File.fromUri(Uri.parse(video.path));
                            Dio dio = Dio();
                            RestClient client = RestClient(dio);
                            client.changePhoto(GlobalsWidgets.uid, file).then((value){
                              setState(() {
                                GlobalsWidgets.image = value;
                              });
                            });
                          },
                          child: Ink(
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(40), // Image radius
                                child: Image.network(GlobalsWidgets.getUserPhoto(), fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                        SizedBox.fromSize(size: const Size.fromRadius(40), child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: const Size.fromRadius(12).height,
                            width: const Size.fromRadius(12).width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: Icon(Icons.edit, size: 5.w,),
                          ),
                        ),)
                      ],
                    ),
                    Text("${user.name} ${user.surname}", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.wallet_outlined, color: Colors.white,size: 10.w,),
                            SizedBox(width: 3.w,),
                            Text("${user.wallet.round()} ₸",style: TextStyle(fontSize: 18.sp,color: Colors.white))
                          ],
                        ),
                        OutlinedButton(
                            onPressed: (){
                              launchUrl(Uri.parse("https://Wa.me/77075926691"),mode: LaunchMode.externalApplication);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white)
                            ),
                            child: Text(S.of(context).add_money, style: const TextStyle(color: Colors.white),))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_history, color: Colors.white,size: 10.w,),
                            SizedBox(width: 3.w,),
                            Text("${user.location.city}",style: TextStyle(fontSize: 18.sp,color: Colors.white))
                          ],
                        ),
                        OutlinedButton(
                            onPressed: () async {
                              Dio dio = Dio();
                              RestClient client  = RestClient(dio);
                              List<CountryEntity> list = await client.getCountries();
                              CountryEntity initialCountry = list.first;
                              CityEntity initialCity = initialCountry.cities.first;
                              for(int i = 0; i < list.length; i++){
                                if(list[i].name.contains(user.location.country.name)){
                                  initialCountry = list[i];
                                  break;
                                }
                              }
                              for(int i = 0; i < initialCountry.cities.length; i++){
                                if(initialCountry.cities[i].name.contains(user.location.city.name)){
                                  initialCity = initialCountry.cities[i];
                                  break;
                                }
                              }
                              if(context.mounted){
                                showDialog(context: context,
                                    builder: (context){
                                      return StatefulBuilder(builder: (context, state){
                                        return AlertDialog(
                                          title: Text(S.of(context).edit_location,style: TextStyle(fontSize: 16.sp),),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomDropdown<CountryEntity>(
                                                items: list,
                                                initialItem: initialCountry,
                                                hintText: S.of(context).select_country,
                                                decoration: CustomDropdownDecoration(
                                                  closedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                                  closedFillColor: Colors.transparent,
                                                  expandedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                                  expandedFillColor: Colors.white,
                                                ),
                                                onChanged: (country) {
                                                  initialCountry = country;
                                                  initialCity = country.cities.first;
                                                  state(() {

                                                  });
                                                },
                                              ),
                                              SizedBox(height: 1.h,),
                                              CustomDropdown<CityEntity>(
                                                items: initialCountry.cities,
                                                initialItem: initialCity,
                                                hintText: S.of(context).select_city,
                                                decoration: CustomDropdownDecoration(
                                                  closedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                                  closedFillColor: Colors.transparent,
                                                  expandedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                                  expandedFillColor: Colors.white,
                                                ),
                                                onChanged: (city) {
                                                  initialCity = city;
                                                },
                                              )
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                textStyle: Theme.of(context).textTheme.labelLarge,
                                              ),
                                              child: Text(S.of(context).cancel),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                textStyle: Theme.of(context).textTheme.labelLarge,
                                              ),
                                              child: Text(S.of(context).ok),
                                              onPressed: () {
                                                Dio dio = Dio();
                                                RestClient client = RestClient(dio);
                                                client.changeLocation(GlobalsWidgets.uid, initialCountry.id, initialCity.id).then((value){
                                                  Navigator.pushAndRemoveUntil(context,
                                                      MaterialPageRoute(builder: (context)=>MainRoute(userEntity: value)), (route) => false);
                                                });

                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    });
                              }
                            },
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white)
                            ),
                            child: Text(S.of(context).edit, style: const TextStyle(color: Colors.white),))
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            InkWell(
              onTap: () async {
                GlobalsWidgets.uid = "";
                FirebaseAuth.instance.signOut();
                (await SharedPreferences.getInstance()).remove("phone");
                if(context.mounted){
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.exit_to_app),
                  SizedBox(width: 5.w,),
                  Flexible(fit: FlexFit.tight,child: Text(S.of(context).exit, textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),)),
                  SizedBox(width: 5.w,),
                  const Icon(Icons.keyboard_arrow_right_sharp)
                ],
              ),
            ),
            SizedBox(height: 2.h,),
            InkWell(
              onTap: (){
                launchUrl(Uri.parse("https://Wa.me/77075926691"),mode: LaunchMode.externalApplication);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.help),
                  SizedBox(width: 5.w,),
                  Flexible(fit: FlexFit.tight,child: Text(S.of(context).help, textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),)),
                  SizedBox(width: 5.w,),
                  const Icon(Icons.keyboard_arrow_right_sharp)
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}