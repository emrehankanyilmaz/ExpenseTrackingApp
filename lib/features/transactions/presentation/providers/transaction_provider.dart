import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/data/models/date_filter.dart';
import '../../constants/days_months_constants.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  TransactionProvider(this._transactionRepo);
  final TransactionRepository _transactionRepo;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  int selectedIndex = 0;
  CategoryType selectedType = CategoryType.expense;
  CategoryModel? selectedCategory;
  DateTime selectedDate = DateTime.now();

  DateTime? filterStartDate;
  DateTime? filterEndDate;
  double? filterMinAmount;
  double? filterMaxAmount;
  int? filterCategoryId;
  CategoryType? filterType;
  int _page = 1;
  static const int _pageSize = 10;

  double totalIncome(DateFilter filter) => _getTransactionsByFilter(filter)
      .where((t) => t.type == CategoryType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double totalExpense(DateFilter filter) => _getTransactionsByFilter(filter)
      .where((t) => t.type == CategoryType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  double netBalance(DateFilter filter) =>
      totalIncome(filter) - totalExpense(filter);

  List<TransactionModel> get recentTransactions =>
      _transactions.take(5).toList();

  List<TransactionModel> _getTransactionsByFilter(DateFilter filter) {
    final now = DateTime.now();
    DateTime startDate;
    switch (filter) {
      case DateFilter.thisWeek:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case DateFilter.thisMonth:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case DateFilter.lastThreeMonths:
        startDate = DateTime(now.year, now.month - 2, 1);
        break;
    }
    return _transactions
        .where((t) => !t.transactionDate.isBefore(startDate))
        .toList();
  }

  Map<String, double> getExpensesByFilter(DateFilter filter) {
    final now = DateTime.now();
    switch (filter) {
      case DateFilter.thisWeek:
        return _groupExpensesByDay(now);
      case DateFilter.thisMonth:
        return _groupExpensesByWeek(now);
      case DateFilter.lastThreeMonths:
        return _groupExpensesByMonth(now);
    }
  }

  Map<String, double> _groupExpensesByDay(DateTime now) {
    const weekDays = WeekDaysConstants.weekDays;
    final Map<String, double> expensesByDay = {
      for (var day in weekDays) day: 0
    };

    // Haftanın başlangıcını hesapla (Pazartesi)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    for (var transaction in _transactions) {
      final isExpense = transaction.type == CategoryType.expense;
      final isInRange = transaction.transactionDate
              .isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
          transaction.transactionDate
              .isBefore(endOfWeek.add(const Duration(seconds: 1)));
      if (isExpense && isInRange) {
        final dayName = weekDays[transaction.transactionDate.weekday - 1];
        expensesByDay[dayName] =
            (expensesByDay[dayName] ?? 0) + transaction.amount;
      }
    }
    return expensesByDay;
  }

  Map<String, double> _groupExpensesByWeek(DateTime now) {
    final Map<String, double> expensesByWeek = {
      '1. Hafta': 0,
      '2. Hafta': 0,
      '3. Hafta': 0,
      '4. Hafta': 0,
    };
    final monthStart = DateTime(now.year, now.month, 1);

    for (var transaction in _transactions) {
      final isExpense = transaction.type == CategoryType.expense;
      final isInRange = transaction.transactionDate.isAfter(monthStart);
      if (isExpense && isInRange) {
        final weekIndex = ((transaction.transactionDate.day - 1) / 7).floor();
        final weekKey = '${weekIndex + 1}. Hafta';
        if (expensesByWeek.containsKey(weekKey)) {
          expensesByWeek[weekKey] =
              (expensesByWeek[weekKey] ?? 0) + transaction.amount;
        }
      }
    }
    return expensesByWeek;
  }

  Map<String, double> _groupExpensesByMonth(DateTime now) {
    final monthNames = WeekDaysConstants.months;
    final Map<String, double> expensesByMonth = {};

    for (var monthOffset = 2; monthOffset >= 0; monthOffset--) {
      var date = DateTime(now.year, now.month - monthOffset, 1);
      expensesByMonth[monthNames[date.month - 1]] = 0;
    }

    final threeMonthsAgo = DateTime(now.year, now.month - 2, 1);
    for (var transaction in _transactions) {
      final isExpense = transaction.type == CategoryType.expense;
      final isInRange = transaction.transactionDate.isAfter(threeMonthsAgo);
      if (isExpense && isInRange) {
        final monthName = monthNames[transaction.transactionDate.month - 1];
        if (expensesByMonth.containsKey(monthName)) {
          expensesByMonth[monthName] =
              (expensesByMonth[monthName] ?? 0) + transaction.amount;
        }
      }
    }
    return expensesByMonth;
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
    CategoryType? type,
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

  void setTransactionsForTest(List<TransactionModel> list) {
    _transactions = list;
  }

  void setSelectedType(CategoryType type) {
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
    selectedType = CategoryType.expense;
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
