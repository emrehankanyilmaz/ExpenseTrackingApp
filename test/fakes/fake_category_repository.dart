import 'package:gider_takip/features/transactions/data/models/category_model.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/data/repositories/category_repository.dart';

class FakeCategoryRepository extends CategoryRepository {
  final List<CategoryModel> _data = [];
  int _idCounter = 1;

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    return _data;
  }

  @override
  Future<void> insertCategory(
      String name, String iconName, CategoryType type) async {
    final category = CategoryModel(
      name: name,
      iconName: iconName,
      type: type,
      id: _idCounter,
    );
    _data.add(category);
    _idCounter++;
  }

  @override
  Future<int> insert(CategoryModel category) async {
    final newCategory = CategoryModel(
      name: category.name,
      iconName: category.iconName,
      type: category.type,
      id: _idCounter,
    );
    _data.add(newCategory);
    _idCounter++;
    return 1;
  }

  @override
  Future<int> delete(int id) async {
    _data.removeWhere((e) => e.id == id);
    return 1;
  }

  @override
  Future<int> update(int id, CategoryModel category) async {
    final index = _data.indexWhere((e) => e.id == id);

    if (index != -1) {
      _data[index] = CategoryModel(
        name: category.name,
        iconName: category.iconName,
        type: category.type,
        id: id,
      );
      return 1;
    }

    return 0;
  }

  void clearData() {
    _data.clear();
    _idCounter = 1;
  }
}
