import 'package:admin_app/api/entity/ChatEntity.dart';
import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/api/entity/enums/StoryType.dart';
import 'package:json_annotation/json_annotation.dart';

part 'StorisEntity.g.dart';

@JsonSerializable()
class StorisEntity{
  int id;
  String content;
  StoryType type;
  ChatEntity chat;
  UserEntity user;
  DateTime createDate;

  StorisEntity({required this.id,
    required this.content,
    required this.type,
    required this.chat,
    required this.user,
    required this.createDate});

  factory StorisEntity.fromJson(Map<String, dynamic> json) => _$StorisEntityFromJson(json);
  Map<String, dynamic> toJson() => _$StorisEntityToJson(this);
}