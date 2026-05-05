import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/data/models/date_filter.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/custom_container.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_color_constans.dart';
import '../../providers/filter_provider.dart';
import '../../providers/transaction_provider.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.provider});
  final TransactionProvider provider;

  String _filterLabel(DateFilter filter) {
    switch (filter) {
      case DateFilter.thisWeek:
        return 'thisWeek'.tr();
      case DateFilter.thisMonth:
        return 'thisMonth'.tr();
      case DateFilter.lastThreeMonths:
        return 'lastThreeMonths'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilterProvider>();
    final filter = filterProvider.budgetFilter;
    final totalIncome = provider.totalIncome(filter);
    final totalExpense = provider.totalExpense(filter);
    final netBalance = provider.netBalance(filter);

    return CustomContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaseText.titleLarge(
                context,
                data:
                    '${netBalance >= 0 ? '' : '${'minus'.tr()} '}${'currency'.tr()} ${netBalance.abs().toStringAsFixed(0)}',
                color:
                    netBalance >= 0 ? AppColor.colorGreen : AppColor.colorRed,
              ),
              PopupMenuButton<DateFilter>(
                onSelected: filterProvider.setBudgetFilter,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: CustomContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  border: Border.all(color: AppColor.colorGrey300),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BaseText.labelMedium(context, data: _filterLabel(filter)),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down,
                          size: 16, color: AppColor.colorGrey),
                    ],
                  ),
                ),
                itemBuilder: (_) => DateFilter.values
                    .map((f) =>
                        PopupMenuItem(value: f, child: Text(_filterLabel(f))))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: BuildIncomeBox(
                      buildIncomeBoxProvider: provider, filter: filter)),
              const SizedBox(width: 12),
              Expanded(
                  child: BuildExpenseBox(
                      buildExpenseBoxprovider: provider, filter: filter)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaseText.bodyMedium(context, data: 'budgetStatus'.tr()),
              BaseText.bodySmall(
                context,
                data:
                    '${'currency'.tr()} ${netBalance.toStringAsFixed(0)} | Kaldı',
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: totalIncome == 0 && totalExpense == 0
                ? const LinearProgressIndicator(
                    value: 1,
                    minHeight: 10,
                    backgroundColor: AppColor.colorOrange,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColor.colorOrange),
                  )
                : LinearProgressIndicator(
                    value: totalIncome + totalExpense > 0
                        ? (totalIncome / (totalIncome + totalExpense))
                            .clamp(0.0, 1.0)
                        : 0,
                    minHeight: 10,
                    backgroundColor: AppColor.colorRed,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColor.colorGreen),
                  ),
          ),
          const SizedBox(height: 6),
          BaseText.bodySmall(
            context,
            data:
                '${'currency'.tr()} ${totalExpense.toStringAsFixed(0)} / ${'currency'.tr()} ${totalIncome.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }
}

class BuildIncomeBox extends StatelessWidget {
  const BuildIncomeBox(
      {super.key, required this.buildIncomeBoxProvider, required this.filter});
  final TransactionProvider buildIncomeBoxProvider;
  final DateFilter filter;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: AppColor.colorGreen,
      child: Column(
        children: [
          BaseText.titleLarge(
            context,
            data:
                '${'currency'.tr()} ${buildIncomeBoxProvider.totalIncome(filter).toStringAsFixed(0)}',
            color: AppColor.colorWhite,
          ),
          BaseText.labelMedium(context,
              data: 'income'.tr(), color: AppColor.colorWhite),
        ],
      ),
    );
  }
}

class BuildExpenseBox extends StatelessWidget {
  const BuildExpenseBox(
      {super.key, required this.buildExpenseBoxprovider, required this.filter});
  final TransactionProvider buildExpenseBoxprovider;
  final DateFilter filter;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: AppColor.colorRed,
      child: Column(
        children: [
          BaseText.titleLarge(
            context,
            data:
                '${'currency'.tr()} ${buildExpenseBoxprovider.totalExpense(filter).toStringAsFixed(0)}',
            color: AppColor.colorWhite,
          ),
          BaseText.labelMedium(context,
              data: 'expense'.tr(), color: AppColor.colorWhite),
        ],
      ),
    );
  }
}
