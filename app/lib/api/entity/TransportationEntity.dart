import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/PropertiesEntity.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/TransportationCategory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TransportationEntity.g.dart';

@JsonSerializable()
class TransportationEntity {
  int id;
  UserEntity creator;
  CityEntity city;
  AddressEntity addressTo;
  AddressEntity addressFrom;
  bool active;
  bool outCity;
  double price;
  String description;
  TransportationCategory category;
  DateTime date;
  DateTime createDate;
  @override
  bool operator ==(Object other) =>
      other is TransportationEntity && other.id == id;
  TransportationEntity(
      {required this.id,
      required this.creator,
      required this.city,
      required this.addressTo,
      required this.addressFrom,
      required this.active,
      required this.outCity,
      required this.category,
      required this.price,
      required this.description,
      required this.date,
      required this.createDate});

  factory TransportationEntity.fromJson(Map<String, dynamic> json) =>
      _$TransportationEntityFromJson(json);
  Map<String, dynamic> toJson() => _$TransportationEntityToJson(this);
}
