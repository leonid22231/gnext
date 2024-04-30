// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StatisticModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticModel _$StatisticModelFromJson(Map<String, dynamic> json) =>
    StatisticModel(
      json['userCount'] as int,
      json['chatCount'] as int,
      json['messagesCount'] as int,
      json['countryCount'] as int,
      json['cityCount'] as int,
      json['allOrders'] as int,
      json['activeOrders'] as int,
    );

Map<String, dynamic> _$StatisticModelToJson(StatisticModel instance) =>
    <String, dynamic>{
      'userCount': instance.userCount,
      'chatCount': instance.chatCount,
      'messagesCount': instance.messagesCount,
      'countryCount': instance.countryCount,
      'cityCount': instance.cityCount,
      'allOrders': instance.allOrders,
      'activeOrders': instance.activeOrders,
    };
