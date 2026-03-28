// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      type: TransactionModel._typeFromInt((json['type'] as num).toInt()),
      categoryId: (json['categoryId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      transactionDate:
          TransactionModel._dateFromString(json['transactionDate'] as String),
      description: json['description'] as String,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'type': TransactionModel._typeToInt(instance.type),
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'transactionDate':
          TransactionModel._dateToString(instance.transactionDate),
      'description': instance.description,
      'id': instance.id,
    };
