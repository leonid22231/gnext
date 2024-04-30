import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/api/entity/CompanyEntity.dart';
import 'package:admin_app/api/entity/LocationEntity.dart';
import 'package:admin_app/api/entity/enums/Categories.dart';
import 'package:admin_app/utils/category_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class ControlCompaniesPage extends StatefulWidget{
  LocationEntity location;
  ControlCompaniesPage({required this.location,super.key});
  @override
  State<StatefulWidget> createState() => _ControlCompaniesPage();
}
class _ControlCompaniesPage extends State<ControlCompaniesPage>{
  List<bool> oppened = [
    false
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              size: 5.w,
            ), onPressed: () {
          Navigator.pop(context);
        }),
        centerTitle: true,
        title: Text("Управление компаниями", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: mainColor),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: [
              getCompany("Справочник", Categories.info),
              getCompany("СТО", Categories.sto),
              getCompany("Переоборудование газелей", Categories.modify),
              getCompany("Свап", Categories.swap),
              getCompany("Автосалон", Categories.auto),
            ],
          ),
        ),
      ),
    );
  }
  Widget getCompany(String name,Categories category){
    return FutureBuilder(
        future: findCompany(category),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return CategoryWidget(name: name,category: category, companies: snapshot.data!, location: widget.location,update: (){
              setState(() {

              });
            },);
          }else{
            return Center(child: Text("Загрузка..."),);
          }
        }
        );
  }
  Future<List<CompanyEntity>> findCompany(Categories category){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.findCompanies(widget.location.country.id, widget.location.city.id, category);
  }
}