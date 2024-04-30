import 'package:json_annotation/json_annotation.dart';

part 'CityEntity.g.dart';

@JsonSerializable()
class CityEntity{
  int id;
  String name;

  CityEntity({required this.id,required this.name});

  @override
  String toString() {
    return name;
  }

  factory CityEntity.fromJson(Map<String, dynamic> json) => _$CityEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CityEntityToJson(this);
}