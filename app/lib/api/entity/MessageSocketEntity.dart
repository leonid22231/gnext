// ignore_for_file: file_names

import 'package:app/api/entity/ChatEntity.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/MessageType.dart';
import 'package:json_annotation/json_annotation.dart';

part 'MessageSocketEntity.g.dart';

@JsonSerializable()
class MessageSocketEntity{
  int id;
  String content;
  MessageType type;
  ChatEntity chat;
  UserEntity user;
  DateTime time;

  MessageSocketEntity({
    required this.id,
    required this.content,
    required this.type,
    required this.chat,
    required this.user,
    required this.time
  });

  factory MessageSocketEntity.fromJson(Map<String, dynamic> json) => _$MessageSocketEntityFromJson(json);
  Map<String, dynamic> toJson() => _$MessageSocketEntityToJson(this);
}