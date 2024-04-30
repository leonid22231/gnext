import 'dart:io';

import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/api/entity/CompanyEntity.dart';
import 'package:admin_app/api/entity/LocationEntity.dart';
import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/api/entity/enums/Categories.dart';
import 'package:admin_app/pages/control_users_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:tap_to_expand/tap_to_expand.dart';
class CategoryWidget extends StatefulWidget{
  String name;
  List<CompanyEntity> companies;
  LocationEntity location;
  Categories category;
  Function() update;
  CategoryWidget({required this.update,required this.name,required this.companies,required this.location,required this.category, super.key});

  @override
  State<StatefulWidget> createState() => _CategoryWidget();

}
class _CategoryWidget extends State<CategoryWidget> with TickerProviderStateMixin{
  int? count = 0;
  late LocationEntity location;
  File? file;
  @override
  Widget build(BuildContext context) {
    location = widget.location;
    double? size = 0;
    if(widget.companies.isEmpty){
      count = null;
      size = null;
    }else{
      count = widget.companies.length;
      size = (count!+3 * 8.5.h) + (count!).h;
      print("Size $size");
    }
    return TapToExpand(
          borderRadius: 50,
          color: mainColor,
          openedHeight: size,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: widget.companies.map((e) => Column(
                  children: [
                    _company(e),
                    SizedBox(height: 1.h,)
                  ],
                )).toList(),
              ),
              SizedBox(height: 2.h,),
              SizedBox(
                width: double.maxFinite,
                height: 4.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green,
                    side: BorderSide(color: Colors.green)
                  ),
                    onPressed: (){
                      String? temp_name;
                      String? temp_phone;
                      String? temp_street;
                      String? temp_house;
                      showDialog(context: context, builder: (context)=>StatefulBuilder(builder: (context, state){
                        return AlertDialog(
                          title: Text("Добавить комапнию", style: TextStyle(fontSize: 18.sp),),
                          content: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Название", style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
                                SizedBox(height: 1.h,),
                                SizedBox(
                                  width: 50.w,
                                  height: 8.h,
                                  child: TextFormField(
                                    onChanged: (value){
                                      temp_name = value;
                                    },
                                    style: TextStyle(fontSize: 16.sp),
                                    decoration: InputDecoration(
                                      hintText: "Введите название города",
                                      hintStyle: TextStyle(fontSize: 16.sp),
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
                                SizedBox(height: 1.h,),
                                Text("Номер телефона", style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
                                SizedBox(height: 1.h,),
                                SizedBox(
                                  width: 50.w,
                                  height: 8.h,
                                  child: TextFormField(
                                    onChanged: (value){
                                      temp_phone = value;
                                    },
                                    style: TextStyle(fontSize: 16.sp),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                                    decoration: InputDecoration(
                                      hintText: "Введите номер телефона",
                                      hintStyle: TextStyle(fontSize: 16.sp),
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
                                SizedBox(height: 1.h,),
                                Align(alignment: Alignment.center,child: Text("Адрес", style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),),
                                Text("Улица", style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
                                SizedBox(height: 1.h,),
                                SizedBox(
                                  width: 50.w,
                                  height: 8.h,
                                  child: TextFormField(
                                    onChanged: (value){
                                      temp_street = value;
                                    },
                                    style: TextStyle(fontSize: 16.sp),
                                    decoration: InputDecoration(
                                      hintText: "Введите название",
                                      hintStyle: TextStyle(fontSize: 16.sp),
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
                                SizedBox(height: 1.h,),
                                Text("Номер дома", style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
                                SizedBox(height: 1.h,),
                                SizedBox(
                                  width: 50.w,
                                  height: 8.h,
                                  child: TextFormField(
                                    onChanged: (value){
                                      temp_house = value;
                                    },
                                    style: TextStyle(fontSize: 16.sp),
                                    decoration: InputDecoration(
                                      hintText: "Введите номер дома",
                                      hintStyle: TextStyle(fontSize: 16.sp),
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
                                widget.category==Categories.auto?SizedBox(
                                  width: 50.w,
                                  height: 6.h,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color(0xff317EFA),
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        )
                                    ), onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(source: ImageSource.gallery, preferredCameraDevice: CameraDevice.rear);
                                    print("Media ${image!.name}");
                                    file = File.fromUri(Uri.parse(image.path));

                                  }, child: const Text("Добавить фото", style: TextStyle(color: Colors.white),),

                                  ),
                                ):SizedBox.shrink(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text("Отмена",style: TextStyle(color: mainColor, fontSize: 14.sp))),
                                      SizedBox(width: 5.w,),
                                      TextButton(onPressed: (){
                                        Dio dio = Dio();
                                        RestClient client = RestClient(dio);
                                        String ph = "";
                                        if(temp_phone![0].contains("8")){
                                          ph+= temp_phone!.replaceFirst("8", "7");
                                        }
                                        client.addCompany(location.country.id,location.city.id,widget.category,temp_name!,ph,temp_street!,temp_house!, file).then((value){
                                          widget.update.call();
                                          Navigator.pop(context);
                                        }).onError((error, stackTrace){
                                          if(error is DioException){
                                            displayError(error.response!.data, context);
                                          }
                                        });
                                      }, child: Text("Добавить", style: TextStyle(color: mainColor, fontSize: 14.sp),)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      })).then((value) {
                        setState(() {

                        });
                      });
                    },
                    child: Text("Добавить",style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold) )
                ),
              )
            ],
          ),
          title: Text(widget.name, style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),),
    );
  }
  Widget _company(CompanyEntity companyEntity){
    return Material(
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: (){

        },
        borderRadius: BorderRadius.circular(50),
        child: Ink(
          height: 6.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50)
          ),
          padding: EdgeInsets.all(1.h),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: companyEntity.category==Categories.auto?null:(){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> ControlUsersPage(filter: true,selectMode: true,))
                    ).then((value){
                      Dio dio = Dio();
                      RestClient client = RestClient(dio);
                      UserEntity user = value as UserEntity;
                      client.setManager(user.uid, companyEntity.id).then((value){

                      });
                    });
                }, icon: Icon(Icons.person, color: companyEntity.category==Categories.auto?Colors.transparent:Colors.green,)),
                Text(companyEntity.name, style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 15.sp),),
                IconButton(onPressed: (){
                  Dio dio = Dio();
                  RestClient client = RestClient(dio);
                  client.deleteCompany(companyEntity.id).then((value){
                    setState(() {

                    });
                  });
                }, icon: const Icon(Icons.delete_outline_rounded, color: Colors.red,)),
              ],
            ),
          ),
        ),
    );
  }
}