import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _categoryRepo = CategoryRepository();

  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  List<CategoryModel> get expenseCategories =>
      _categories.where((c) => c.type == 0).toList();

  List<CategoryModel> get incomeCategories =>
      _categories.where((c) => c.type == 1).toList();

  CategoryModel? getCategoryById(int id) {
    try {
      return _categories.firstWhere((c) => c.id != null && c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadCategories() async {
    _categories = await _categoryRepo.getAllCategories();
    notifyListeners();
  }

  Future<void> addCategory({
    required String name,
    required String iconName,
    required int type,
  }) async {
    await _categoryRepo.insertCategory(name, iconName, type == 1);
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
