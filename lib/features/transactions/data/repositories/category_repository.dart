import 'package:gider_takip/core/database/base_repository.dart';
import '../models/category_model.dart';

class CategoryRepository extends BaseRepository<CategoryModel> {
  CategoryRepository() : super('categories');

  Future<List<CategoryModel>> getAllCategories() async {
    return await getAll((map) => CategoryModel.fromMap(map));
  }

  Future<void> insertCategory(String name, String icon, bool type) async {
    final category = CategoryModel(name: name, icon: icon, type: type ? 1 : 0);
    await insert(category);
  }
}
