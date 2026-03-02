import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _categoryRepo = CategoryRepository();

  List<CategoryModel> _categories = [];
  int selectedType = 0;

  List<CategoryModel> get categories => _categories;

  List<CategoryModel> get expenseCategories =>
      _categories.where((c) => c.type == 0).toList();

  List<CategoryModel> get incomeCategories =>
      _categories.where((c) => c.type == 1).toList();

  List<CategoryModel> get filteredCategories =>
      selectedType == 0 ? expenseCategories : incomeCategories;

  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id.toString() == id);
    } catch (_) {
      return null;
    }
  }

  void setSelectedType(int type) {
    selectedType = type;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _categories = await _categoryRepo.getAllCategories();
    notifyListeners();
  }

  Future<void> addCategory({
    required String name,
    required String icon,
    required int type,
  }) async {
    await _categoryRepo.insertCategory(name, icon, type == 1);
    await loadCategories();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _categoryRepo.update(category.id!, category);
    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _categoryRepo.delete(id);
    await loadCategories();
  }
}
