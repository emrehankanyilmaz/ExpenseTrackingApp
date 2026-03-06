import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/transaction_constans.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class TransactionHelper {
  static Future<void> pickDate(
      BuildContext context, TransactionProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) provider.setSelectedDate(picked);
  }

  static Future<void> save(
    BuildContext context, {
    required String amount,
    required String description,
  }) async {
    final provider = context.read<TransactionProvider>();
    if (amount.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TransactionConstants.enterAmount)),
      );
      return;
    }
    if (provider.selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TransactionConstants.selectCategory)),
      );
      return;
    }
    final success = await provider.addTransaction(
      amount: double.parse(amount.trim()),
      description: description.trim(),
    );
    if (success && context.mounted) Navigator.pop(context);
  }
}
