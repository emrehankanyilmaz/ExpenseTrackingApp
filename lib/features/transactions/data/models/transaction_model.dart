import 'package:gider_takip/core/database/base_model.dart';

class TransactionModel extends BaseModel {
  final int? id;
  final int type;
  final int categoryId;
  final double amount;
  final DateTime transactionDate;
  final String description;

  TransactionModel(
      {this.id,
      required this.type,
      required this.categoryId,
      required this.amount,
      required this.transactionDate,
      required this.description});

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
        id: map['id'],
        type: map['type'],
        categoryId: map['categoryId'],
        amount: map['amount'],
        transactionDate: DateTime.parse(map['transactionDate']),
        description: map['description']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'categoryId': categoryId,
      'amount': amount,
      'transactionDate': transactionDate.toIso8601String(),
      'description': description
    };
  }
}
