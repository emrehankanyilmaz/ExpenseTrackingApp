import 'package:gider_takip/core/database/base_repository.dart';
import '../models/transaction_model.dart';

class TransactionRepository extends BaseRepository<TransactionModel> {
  TransactionRepository() : super('transactions');

  Future<List<TransactionModel>> getAllTransactions() async {
    return await getAll((map) => TransactionModel.fromMap(map));
  }
}
