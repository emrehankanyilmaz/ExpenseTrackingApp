import 'package:easy_localization/easy_localization.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/data/models/transaction_model.dart';

extension TransactionExtension on TransactionModel {
  String get formattedAmount =>
      '${type == CategoryType.expense ? '${'minus'.tr()} ' : ''}${'currency'.tr()} ${amount.toStringAsFixed(0)}';
}
