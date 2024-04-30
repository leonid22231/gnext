import 'package:json_annotation/json_annotation.dart';

part 'FilterEntity.g.dart';

@JsonSerializable()
class FilterEntity{
  int id;
  String word;

  FilterEntity({required this.id,required this.word});

  factory FilterEntity.fromJson(Map<String, dynamic> json) => _$FilterEntityFromJson(json);
  Map<String, dynamic> toJson() => _$FilterEntityToJson(this);
}