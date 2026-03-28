import 'package:easy_localization/easy_localization.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';

extension TransactionProviderExtension on TransactionProvider {
  String get formattedNetBalance =>
      '${netBalance >= 0 ? '' : '${'minus'.tr()} '}${'currency'.tr()} ${netBalance.abs().toStringAsFixed(0)}';

  String get formattedTotalIncome =>
      '${'currency'.tr()} ${totalIncome.toStringAsFixed(0)}';

  String get formattedTotalExpense =>
      '${'currency'.tr()} ${totalExpense.toStringAsFixed(0)}';

  String get formattedBudgetStatus =>
      '${'currency'.tr()} ${netBalance.toStringAsFixed(0)} | Kaldı';

  String get formattedBudgetDetail =>
      '${'currency'.tr()} ${totalExpense.toStringAsFixed(0)} / ${'currency'.tr()} ${totalIncome.toStringAsFixed(0)}';
}
