import 'package:json_annotation/json_annotation.dart';
import 'package:gider_takip/core/database/base_model.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends BaseModel {
  CategoryModel({
    required this.name,
    required this.iconName,
    required this.type,
    this.id,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) =>
      _$CategoryModelFromJson(map);
  final String name;
  @JsonKey(name: 'icon')
  final String iconName;
  final int type;
  final int? id;

  @override
  Map<String, dynamic> toMap() => _$CategoryModelToJson(this);
}
