import 'package:gider_takip/core/database/base_repository.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import '../models/category_model.dart';

class CategoryRepository extends BaseRepository<CategoryModel> {
  CategoryRepository() : super('categories');

  Future<List<CategoryModel>> getAllCategories() async {
    return await getAll((map) => CategoryModel.fromMap(map));
  }

  Future<void> insertCategory(
      String name, String iconName, CategoryType type) async {
    final category = CategoryModel(name: name, iconName: iconName, type: type);
    await insert(category);
  }
}
