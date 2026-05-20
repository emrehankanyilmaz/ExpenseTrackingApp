import 'package:gider_takip/features/transactions/data/models/transaction_model.dart';
import 'package:gider_takip/features/transactions/data/repositories/transaction_repository.dart';

class FakeTransactionRepository implements TransactionRepository {
  final List<TransactionModel> _data = [];

  @override
  String get tableName => 'transactions';

  @override
  Future<List<TransactionModel>> getAll(
    TransactionModel Function(Map<String, dynamic>) fromMap,
  ) async {
    return _data;
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return _data;
  }

  @override
  Future<int> insert(TransactionModel transaction) async {
    _data.add(transaction);
    return 1;
  }

  @override
  Future<int> delete(int id) async {
    _data.removeWhere((e) => e.id == id);
    return 1;
  }

  @override
  Future<int> update(int id, TransactionModel transaction) async {
    final index = _data.indexWhere((e) => e.id == id);

    if (index != -1) {
      _data[index] = transaction;
      return 1;
    }

    return 0;
  }
}
