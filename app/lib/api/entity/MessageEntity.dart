// ignore_for_file: file_names

import 'package:app/api/entity/ChatEntity.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/MessageType.dart';
import 'package:json_annotation/json_annotation.dart';

part 'MessageEntity.g.dart';

@JsonSerializable(includeIfNull: false)
class MessageEntity{
  int id;
  String content;
  MessageType type;
  ChatEntity? chat;
  UserEntity user;
  DateTime time;

  MessageEntity({
    required this.id,
    required this.content,
    required this.type,
    this.chat,
    required this.user,
    required this.time
});

  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);
  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);
}