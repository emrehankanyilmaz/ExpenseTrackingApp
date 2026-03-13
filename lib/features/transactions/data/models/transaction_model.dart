import 'package:json_annotation/json_annotation.dart';
import 'package:gider_takip/core/database/base_model.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends BaseModel {
  TransactionModel({
    required this.type,
    required this.categoryId,
    required this.amount,
    required this.transactionDate,
    required this.description,
    this.id,
  });
  factory TransactionModel.fromMap(Map<String, dynamic> map) =>
      _$TransactionModelFromJson(map);
  final int type;
  final int categoryId;
  final double amount;
  @JsonKey(fromJson: _dateFromString, toJson: _dateToString)
  final DateTime transactionDate;
  final String description;
  final int? id;

  @override
  Map<String, dynamic> toMap() => _$TransactionModelToJson(this);

  static DateTime _dateFromString(String date) => DateTime.parse(date);
  static String _dateToString(DateTime date) => date.toIso8601String();
}
