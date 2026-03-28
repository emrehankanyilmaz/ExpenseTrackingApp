import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/extensions/transaction_provider_extension.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/custom_container.dart';
import '../../../constants/app_color_constans.dart';
import '../../providers/transaction_provider.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.provider,
  });
  final TransactionProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.colorWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaseText.titleLarge(
                context,
                data: provider.formattedNetBalance,
                color: provider.netBalance >= 0
                    ? AppColor.colorGreen
                    : AppColor.colorRed,
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: BuildIncomeBox(
                  buildIncomeBoxProvider: provider,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BuildExpenseBox(
                  buildExpenseBoxprovider: provider,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaseText.bodyMedium(context, data: 'budgetStatus'.tr()),
              BaseText.bodySmall(
                context,
                data: provider.formattedBudgetStatus,
              )
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: provider.totalIncome > 0
                  ? (provider.totalExpense / provider.totalIncome).clamp(0, 1)
                  : 0,
              minHeight: 10,
              backgroundColor: AppColor.colorGrey200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColor.colorOrange),
            ),
          ),
          const SizedBox(height: 6),
          BaseText.bodySmall(
            context,
            data: provider.formattedBudgetDetail,
          ),
        ],
      ),
    );
  }
}

class BuildIncomeBox extends StatelessWidget {
  const BuildIncomeBox({super.key, required this.buildIncomeBoxProvider});

  final TransactionProvider buildIncomeBoxProvider;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: AppColor.colorGreen,
      child: Column(
        children: [
          BaseText.titleLarge(
            context,
            data: buildIncomeBoxProvider.formattedTotalIncome,
            color: AppColor.colorWhite,
          ),
          BaseText.labelMedium(
            context,
            data: 'income'.tr(),
            color: AppColor.colorWhite,
          ),
        ],
      ),
    );
  }
}

class BuildExpenseBox extends StatelessWidget {
  const BuildExpenseBox({
    super.key,
    required this.buildExpenseBoxprovider,
  });

  final TransactionProvider buildExpenseBoxprovider;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: AppColor.colorRed,
      child: Column(
        children: [
          BaseText.titleLarge(
            context,
            data: buildExpenseBoxprovider.formattedTotalExpense,
            color: AppColor.colorWhite,
          ),
          BaseText.labelMedium(
            context,
            data: 'expense'.tr(),
            color: AppColor.colorWhite,
          ),
        ],
      ),
    );
  }
}
