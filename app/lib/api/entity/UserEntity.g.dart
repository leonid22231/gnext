// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      id: json['id'] as int,
      uid: json['uid'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      phone: json['phone'] as String,
      location:
          LocationEntity.fromJson(json['location'] as Map<String, dynamic>),
      photo: json['photo'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      wallet: (json['wallet'] as num).toDouble(),
      subscription: json['subscription'] as bool,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'surname': instance.surname,
      'phone': instance.phone,
      'photo': instance.photo,
      'role': _$UserRoleEnumMap[instance.role]!,
      'location': instance.location,
      'wallet': instance.wallet,
      'subscription': instance.subscription,
    };

const _$UserRoleEnumMap = {
  UserRole.USER: 'USER',
  UserRole.SPECIALIST: 'SPECIALIST',
  UserRole.ADMIN: 'ADMIN',
  UserRole.MANAGER: 'MANAGER',
};
