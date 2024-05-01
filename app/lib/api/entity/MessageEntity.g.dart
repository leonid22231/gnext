// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageEntity _$MessageEntityFromJson(Map<String, dynamic> json) =>
    MessageEntity(
      id: json['id'] as int,
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      chat: json['chat'] == null
          ? null
          : ChatEntity.fromJson(json['chat'] as Map<String, dynamic>),
      user: UserEntityMessage.fromJson(json['user'] as Map<String, dynamic>),
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$MessageEntityToJson(MessageEntity instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'content': instance.content,
    'type': _$MessageTypeEnumMap[instance.type]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('chat', instance.chat);
  val['user'] = instance.user;
  val['time'] = instance.time.toIso8601String();
  return val;
}

const _$MessageTypeEnumMap = {
  MessageType.USER: 'USER',
  MessageType.AUDIO: 'AUDIO',
  MessageType.PHOTO: 'PHOTO',
};
