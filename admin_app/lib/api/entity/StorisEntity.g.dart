// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StorisEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorisEntity _$StorisEntityFromJson(Map<String, dynamic> json) => StorisEntity(
      id: json['id'] as int,
      content: json['content'] as String,
      type: $enumDecode(_$StoryTypeEnumMap, json['type']),
      chat: ChatEntity.fromJson(json['chat'] as Map<String, dynamic>),
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      createDate: DateTime.parse(json['createDate'] as String),
    );

Map<String, dynamic> _$StorisEntityToJson(StorisEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': _$StoryTypeEnumMap[instance.type]!,
      'chat': instance.chat,
      'user': instance.user,
      'createDate': instance.createDate.toIso8601String(),
    };

const _$StoryTypeEnumMap = {
  StoryType.PHOTO: 'PHOTO',
  StoryType.VIDEO: 'VIDEO',
};
