import 'package:json_annotation/json_annotation.dart';

part 'CityEntity.g.dart';

@JsonSerializable()
class CityEntity {
  int id;
  String name;
  double? value;

  CityEntity({required this.id, required this.name, this.value});

  @override
  String toString() {
    return name;
  }

  factory CityEntity.fromJson(Map<String, dynamic> json) =>
      _$CityEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CityEntityToJson(this);
}
