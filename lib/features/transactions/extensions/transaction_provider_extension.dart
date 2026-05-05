import 'package:easy_localization/easy_localization.dart';
import 'package:gider_takip/features/transactions/data/models/date_filter.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';

extension TransactionProviderExtension on TransactionProvider {
  String formattedNetBalance(DateFilter filter) =>
      '${netBalance(filter) >= 0 ? '' : '${'minus'.tr()} '}${'currency'.tr()} ${netBalance(filter).abs().toStringAsFixed(0)}';

  String formattedTotalIncome(DateFilter filter) =>
      '${'currency'.tr()} ${totalIncome(filter).toStringAsFixed(0)}';

  String formattedTotalExpense(DateFilter filter) =>
      '${'currency'.tr()} ${totalExpense(filter).toStringAsFixed(0)}';

  String formattedBudgetStatus(DateFilter filter) =>
      '${'currency'.tr()} ${netBalance(filter).toStringAsFixed(0)} | Kaldı';

  String formattedBudgetDetail(DateFilter filter) =>
      '${'currency'.tr()} ${totalExpense(filter).toStringAsFixed(0)} / ${'currency'.tr()} ${totalIncome(filter).toStringAsFixed(0)}';
}
