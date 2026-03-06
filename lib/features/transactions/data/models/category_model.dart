import 'package:gider_takip/core/database/base_model.dart';

class CategoryModel extends BaseModel {
  final int? id;
  final String name;
  final String iconName;
  final int type;

  CategoryModel({
    this.id,
    required this.name,
    required this.iconName,
    required this.type,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      iconName: map['icon'],
      type: map['type'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': iconName,
      'type': type,
    };
  }
}
