// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatEntity _$ChatEntityFromJson(Map<String, dynamic> json) => ChatEntity(
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageEntity.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unread: json['unread'] as int,
      id: json['id'] as String,
      mode: $enumDecode(_$ChatModeEnumMap, json['mode']),
      name: json['name'] as String,
      member1: json['member1'] == null
          ? null
          : UserEntity.fromJson(json['member1'] as Map<String, dynamic>),
      member2: json['member2'] == null
          ? null
          : UserEntity.fromJson(json['member2'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatEntityToJson(ChatEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mode': _$ChatModeEnumMap[instance.mode]!,
      'name': instance.name,
      'member1': instance.member1,
      'member2': instance.member2,
      'unread': instance.unread,
      'lastMessage': instance.lastMessage,
    };

const _$ChatModeEnumMap = {
  ChatMode.PRIVATE: 'PRIVATE',
  ChatMode.GENERAL: 'GENERAL',
};
