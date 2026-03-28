import 'package:gider_takip/features/transactions/data/models/category_type.dart';
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

  @JsonKey(fromJson: _typeFromInt, toJson: _typeToInt)
  final CategoryType type;
  final int categoryId;
  final double amount;
  @JsonKey(fromJson: _dateFromString, toJson: _dateToString)
  final DateTime transactionDate;
  final String description;
  final int? id;

  static CategoryType _typeFromInt(int value) =>
      CategoryType.values.firstWhere((e) => e.value == value);

  static int _typeToInt(CategoryType type) => type.value;

  @override
  Map<String, dynamic> toMap() => _$TransactionModelToJson(this);

  static DateTime _dateFromString(String date) => DateTime.parse(date);
  static String _dateToString(DateTime date) => date.toIso8601String();
}
