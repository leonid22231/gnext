// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderEntity _$OrderEntityFromJson(Map<String, dynamic> json) => OrderEntity(
      id: json['id'] as int,
      creator: UserEntity.fromJson(json['creator'] as Map<String, dynamic>),
      specialist: json['specialist'] == null
          ? null
          : UserEntity.fromJson(json['specialist'] as Map<String, dynamic>),
      city: CityEntity.fromJson(json['city'] as Map<String, dynamic>),
      addressTo:
          AddressEntity.fromJson(json['addressTo'] as Map<String, dynamic>),
      addressFrom:
          AddressEntity.fromJson(json['addressFrom'] as Map<String, dynamic>),
      price: (json['price'] as num).toDouble(),
      customPrice: json['customPrice'] as bool,
      outCity: json['outCity'] as bool,
      startDate: DateTime.parse(json['startDate'] as String),
      active: json['active'] as bool,
      endDate: DateTime.parse(json['endDate'] as String),
      createDate: DateTime.parse(json['createDate'] as String),
    );

Map<String, dynamic> _$OrderEntityToJson(OrderEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creator': instance.creator,
      'specialist': instance.specialist,
      'city': instance.city,
      'addressTo': instance.addressTo,
      'addressFrom': instance.addressFrom,
      'price': instance.price,
      'customPrice': instance.customPrice,
      'outCity': instance.outCity,
      'active': instance.active,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createDate': instance.createDate.toIso8601String(),
    };
