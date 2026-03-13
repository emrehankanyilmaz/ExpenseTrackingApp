import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
              Text(
                '${provider.netBalance >= 0 ? '' : '${'minus'.tr()} '}${'currency'.tr()} ${provider.netBalance.abs().toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: provider.netBalance >= 0
                      ? AppColor.colorGreen
                      : AppColor.colorRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildIncomeBox(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildExpenseBox(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'budgetStatus'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${'currency'.tr()} ${provider.netBalance.toStringAsFixed(0)} | Kaldı',
                style: const TextStyle(color: AppColor.colorGrey, fontSize: 12),
              ),
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
          Text(
            '${'currency'.tr()} ${provider.totalExpense.toStringAsFixed(0)} / ${'currency'.tr()} ${provider.totalIncome.toStringAsFixed(0)}',
            style: const TextStyle(color: AppColor.colorGrey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.colorGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '${'currency'.tr()} ${provider.totalIncome.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColor.colorWhite,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'income'.tr(),
            style: const TextStyle(color: AppColor.colorWhite70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.colorRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '${'minus'.tr()} ${'currency'.tr()} ${provider.totalExpense.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColor.colorWhite,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'expense'.tr(),
            style: const TextStyle(color: AppColor.colorWhite70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
