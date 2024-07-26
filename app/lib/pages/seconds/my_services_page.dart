import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/OrderEntity.dart';
import 'package:app/api/entity/enums/OrderMode.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/seconds/user_profile.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyServicesPage extends StatefulWidget {
  final OrderMode mode;
  const MyServicesPage({required this.mode, super.key});

  @override
  State<StatefulWidget> createState() => _MyServicesPageState();
}

class _MyServicesPageState extends State<MyServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).my_orders),
      ),
      body: Padding(
        padding: EdgeInsets.all(3.h),
        child: FutureBuilder(
            future: RestClient(Dio())
                .myOrders(GlobalsWidgets.uid, true, widget.mode),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<OrderEntity> orders = snapshot.data!;
                return ListView.separated(
                    // shrinkWrap: true,
                    // primary: false,
                    itemBuilder: (context, index) {
                      OrderEntity currentOrder = orders[index];
                      return Container(
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 8.h,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: Image.network(
                                          height: 8.h,
                                          width: 8.h,
                                          fit: BoxFit.cover,
                                          GlobalsWidgets.getPhoto(
                                              currentOrder.creator.photo)),
                                    ),
                                    Text(
                                        "${currentOrder.creator.name} ${currentOrder.creator.surname}")
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                color: Colors.black,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${currentOrder.price} ₸"),
                                  Divider(
                                    color: Colors.black.withOpacity(0.2),
                                    height: 1,
                                  ),
                                  Text(currentOrder.description!),
                                  Divider(
                                    color: Colors.black.withOpacity(0.2),
                                    height: 1,
                                  ),
                                  Text(
                                      "${S.of(context).create_ate} ${DateFormat("d MMMM, HH:mm").format(currentOrder.createDate)}")
                                ],
                              )),
                              const VerticalDivider(
                                color: Colors.black,
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 8.w,
                                    backgroundColor: GlobalsColor.blue,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfile(
                                                          user: currentOrder
                                                              .creator)));
                                        },
                                        icon: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  CircleAvatar(
                                    radius: 8.w,
                                    backgroundColor: Colors.redAccent,
                                    child: IconButton(
                                        onPressed: () {
                                          RestClient(Dio())
                                              .stopOrder(currentOrder.id)
                                              .then((val) => setState(() {}));
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 2.h,
                        color: Colors.black,
                      );
                    },
                    itemCount: orders.length);
              } else {
                return const SizedBox.shrink();
              }
            }),
      ),
    );
  }
}
