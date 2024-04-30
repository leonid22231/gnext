import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/CompanyEntity.dart';
import 'package:app/api/entity/enums/Categories.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/seconds/chat_page.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class CatalogPage extends StatefulWidget{
  final Categories category;
  const CatalogPage({required this.category,super.key});

  @override
  State<StatefulWidget> createState() => _CatalogPageState();

}
class _CatalogPageState extends State<CatalogPage>{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: FutureBuilder(
          future: findCompanies(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return Column(
                children: snapshot.data!.map((e) => Column(
                  children: [
                    _card(e),
                    SizedBox(height: 1.h,)
                  ],
                )).toList(),
              );
            }else{
              return Center(child: Text(S.of(context).loading),);
            }
          },
        ),
      ),
    );
  }
  Widget _card(CompanyEntity companyEntity){
      return Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffEDEEEF)
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.center,child: Text(companyEntity.name,style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),),),
              SizedBox(height: 1.h,),
              companyEntity.image!=null?SizedBox(
                child: SizedBox(
                  width: double.maxFinite,
                  height: 20.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(GlobalsWidgets.getPhoto(companyEntity.image), fit: BoxFit.fill,),
                  ),
                ),
              ):const SizedBox.shrink(),
              Row(
                children: [
                  Text(S.of(context).address,style: TextStyle(fontSize: 15.sp, color: Colors.black.withOpacity(0.6)),),
                  SizedBox(width: 2.w,),
                  Text("${companyEntity.address.street}, ${companyEntity.address.house}", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),)
                ],
              ),
              Divider(height: 1.h,),
              Align(
               alignment: Alignment.centerRight,
               child:  Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Text("+${companyEntity.phone}", style: TextStyle(fontSize: 16.sp),),
                   SizedBox(width: 2.w,),
                   IconButton(
                     padding: EdgeInsets.zero,
                     constraints: const BoxConstraints(),
                     visualDensity: VisualDensity.comfortable,
                     style: const ButtonStyle(
                       tapTargetSize: MaterialTapTargetSize.shrinkWrap, // the '2023' part
                     ),
                     onPressed: (){
                       launchUrl(Uri.parse("tel://+${companyEntity.phone}"));
                     }, icon: const Icon(Icons.call), color: Colors.green,)
                 ],
               ),
             ),
              (companyEntity.manager!=null)?SizedBox(height: 1.h,):const SizedBox.shrink(),
              (companyEntity.manager!=null)?Align(
                alignment: Alignment.center,
                child: SizedBox(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color: GlobalsColor.blue),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                              side: BorderSide.none
                          )
                      ),
                      onPressed: (){
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        client.findChat(GlobalsWidgets.uid, companyEntity.manager!.uid).then((value){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: companyEntity.name, chatName: value)));
                        });
                      },
                      child: Text(S.of(context).go_to_chat, style: TextStyle(color: GlobalsColor.blue),)
                  ),
                ),
              ):const SizedBox.shrink(),
            ],
          ),
        ),
      );
  }
  Future<List<CompanyEntity>> findCompanies(){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.findCompanies(GlobalsWidgets.uid, widget.category);
  }
}