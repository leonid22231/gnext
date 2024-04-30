// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationEntity _$LocationEntityFromJson(Map<String, dynamic> json) =>
    LocationEntity(
      id: json['id'] as int,
      country: CountryEntity.fromJson(json['country'] as Map<String, dynamic>),
      city: CityEntity.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationEntityToJson(LocationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'city': instance.city,
    };
