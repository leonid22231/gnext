// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PropertiesEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressEntity _$AddressEntityFromJson(Map<String, dynamic> json) =>
    AddressEntity(
      json['id'] as int,
      json['street'] as String?,
      json['house'] as String?,
      json['city'] as String,
    );

Map<String, dynamic> _$AddressEntityToJson(AddressEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'street': instance.street,
      'house': instance.house,
      'city': instance.city,
    };

PropertiesModel _$PropertiesModelFromJson(Map<String, dynamic> json) =>
    PropertiesModel(
      AddressModel.fromJson(json['addressTo'] as Map<String, dynamic>),
      AddressModel.fromJson(json['addressFrom'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PropertiesModelToJson(PropertiesModel instance) =>
    <String, dynamic>{
      'addressTo': instance.addressTo,
      'addressFrom': instance.addressFrom,
    };

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      json['street'] as String?,
      json['house'] as String?,
      json['city'] as String,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'street': instance.street,
      'house': instance.house,
      'city': instance.city,
    };
