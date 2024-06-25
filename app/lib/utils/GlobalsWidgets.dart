import 'package:app/api/entity/enums/UserRole.dart';
import 'package:flutter/cupertino.dart';

class GlobalsWidgets {
  //45.159.250.175
  //192.168.0.102
  static String ip = "45.159.250.175";
  static String uid = "";
  static String name = "";
  static String surname = "";
  static String? telegram;
  static String? whatsapp;
  static double wallet = 0;
  static UserRole role = UserRole.USER;
  static String? image;
  static List<String> chats = [
    "evacuator",
    "razbor",
    "market",
    "global",
    "gruz"
  ];
  static String getUserPhoto() {
    if (GlobalsWidgets.image != null && GlobalsWidgets.image!.isNotEmpty) {
      return 'http://${GlobalsWidgets.ip}:8080/api/v1/file/image/${GlobalsWidgets.image}';
    } else {
      return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnGZWTF4dIu8uBZzgjwWRKJJ4DisphDHEwT2KhLNxBAA&s';
    }
  }

  static String getPhoto(String? image) {
    if (image != null && image.isNotEmpty) {
      return 'http://${GlobalsWidgets.ip}:8080/api/v1/file/image/$image';
    } else {
      return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnGZWTF4dIu8uBZzgjwWRKJJ4DisphDHEwT2KhLNxBAA&s';
    }
  }

  static String getStoryPhoto(String image) {
    return 'http://${GlobalsWidgets.ip}:8080/api/v1/storis/photo/$image';
  }

  static String getStoryVideo(String video) {
    return 'http://${GlobalsWidgets.ip}:8080/api/v1/storis/video/$video';
  }
}
