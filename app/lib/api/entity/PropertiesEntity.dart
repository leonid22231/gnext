import 'package:json_annotation/json_annotation.dart';

part 'PropertiesEntity.g.dart';

@JsonSerializable()
class AddressEntity{
  int id;
  String? street;
  String? house;
  String city;

  AddressEntity(this.id, this.street, this.house, this.city);

  factory AddressEntity.fromJson(Map<String, dynamic> json) => _$AddressEntityFromJson(json);
  Map<String, dynamic> toJson() => _$AddressEntityToJson(this);
}
@JsonSerializable()
class PropertiesModel{
  AddressModel addressTo;
  AddressModel addressFrom;

  PropertiesModel(this.addressTo, this.addressFrom);

  factory PropertiesModel.fromJson(Map<String, dynamic> json) => _$PropertiesModelFromJson(json);
  Map<String, dynamic> toJson() => _$PropertiesModelToJson(this);
}
@JsonSerializable()
class AddressModel{
  String? street;
  String? house;
  String city;

  AddressModel(this.street, this.house, this.city);

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}