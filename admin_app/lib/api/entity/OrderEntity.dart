import 'package:admin_app/api/entity/CityEntity.dart';
import 'package:admin_app/api/entity/PropertiesEntity.dart';
import 'package:admin_app/api/entity/UserEntity.dart';
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

  OrderEntity({required this.id, required this.creator, this.specialist, required this.city, required this.addressTo, required this.addressFrom, required this.price, required this.customPrice, required this.outCity, required this.startDate, required this.active, required this.endDate, required this.createDate});

  factory OrderEntity.fromJson(Map<String, dynamic> json) => _$OrderEntityFromJson(json);
  Map<String, dynamic> toJson() => _$OrderEntityToJson(this);
}
