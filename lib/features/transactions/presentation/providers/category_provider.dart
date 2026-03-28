import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _categoryRepo = CategoryRepository();

  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  List<CategoryModel> get expenseCategories => _categories
      .where((category) => category.type == CategoryType.expense)
      .toList();

  List<CategoryModel> get incomeCategories => _categories
      .where((category) => category.type == CategoryType.income)
      .toList();

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
    required CategoryType type,
  }) async {
    await _categoryRepo.insertCategory(name, iconName, type);
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
