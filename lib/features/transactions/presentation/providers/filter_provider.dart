import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/data/models/date_filter.dart';

class FilterProvider extends ChangeNotifier {
  DateFilter dateFilter = DateFilter.thisWeek;
  DateFilter budgetFilter = DateFilter.thisWeek;
  DateTime? startDate;
  DateTime? endDate;

  double? minAmount;
  double? maxAmount;

  int? categoryId;
  CategoryType? type;

  void setWeeklyFilter(DateFilter filter) {
    dateFilter = filter;
    notifyListeners();
  }

  void setBudgetFilter(DateFilter filter) {
    budgetFilter = filter;
    notifyListeners();
  }

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
    categoryId = null;
    type = null;
    notifyListeners();
  }
}
