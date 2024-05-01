import 'package:app/api/entity/enums/UserRole.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserEntityMessage.g.dart';

@JsonSerializable()
class UserEntityMessage {
  int id;
  String uid;
  UserRole role;
  String name;
  String surname;
  String phone;
  String? photo;

  UserEntityMessage(
      {required this.id,
      required this.uid,
      required this.role,
      required this.name,
      required this.surname,
      required this.phone,
      this.photo});

  factory UserEntityMessage.fromJson(Map<String, dynamic> json) =>
      _$UserEntityMessageFromJson(json);
  Map<String, dynamic> toJson() => _$UserEntityMessageToJson(this);
}
