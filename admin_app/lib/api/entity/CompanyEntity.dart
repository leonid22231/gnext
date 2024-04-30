import 'package:admin_app/api/entity/LocationEntity.dart';
import 'package:admin_app/api/entity/PropertiesEntity.dart';
import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/api/entity/enums/Categories.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CompanyEntity.g.dart';

@JsonSerializable()
class CompanyEntity{
  int id;
  String name;
  String phone;
  UserEntity? manager;
  AddressEntity address;
  Categories category;
  LocationEntity location;


  CompanyEntity({required this.id,
   required this.name,
   required this.phone,
    this.manager,
   required this.address,
   required this.category,
   required this.location});

  factory CompanyEntity.fromJson(Map<String, dynamic> json) => _$CompanyEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyEntityToJson(this);
}