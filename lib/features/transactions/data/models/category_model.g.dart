// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      name: json['name'] as String,
      iconName: json['icon'] as String,
      type: CategoryModel._typeFromInt((json['type'] as num).toInt()),
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'icon': instance.iconName,
      'type': CategoryModel._typeToInt(instance.type),
      'id': instance.id,
    };
