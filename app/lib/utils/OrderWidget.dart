import 'dart:developer';

import 'package:app/api/entity/OrderEntity.dart';
import 'package:app/pages/seconds/order_page.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderWidget extends StatelessWidget {
  final OrderEntity order;
  final bool? sub;
  final Function()? update;
  const OrderWidget({required this.order, this.update, this.sub, super.key});

  @override
  Widget build(BuildContext context) {
    log("Sub $sub && update ${update}");
    if (sub != null && sub! && update == null) {
      throw Exception('Not present update method');
    }
    return InkWell(
      onTap: sub ?? false
          ? () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => OrderPage(order: order)))
                  .then((value) {
                update!.call();
              });
            }
          : null,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: GlobalsColor.userCardColor),
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  order.outCity
                      ? Text(
                          "${order.addressFrom.city} ->",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "${order.addressFrom.street}${order.addressFrom.house != null ? "," : ""} ${order.addressFrom.house ?? ""} ->",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                  Text(
                    "${order.price.round()} ₸",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  order.outCity
                      ? Text(order.addressTo.city,
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))
                      : Text(
                          "${order.addressTo.street}${order.addressFrom.street != null ? "," : ""} ${order.addressTo.house ?? ""}",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${DateFormat("dd EE.").format(order.startDate.toLocal())} - ${DateFormat("dd EE, MMM").format(order.endDate.toLocal())}",
                    style: TextStyle(
                        color: const Color(0xffCFCFCF),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat("dd MMM").format(order.createDate.toLocal()),
                    style: TextStyle(
                        color: const Color(0xffCFCFCF),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
