import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/OrderEntity.dart';
import 'package:app/api/entity/enums/Mode.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/seconds/order_page.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TransportationPage extends StatefulWidget{
  final bool sub;
  const TransportationPage({required this.sub,super.key});

  @override
  State<StatefulWidget> createState() => TransportationPageState();

}
class TransportationPageState extends State<TransportationPage> with TickerProviderStateMixin{
  Mode selectedMode = Mode.CITY;
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h).copyWith(top: 0),
      child: Column(
        children: [
          ButtonsTabBar(
              controller: _controller,
              backgroundColor: GlobalsColor.blue,
              unselectedBackgroundColor: Colors.white,
              unselectedLabelStyle: const TextStyle(color: Colors.black),
              labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              onTap: (index){
                selectedMode = Mode.values[index];
                ChangeModeNotify(selectedMode).dispatch(context);
                setState(() {

                });
              },
              tabs: [
                Tab(
                  text: S.of(context).city,
                ),
                Tab(
                  text: S.of(context).no_city,
                ),
              ],
            ),
          _getBody(selectedMode)
        ],
      ),
    );
  }
  Widget _getBody(Mode mode){
    switch(mode){
      case Mode.CITY: return Expanded(
          child: SizedBox(
            child: FutureBuilder(
              future: getMyOrders(false),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<OrderEntity> list =  snapshot.data!;
                  return ListView.separated(
                    itemCount: list.length, 
                    itemBuilder: (context,index) {
                      OrderEntity order = list[index];
                      return InkWell(
                        onTap: (GlobalsWidgets.role==UserRole.USER || (widget.sub && GlobalsWidgets.role==UserRole.SPECIALIST))?(){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=>OrderPage(order: order))
                          ).then((value){
                            setState(() {

                            });
                          });
                        }:null,
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: const Color(0xff787878)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${order.addressFrom.street}, ${order.addressFrom.house??""} ->", style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),),
                                    Text("${order.price.round()} ₸", style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                SizedBox(height: 1.h,),
                                Row(
                                  children: [
                                    Text("${order.addressTo.street}, ${order.addressTo.house??""}", style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(height: 1.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${DateFormat("dd EE.").format(order.startDate.toLocal())} - ${DateFormat("dd EE, MMM").format(order.endDate.toLocal())}",
                                      style: TextStyle(color: const Color(0xffCFCFCF), fontSize: 14.sp, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      DateFormat("dd MMM").format(order.createDate.toLocal()),
                                      style: TextStyle(color: const Color(0xffCFCFCF), fontSize: 14.sp, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }, 
                    separatorBuilder: (BuildContext context, int index) { 
                    return SizedBox(height: 2.h,);
                  },
                    
                  );
                }else{
                  return const SizedBox.shrink();
                }
              },
            ),
          )
      );
      case Mode.OUTCITY: return Expanded(
          child: SizedBox(
            child: FutureBuilder(
              future: getMyOrders(true),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<OrderEntity> list =  snapshot.data!;
                  return ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (context,index) {
                      OrderEntity order = list[index];
                      return InkWell(
                        onTap: (GlobalsWidgets.role==UserRole.USER || (widget.sub && GlobalsWidgets.role==UserRole.SPECIALIST))?(){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=>OrderPage(order: order))
                          ).then((value){
                            setState(() {

                            });
                          });
                        }:null,
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: const Color(0xff787878)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${order.addressFrom.city} ->", style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),),
                                    Text("${order.price.round()} ₸", style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                SizedBox(height: 1.h,),
                                Row(
                                  children: [
                                    Text(order.addressTo.city, style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(height: 1.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${DateFormat("dd EE.").format(order.startDate.toLocal())} - ${DateFormat("dd EE, MMM").format(order.endDate.toLocal())}",
                                      style: TextStyle(color: const Color(0xffCFCFCF), fontSize: 14.sp, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      DateFormat("dd MMM").format(order.createDate.toLocal()),
                                      style: TextStyle(color: const Color(0xffCFCFCF), fontSize: 14.sp, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 2.h,);
                    },

                  );
                }else{
                  return const SizedBox.shrink();
                }
              },
            ),
          )
      );
    }
  }
  update() => setState(() {

  });
  Future<List<OrderEntity>> getMyOrders(bool out){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.myOrders(GlobalsWidgets.uid, out);
  }
}
class ChangeModeNotify extends Notification{
  Mode mode;
  ChangeModeNotify(this.mode);
}
class CustomAddress{
  String street;
  String house;

  @override
  String toString() {
    return "$street, $house";
  }

  CustomAddress(this.street, this.house);
}