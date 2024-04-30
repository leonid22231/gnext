import 'package:admin_app/api/entity/LocationEntity.dart';
import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/api/entity/enums/ChatMode.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ChatEntity.g.dart';

@JsonSerializable()
class ChatEntity{
  String id;
  ChatMode mode;
  String name;
  UserEntity? member1;
  UserEntity? member2;

  ChatEntity({required this.id,required this.mode,required this.name, this.member1, this.member2});

  factory ChatEntity.fromJson(Map<String, dynamic> json) => _$ChatEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ChatEntityToJson(this);
}