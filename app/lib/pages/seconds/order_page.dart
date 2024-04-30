import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/OrderEntity.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/seconds/chat_page.dart';
import 'package:app/pages/seconds/user_profile.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderPage extends StatelessWidget{
  final OrderEntity order;
  const OrderPage({required this.order,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).search_, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h).copyWith(bottom: 15.h),
        child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff787878),
              borderRadius: BorderRadius.circular(15)
            ),
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !order.outCity?IntrinsicHeight(
                  child: Row(
                    children: [
                      VerticalDivider(thickness: 0.5.w,indent: 0, endIndent: 0,width: 0.5.w,color: Colors.white,),
                      SizedBox(width: 2.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${order.addressFrom.street}, ${order.addressFrom.house??""} ->", style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),),
                          SizedBox(height: 1.h,),
                          Text(
                            "${DateFormat("dd EE.").format(order.startDate.toLocal())} - ${DateFormat("dd EE, MMM").format(order.endDate.toLocal())}",
                            style: TextStyle(color: const Color(0xffCFCFCF), fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2.h,),
                          Text("${order.addressTo.street}, ${order.addressTo.house??""}", style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold))
                        ],
                      )
                    ],
                  ),
                ):IntrinsicHeight(
                  child: Row(
                    children: [
                      VerticalDivider(thickness: 0.5.w,indent: 0, endIndent: 0,width: 0.5.w,color: Colors.white,),
                      SizedBox(width: 2.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${order.addressFrom.city} ->", style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),),
                          SizedBox(height: 1.h,),
                          Text(
                            "${DateFormat("dd EE.").format(order.startDate.toLocal())} - ${DateFormat("dd EE, MMM").format(order.endDate.toLocal())}",
                            style: TextStyle(color: const Color(0xffCFCFCF), fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2.h,),
                          Text(order.addressTo.city, style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 2.h,),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${order.price.round()} ₸", style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.bold),),
                      SizedBox(width: 1.w,),
                      order.customPrice?Text("*${S.of(context).dog}", style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),):const SizedBox.shrink()
                    ],
                  ),
                ),
                SizedBox(height: 1.h,),
                Align(alignment: Alignment.center,child: Text("${S.of(context).desc}:", style: TextStyle(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.w700 ),),),
                SizedBox(height: 1.h,),
                Expanded(child: Text(
                  order.description!, style: TextStyle(color: Colors.white,fontSize: 16.sp,fontWeight: FontWeight.w700 ),
                )),
                order.creator.uid!=GlobalsWidgets.uid?Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.h),
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(25), // Image radius
                                child: Image.network(GlobalsWidgets.getPhoto(order.creator.photo), fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(width: 4.w,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${order.creator.name} ${order.creator.surname}", textAlign: TextAlign.start,style: TextStyle(fontSize: 16.sp,color: Colors.white),),
                                SizedBox(height: 1.h,),
                                Text("+${order.creator.phone}", textAlign: TextAlign.start,style: TextStyle(fontSize: 14.sp,color: Colors.white),),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      SizedBox(
                        width: double.maxFinite,
                        height: 5.h,
                        child: OutlinedButton(
                            onPressed: (){
                              Dio dio = Dio();
                              RestClient client = RestClient(dio);
                              client.findChat(GlobalsWidgets.uid, order.creator.uid,null).then((value){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>UserProfile(user: order.creator,)));
                              });
                            },
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white)
                            ),
                            child: Text(S.of(context).connect, style: const TextStyle(color: Colors.white),)),

                      ),
                      SizedBox(height: 2.h,),
                      order.file==null?const SizedBox.shrink():SizedBox(
                        width: double.maxFinite,
                        height: 5.h,
                        child: OutlinedButton(
                            onPressed: () async {
                              var status = await Permission.storage.status;
                              if (status.isDenied) {
                                requestPermission(Permission.manageExternalStorage);
                                requestPermission(Permission.storage);
                              }
                              //
                              FileDownloader.downloadFile(
                                  downloadDestination: DownloadDestinations.publicDownloads,
                                  url: "http://${GlobalsWidgets.ip}:8080/api/v1/file/file/${order.file!}",
                                  name: "file_${DateFormat("dd MM y mm:SS").format(DateTime.now())}.${order.file!.split(".")[1]}",
                                  onDownloadCompleted: (str){
                                    Fluttertoast.showToast(
                                        msg: "Файл file_${DateFormat("dd MM y mm:SS").format(DateTime.now())}.${order.file!.split(".")[1]} сохранен в папке ${str.split("/")[str.split("/").length-2]}",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                              );

                            },
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white)
                            ),
                            child: Text("${S.of(context).download_file} .${order.file!.split(".")[1]}", style: const TextStyle(color: Colors.white),)),

                      ),
                    ],
                  ),
                ):SizedBox(
                  width: double.maxFinite,
                  height: 5.h,
                  child: OutlinedButton(
                      onPressed: (){
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        client.stopOrder(order.id).then((value){
                          Navigator.pop(context);
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white)
                      ),
                      child: Text(S.of(context).end, style: const TextStyle(color: Colors.white),)),

                ),
              ],
            ),
          ),
          ),
        ),
    );
  }
  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}