import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';

class FilterProvider extends ChangeNotifier {
  DateTime? startDate;
  DateTime? endDate;

  double? minAmount;
  double? maxAmount;

  int? categoryId;
  CategoryType? type;

  void setType(CategoryType? value) {
    type = value;
    notifyListeners();
  }

  void setCategory(int? value) {
    categoryId = value;
    notifyListeners();
  }

  void setStartDate(DateTime? value) {
    startDate = value;
    notifyListeners();
  }

  void setEndDate(DateTime? value) {
    endDate = value;
    notifyListeners();
  }

  void setMinAmount(double? value) {
    minAmount = value;
    notifyListeners();
  }

  void setMaxAmount(double? value) {
    maxAmount = value;
    notifyListeners();
  }

  void reset() {
    startDate = null;
    endDate = null;
    minAmount = null;
    maxAmount = null;
    categoryId = null;
    type = null;
    notifyListeners();
  }
}
