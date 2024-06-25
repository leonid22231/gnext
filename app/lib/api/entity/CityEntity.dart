// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part 'CityEntity.g.dart';

@JsonSerializable()
class CityEntity {
  int id;
  String name;

  CityEntity({required this.id, required this.name});

  @override
  String toString() {
    return name;
  }

  factory CityEntity.fromJson(Map<String, dynamic> json) =>
      _$CityEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CityEntityToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CityEntity && other.id == id;
  }
}
