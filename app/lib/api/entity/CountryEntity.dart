// ignore_for_file: file_names

import 'package:app/api/entity/CityEntity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CountryEntity.g.dart';

@JsonSerializable()
class CountryEntity {
  int id;
  String name;
  List<CityEntity> cities;

  CountryEntity({required this.id,required this.name,required this.cities});

  @override
  String toString() {
    return name;
  }

  factory CountryEntity.fromJson(Map<String, dynamic> json) => _$CountryEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CountryEntityToJson(this);
}