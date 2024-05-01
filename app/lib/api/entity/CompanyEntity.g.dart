// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CompanyEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyEntity _$CompanyEntityFromJson(Map<String, dynamic> json) =>
    CompanyEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      manager: json['manager'] == null
          ? null
          : UserEntity.fromJson(json['manager'] as Map<String, dynamic>),
      image: json['image'] as String?,
      address: AddressEntity.fromJson(json['address'] as Map<String, dynamic>),
      category: $enumDecode(_$CategoriesEnumMap, json['category']),
      city: CityEntity.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompanyEntityToJson(CompanyEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'manager': instance.manager,
      'address': instance.address,
      'category': _$CategoriesEnumMap[instance.category]!,
      'city': instance.city,
      'image': instance.image,
    };

const _$CategoriesEnumMap = {
  Categories.info: 'info',
  Categories.sto: 'sto',
  Categories.swap: 'swap',
  Categories.modify: 'modify',
  Categories.auto: 'auto',
  Categories.shop: 'shop',
};
