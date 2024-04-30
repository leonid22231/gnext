import 'dart:ui';

import 'package:admin_app/api/entity/enums/UserRole.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motion_toast/motion_toast.dart';
//192.168.0.11
//45.67.35.206
String ip = "45.159.250.175";
String uid = "";
String name = "";
String surname = "";
String? image;
Color mainColor = const Color(0xff317EFA);
Color border = const Color(0xffD9D9D9);

String getUserPhoto() {
  if (image != null && image!.isNotEmpty) {
    return 'http://$ip:8080/api/v1/file/image/${image}';
  } else {
    return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnGZWTF4dIu8uBZzgjwWRKJJ4DisphDHEwT2KhLNxBAA&s';
  }
}
String getChatNameByDefaultName(String name){
  switch(name){
    case "evacuator":return "Эвакуатор";
    case "razbor":return "Переоборудование газелей";
    case "market":return "Авторынок";
    case "global":return "Глобальный";
    case "city":return "Грузы(По городу)";
    case "outcity":return "Грузы(Межгород)";
    case "gruz": return "Грузчики";
    case "spr": return "Справочник";
    case "sto": return "СТО";
    case "gaz": return "Переоборудование газелей";
    case "swap": return "Свап";
    case "salon": return "Автосалон";
    default: return "Ошибка";
  }
}
String getRole(UserRole role){
  switch(role){
    case UserRole.ADMIN: return "АДМИНИСТРАТОР";
    case UserRole.MANAGER: return "МЕНЕДЖЕР";
    case UserRole.SPECIALIST: return "СПЕЦИАЛИСТ";
    case UserRole.USER: return "ПОЛЬЗОВАТЕЛЬ";
  }
}
String getPhoto(String? image){
  if(image!=null && image.isNotEmpty){
    return 'http://$ip:8080/api/v1/file/image/$image';
  }else{
    return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnGZWTF4dIu8uBZzgjwWRKJJ4DisphDHEwT2KhLNxBAA&s';
  }
}
String getStoryPhoto(String image){
  return 'http://$ip:8080/api/v1/storis/photo/$image';
}
String getStoryVideo(String video){
  return 'http://$ip:8080/api/v1/storis/video/$video';
}
void displayError(String error, BuildContext context) {
  MotionToast.error(
    title: const Text(
      'Ошибка',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    description: Text(error),
    position: MotionToastPosition.top,
    barrierColor: Colors.black.withOpacity(0.3),
    width: 300,
    height: 80,
    dismissable: true,
  ).show(context);
}