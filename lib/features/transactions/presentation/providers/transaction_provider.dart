import 'package:flutter/material.dart';
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

  double get totalIncome => _transactions
      .where((t) => t.type == 1)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == 0)
      .fold(0, (sum, t) => sum + t.amount);

  double get netBalance => totalIncome - totalExpense;

  List<TransactionModel> get recentTransactions =>
      _transactions.reversed.take(5).toList();

  Map<String, double> get weeklyExpenses {
    final days = ['Paz', 'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt'];
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
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: selectedType,
      categoryId: selectedCategory!.id.toString(),
      amount: amount,
      transactionDate: selectedDate,
      description: description,
    );
    await _transactionRepo.insert(transaction);
    await loadTransactions();
    resetForm();
    return true;
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionRepo.delete(int.parse(id));
    await loadTransactions();
  }
}
