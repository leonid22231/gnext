import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/api/entity/CityEntity.dart';
import 'package:admin_app/api/entity/CountryEntity.dart';
import 'package:admin_app/api/entity/LocationEntity.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class ControlLocationPage extends StatefulWidget{
  bool? selectMode;
  ControlLocationPage({this.selectMode,super.key});
  @override
  State<StatefulWidget> createState() => _ControlLocationPage();
}
class _ControlLocationPage extends State<ControlLocationPage>{
  CountryEntity? selectedCountry;
  List<CityEntity>? cities;
  bool selectMode = false;
  @override
  Widget build(BuildContext context) {
    if(widget.selectMode!=null){
      selectMode = widget.selectMode!;
    }
    return Scaffold(
      floatingActionButton: selectedCountry!=null&&!selectMode?FloatingActionButton.large(
        onPressed: () {
          addCity();
        },
        backgroundColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        child: SizedBox(
          height: 10.h,
          width: 10.h,
          child: const Icon(
              Icons.add,
            color: Colors.white,
          ),
        ),
      ):null,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back_outlined,
              size: 5.w,
          ), onPressed: () {
            Navigator.pop(context);
        }),
        centerTitle: true,
        title: Text(!selectMode?"Управление локациями":"Выберите город", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: mainColor),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: FutureBuilder(
            future: getCountries(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                if(selectedCountry!=null){
                  for(int i = 0; i < snapshot.data!.length; i++){
                    if(snapshot.data![i].id==selectedCountry!.id){
                      cities = snapshot.data![i].cities;
                      break;
                    }
                  }
                }
                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Flexible(
                              fit: FlexFit.tight,
                              child: CustomDropdown<CountryEntity>(
                                items: snapshot.data!,
                                hintText: "Выберите страну",
                                decoration: CustomDropdownDecoration(
                                  closedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                  closedFillColor: Colors.transparent,
                                  expandedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                  expandedFillColor: Colors.white,
                                ),
                                onChanged: (country) {
                                  selectedCountry = country;
                                  cities = selectedCountry!.cities;
                                  setState(() {

                                  });
                                },
                              )
                          ),
                          SizedBox(width: 2.w,),
                          !selectMode?AspectRatio(
                              aspectRatio: 1,
                            child: InkWell(
                              onTap: (){
                                addCountry();
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Ink(
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ):const SizedBox.shrink()
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    cities!=null?ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index){
                            return _city(cities![index]);
                        }, 
                        separatorBuilder: (context, index){
                          return SizedBox(height: 2.h,);
                        }, 
                        itemCount: cities!.length
                    ):const SizedBox.shrink()
                  ],
                );
              }else{
                return const Center(child: Text("Загрузка..."),);
              }
            },
          ),
        ),
      ),
    );
  }
  addCountry() {
    showDialog(context: context, builder: (context)=>StatefulBuilder(builder: (context, state){
      String? temp_name;
      return AlertDialog(
        title: Text("Добавить страну", style: TextStyle(fontSize: 18.sp),),
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
                    hintText: "Введите название страны",
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
                      client.createCountry(temp_name!).then((value){
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
  }
  addCity(){
    showDialog(context: context, builder: (context)=>StatefulBuilder(builder: (context, state){
      String? temp_name;
      return AlertDialog(
        title: Text("Добавить город", style: TextStyle(fontSize: 18.sp),),
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
                      client.createCity(selectedCountry!.id,temp_name!).then((value){
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
  }
  Widget _city(CityEntity city){
    return InkWell(
      onTap: selectMode?(){
        LocationEntity locationEntity = LocationEntity(id: 0, country:selectedCountry!, city: city);
        Navigator.pop(context, locationEntity);
      }:null,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Text(city.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),),
        ),
      ),
    );
  }
  Future<List<CountryEntity>> getCountries(){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.getCountries();
  }
}