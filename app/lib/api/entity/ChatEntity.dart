// ignore_for_file: file_names

import 'package:app/api/entity/MessageEntity.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/ChatMode.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ChatEntity.g.dart';

@JsonSerializable()
class ChatEntity{
  String id;
  ChatMode mode;
  String name;
  UserEntity? member1;
  UserEntity? member2;
  int unread;
  MessageEntity? lastMessage;
  ChatEntity({this.lastMessage,required this.unread,required this.id,required this.mode,required this.name, this.member1, this.member2});

  factory ChatEntity.fromJson(Map<String, dynamic> json) => _$ChatEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ChatEntityToJson(this);
}