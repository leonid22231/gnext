// ignore_for_file: file_names

import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/CountryEntity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'LocationEntity.g.dart';

@JsonSerializable()
class LocationEntity{
  int id;
  CountryEntity country;
  CityEntity city;

  LocationEntity({required this.id,required this.country,required this.city});

  factory LocationEntity.fromJson(Map<String, dynamic> json) => _$LocationEntityFromJson(json);
  Map<String, dynamic> toJson() => _$LocationEntityToJson(this);
}