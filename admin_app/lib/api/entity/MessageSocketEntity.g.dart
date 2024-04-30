// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageSocketEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageSocketEntity _$MessageSocketEntityFromJson(Map<String, dynamic> json) =>
    MessageSocketEntity(
      id: json['id'] as int,
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      chat: ChatEntity.fromJson(json['chat'] as Map<String, dynamic>),
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$MessageSocketEntityToJson(
        MessageSocketEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'chat': instance.chat,
      'user': instance.user,
      'time': instance.time.toIso8601String(),
    };

const _$MessageTypeEnumMap = {
  MessageType.SYSTEM: 'SYSTEM',
  MessageType.USER: 'USER',
};
