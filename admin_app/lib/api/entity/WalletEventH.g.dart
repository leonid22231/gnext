// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WalletEventH.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletEventH _$WalletEventHFromJson(Map<String, dynamic> json) => WalletEventH(
      id: json['id'] as int,
      type: $enumDecode(_$WalletEventEnumMap, json['type']),
      result: $enumDecode(_$EventResultEnumMap, json['result']),
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      old_sum: (json['old_sum'] as num).toDouble(),
      sum: (json['sum'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$WalletEventHToJson(WalletEventH instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$WalletEventEnumMap[instance.type]!,
      'result': _$EventResultEnumMap[instance.result]!,
      'user': instance.user,
      'old_sum': instance.old_sum,
      'sum': instance.sum,
      'date': instance.date.toIso8601String(),
    };

const _$WalletEventEnumMap = {
  WalletEvent.PAYMENT: 'PAYMENT',
  WalletEvent.ADD: 'ADD',
  WalletEvent.SUBTRACT: 'SUBTRACT',
  WalletEvent.ADJUST: 'ADJUST',
};

const _$EventResultEnumMap = {
  EventResult.DONE: 'DONE',
  EventResult.CANCEL: 'CANCEL',
  EventResult.ERROR: 'ERROR',
};
