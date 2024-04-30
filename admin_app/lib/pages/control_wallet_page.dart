import 'dart:async';

import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/api/entity/WalletEventH.dart';
import 'package:admin_app/api/entity/enums/EventResult.dart';
import 'package:admin_app/api/entity/enums/WalletEvent.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class ControlWalletPage extends StatefulWidget{
  UserEntity user;
  ControlWalletPage({required this.user,super.key});
  @override
  State<StatefulWidget> createState() => _ControlWalletPage();
}
class _ControlWalletPage extends State<ControlWalletPage>{
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
        title: Text("Управление кошельками", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: mainColor),),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        child: FutureBuilder(
                          future: findUser(widget.user.uid),
                          builder: (context,snapshot){
                            if(snapshot.hasData){
                              UserEntity user = snapshot.data!;
                              return Container(
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ]
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2.h),
                                  child: Column(
                                    children: [
                                      ClipOval(
                                        child: SizedBox.fromSize(
                                          size: Size.fromRadius(10.w), // Image radius
                                          child: Image.network(getUserPhoto(), fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text("${user.name} ${user.surname}", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),),
                                      SizedBox(height: 1.h,),
                                      Text("+${user.phone}", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                                      SizedBox(height: 2.h,),
                                      Container(
                                        height: 4.h,
                                        width: 20.w,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: Color(0xFFAEB4B7), width: 0.3.w)
                                        ),
                                        child: Center(
                                          child: Text(getRole(user.role), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: Colors.white),),
                                        ),
                                      ),
                                      SizedBox(height: 2.h,),
                                      Container(
                                        height: 4.h,
                                        width: 20.w,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: Color(0xFFAEB4B7), width: 0.3.w)
                                        ),
                                        child: Center(
                                          child: Text("${user.wallet.round()} ₸", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.white),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }else{
                              return Center(child: Text("Загрузка..."),);
                            }
                          },
                        )),
                    SizedBox(width: 2.w,),
                    Flexible(child:
                    GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      mainAxisSpacing: 2.w,
                      crossAxisSpacing: 2.w,
                      crossAxisCount: 2,
                      children: [
                        InkWell(
                          onTap: (){
                            _action(widget.user.uid,WalletEvent.ADD);
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Center(child: Text("Добавить +", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15.sp),)),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                                _action(widget.user.uid,WalletEvent.SUBTRACT);
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Center(child: Text("Вычесть -", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15.sp),)),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            _action(widget.user.uid,WalletEvent.PAYMENT);
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Center(child: Text("Оплата <-", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15.sp),)),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            _action(widget.user.uid,WalletEvent.ADJUST);
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Center(child: Text("Скорректировать =", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.sp),)),
                          ),
                        ),
                      ],
                    )
                    )
                  ],
                ),
              SizedBox(height: 2.h,),
              FutureBuilder(future: findHistory(widget.user.uid), builder: (context,snapshot){
                if(snapshot.hasData){
                  List<WalletEventH> list = snapshot.data!;
                  list = list.reversed.toList();
                  return ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index){
                          return _event(list[index]);
                      },
                      separatorBuilder: (context,index){
                        return SizedBox(height: 1.h,);
                      },
                      itemCount: snapshot.data!.length
                  );
                }else{
                  print("Event error ${snapshot.error}");
                  return Center(child: Text("Загрузка..."),);
                }
              })
            ],
          ),
        ),
      ),
    );
  }
  Future<List<WalletEventH>> findHistory(String uid){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.findWalletHistory(uid);
  }
  Future<UserEntity> findUser(String uid){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.getUserByUid(uid);
  }
  Widget _event(WalletEventH walletEventH) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: walletEventH.result==EventResult.DONE?mainColor:Colors.red
      ),
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: Row(
          children: [
            Flexible(fit: FlexFit.tight,child: Text(_name(walletEventH.type), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 14.sp),)),
            Flexible(fit: FlexFit.tight,child: Text("Сумма: ${walletEventH.sum.round()} ₸", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 14.sp))),
            Flexible(fit: FlexFit.tight,child: Text(DateFormat("dd.MM HH:mm").format(walletEventH.date.toLocal()),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 14.sp))),
            Flexible(fit: FlexFit.tight,child: Text("Статус: ${_status(walletEventH.result)}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 14.sp)))
          ],
        ),
      ),
    );
  }
  String _name(WalletEvent event){
    switch(event){
      case WalletEvent.ADD: return "Добавление";
      case WalletEvent.SUBTRACT: return "Вычитание";
      case WalletEvent.PAYMENT: return "Оплата";
      case WalletEvent.ADJUST: return "Корректировка";
    }
  }
  String _status(EventResult eventResult){
    switch(eventResult){
      case EventResult.CANCEL: return "Отмена";
      case EventResult.DONE: return "Выполнен";
      case EventResult.ERROR: return "Ошибка";
    }
  }
  void _action(String uid,WalletEvent event) {
    showDialog(context: context, builder: (context)=>StatefulBuilder(builder: (context, state){
      double? sum;
      return AlertDialog(
        title: Text("Введите сумму", style: TextStyle(fontSize: 18.sp),),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Сумма", style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
              SizedBox(height: 1.h,),
              SizedBox(
                width: 50.w,
                height: 8.h,
                child: TextFormField(
                  onChanged: (value){
                    sum = double.parse(value);
                  },
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                  style: TextStyle(fontSize: 16.sp),
                  decoration: InputDecoration(
                    hintText: "Введите сумму",
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
                      client.walletEvent(uid,event,sum!).then((value){
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
}