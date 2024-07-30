import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/TransportationEntity.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/seconds/user_profile.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TransportationViewPage extends StatelessWidget {
  final TransportationEntity transportation;
  final String title;
  const TransportationViewPage(
      {required this.transportation, required this.title, super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${S.of(context).search} $title",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h).copyWith(bottom: 15.h),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: const Color(0xff787878),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !transportation.outCity
                    ? IntrinsicHeight(
                        child: Row(
                          children: [
                            VerticalDivider(
                              thickness: 0.5.w,
                              indent: 0,
                              endIndent: 0,
                              width: 0.5.w,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${transportation.addressFrom.street}, ${transportation.addressFrom.house ?? ""} ->",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text(
                                  DateFormat("dd EE.")
                                      .format(transportation.date.toLocal()),
                                  style: TextStyle(
                                      color: const Color(0xffCFCFCF),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                    "${transportation.addressTo.street}, ${transportation.addressTo.house ?? ""}",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ],
                            )
                          ],
                        ),
                      )
                    : IntrinsicHeight(
                        child: Row(
                          children: [
                            VerticalDivider(
                              thickness: 0.5.w,
                              indent: 0,
                              endIndent: 0,
                              width: 0.5.w,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${transportation.addressFrom.city} ->",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(transportation.addressTo.city,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ],
                            )
                          ],
                        ),
                      ),
                SizedBox(
                  height: 2.h,
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${transportation.price.round()} ₸",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      //order.customPrice?Text("*${S.of(context).dog}", style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),):const SizedBox.shrink()
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${S.of(context).desc}:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                    child: Text(
                  transportation.description,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700),
                )),
                transportation.creator.uid != GlobalsWidgets.uid
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.h),
                        child: Column(
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          25), // Image radius
                                      child: Image.network(
                                          GlobalsWidgets.getPhoto(
                                              transportation.creator.photo),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${transportation.creator.name} ${transportation.creator.surname}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Text(
                                        "+${transportation.creator.phone}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              height: 5.h,
                              child: OutlinedButton(
                                  onPressed: () {
                                    Dio dio = Dio();
                                    RestClient client = RestClient(dio);
                                    client
                                        .findChat(GlobalsWidgets.uid,
                                            transportation.creator.uid, null)
                                        .then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UserProfile(
                                                    user:
                                                        transportation.creator,
                                                  )));
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.white)),
                                  child: Text(
                                    S.of(context).connect,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        width: double.maxFinite,
                        height: 5.h,
                        child: OutlinedButton(
                            onPressed: transportation.active
                                ? () {
                                    Dio dio = Dio();
                                    RestClient client = RestClient(dio);
                                    client
                                        .stopTransportation(transportation.id)
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  }
                                : null,
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white)),
                            child: Text(
                              transportation.active
                                  ? S.of(context).end
                                  : S.of(context).transport_end,
                              style: const TextStyle(color: Colors.white),
                            )),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
