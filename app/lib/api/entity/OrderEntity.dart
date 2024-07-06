// ignore_for_file: file_names

import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/PropertiesEntity.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'OrderEntity.g.dart';

@JsonSerializable()
class OrderEntity {
  int id;
  UserEntity creator;
  UserEntity? specialist;
  CityEntity city;
  AddressEntity addressTo;
  AddressEntity addressFrom;
  double price;
  bool customPrice;
  bool outCity;
  bool active;
  DateTime startDate;
  DateTime endDate;
  DateTime createDate;
  String? description;
  String? file;

  @override
  bool operator ==(Object other) => other is OrderEntity && other.id == id;
  OrderEntity(
      {required this.id,
      required this.creator,
      this.specialist,
      required this.city,
      required this.addressTo,
      required this.addressFrom,
      required this.price,
      required this.customPrice,
      required this.outCity,
      required this.active,
      this.file,
      this.description,
      required this.startDate,
      required this.endDate,
      required this.createDate});

  factory OrderEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderEntityFromJson(json);
  Map<String, dynamic> toJson() => _$OrderEntityToJson(this);
}
