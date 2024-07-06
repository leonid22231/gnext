// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TransportationEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransportationEntity _$TransportationEntityFromJson(
        Map<String, dynamic> json) =>
    TransportationEntity(
      id: json['id'] as int,
      creator: UserEntity.fromJson(json['creator'] as Map<String, dynamic>),
      city: CityEntity.fromJson(json['city'] as Map<String, dynamic>),
      addressTo:
          AddressEntity.fromJson(json['addressTo'] as Map<String, dynamic>),
      addressFrom:
          AddressEntity.fromJson(json['addressFrom'] as Map<String, dynamic>),
      active: json['active'] as bool,
      outCity: json['outCity'] as bool,
      category: $enumDecode(_$TransportationCategoryEnumMap, json['category']),
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      createDate: DateTime.parse(json['createDate'] as String),
    );

Map<String, dynamic> _$TransportationEntityToJson(
        TransportationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creator': instance.creator,
      'city': instance.city,
      'addressTo': instance.addressTo,
      'addressFrom': instance.addressFrom,
      'active': instance.active,
      'outCity': instance.outCity,
      'price': instance.price,
      'description': instance.description,
      'category': _$TransportationCategoryEnumMap[instance.category]!,
      'date': instance.date.toIso8601String(),
      'createDate': instance.createDate.toIso8601String(),
    };

const _$TransportationCategoryEnumMap = {
  TransportationCategory.ev: 'ev',
  TransportationCategory.taxi: 'taxi',
  TransportationCategory.man: 'man',
  TransportationCategory.sam: 'sam',
  TransportationCategory.auto: 'auto',
  TransportationCategory.ex: 'ex',
  TransportationCategory.pog: 'pog',
};
