import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserEntity.g.dart';

@JsonSerializable()
class UserEntity {
  int id;
  String uid;
  String name;
  String surname;
  String phone;
  String? photo;
  String? telegram;
  String? whatsapp;
  UserRole role;
  CityEntity city;
  double wallet;
  bool subscription;

  UserEntity({this.telegram, this.whatsapp, required this.id, required this.uid, required this.name, required this.surname, required this.phone, required this.city, this.photo, required this.role, required this.wallet, required this.subscription});

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
