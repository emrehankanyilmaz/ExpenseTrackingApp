import 'package:flutter/material.dart';
import '../../constants/days_months_constants.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _transactionRepo = TransactionRepository();
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;
  int selectedIndex = 0;
  int selectedType = 0;
  CategoryModel? selectedCategory;
  DateTime selectedDate = DateTime.now();

  DateTime? filterStartDate;
  DateTime? filterEndDate;
  double? filterMinAmount;
  double? filterMaxAmount;
  int? filterCategoryId;
  int? filterType;
  int _page = 1;
  static const int _pageSize = 10;

  double get totalIncome => _transactions
      .where((t) => t.type == 1)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == 0)
      .fold(0, (sum, t) => sum + t.amount);

  double get netBalance => totalIncome - totalExpense;

  List<TransactionModel> get recentTransactions =>
      _transactions.take(5).toList();

  Map<String, double> get weeklyExpenses {
    const days = WeekDaysConstants.weekDays;
    final Map<String, double> result = {for (var d in days) d: 0};
    final now = DateTime.now();
    for (var t in _transactions) {
      if (t.type == 0) {
        final diff = now.difference(t.transactionDate).inDays;
        if (diff < 7) {
          final dayName = days[t.transactionDate.weekday % 7];
          result[dayName] = (result[dayName] ?? 0) + t.amount;
        }
      }
    }
    return result;
  }

  List<TransactionModel> get filteredTransactions {
    var list = _transactions.where((t) {
      if (filterStartDate != null &&
          t.transactionDate.isBefore(filterStartDate!)) {
        return false;
      }
      if (filterEndDate != null && t.transactionDate.isAfter(filterEndDate!)) {
        return false;
      }
      if (filterMinAmount != null && t.amount < filterMinAmount!) return false;
      if (filterMaxAmount != null && t.amount > filterMaxAmount!) return false;
      if (filterCategoryId != null && t.categoryId != filterCategoryId) {
        return false;
      }
      if (filterType != null && t.type != filterType) return false;
      return true;
    }).toList();

    list.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    return list.take(_page * _pageSize).toList();
  }

  bool get hasMore =>
      filteredTransactions.length <
      _transactions.where((t) {
        if (filterStartDate != null &&
            t.transactionDate.isBefore(filterStartDate!)) {
          return false;
        }
        if (filterEndDate != null &&
            t.transactionDate.isAfter(filterEndDate!)) {
          return false;
        }
        if (filterMinAmount != null && t.amount < filterMinAmount!) {
          return false;
        }
        if (filterMaxAmount != null && t.amount > filterMaxAmount!) {
          return false;
        }
        if (filterCategoryId != null && t.categoryId != filterCategoryId) {
          return false;
        }
        if (filterType != null && t.type != filterType) return false;
        return true;
      }).length;

  bool get hasActiveFilter =>
      filterStartDate != null ||
      filterEndDate != null ||
      filterMinAmount != null ||
      filterMaxAmount != null ||
      filterCategoryId != null ||
      filterType != null;

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionRepo.update(transaction.id!, transaction);
    await loadTransactions();
  }

  Future<DateTime?> pickDate(BuildContext context, {DateTime? initial}) async {
    return await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  void loadMore() {
    _page++;
    notifyListeners();
  }

  void applyFilter({
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    int? categoryId,
    int? type,
  }) {
    filterStartDate = startDate;
    filterEndDate = endDate;
    filterMinAmount = minAmount;
    filterMaxAmount = maxAmount;
    filterCategoryId = categoryId;
    filterType = type;
    _page = 1;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void setSelectedType(int type) {
    selectedType = type;
    selectedCategory = null;
    notifyListeners();
  }

  void setSelectedCategory(CategoryModel category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void resetForm() {
    selectedType = 0;
    selectedCategory = null;
    selectedDate = DateTime.now();
  }

  Future<void> loadTransactions() async {
    _transactions = await _transactionRepo.getAllTransactions();
    _transactions
        .sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    notifyListeners();
  }

  Future<bool> addTransaction({
    required double amount,
    required String description,
  }) async {
    if (selectedCategory == null) return false;
    final transaction = TransactionModel(
      type: selectedType,
      categoryId: selectedCategory!.id!,
      amount: amount,
      transactionDate: selectedDate,
      description: description,
    );
    await _transactionRepo.insert(transaction);
    await loadTransactions();
    resetForm();
    return true;
  }

  Future<void> deleteTransaction(int id) async {
    await _transactionRepo.delete((id));
    await loadTransactions();
  }
}
