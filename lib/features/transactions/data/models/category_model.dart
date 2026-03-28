import 'package:gider_takip/features/transactions/data/models/category_type.dart';
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
  @JsonKey(fromJson: _typeFromInt, toJson: _typeToInt)
  final CategoryType type;
  final int? id;

  static CategoryType _typeFromInt(int value) =>
      CategoryType.values.firstWhere((e) => e.value == value);

  static int _typeToInt(CategoryType type) => type.value;

  @override
  Map<String, dynamic> toMap() => _$CategoryModelToJson(this);
}
