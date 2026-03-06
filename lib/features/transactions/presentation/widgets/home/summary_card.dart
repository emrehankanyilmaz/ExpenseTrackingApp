import 'package:flutter/material.dart';
import '../../../constants/app_color_constans.dart';
import '../../../constants/common_constans.dart';
import '../../../constants/home_page_constans.dart';
import '../../providers/transaction_provider.dart';

class SummaryCard extends StatelessWidget {
  final TransactionProvider provider;

  const SummaryCard({
    super.key,
    required this.provider,
  });

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
                '${provider.netBalance >= 0 ? '' : '${CommonConstants.minus} '}${CommonConstants.currency} ${provider.netBalance.abs().toStringAsFixed(0)}',
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
              const Text(
                HomePageConstans.budgetStatus,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${CommonConstants.currency} ${provider.netBalance.toStringAsFixed(0)} | Kaldı',
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
            '${CommonConstants.currency} ${provider.totalExpense.toStringAsFixed(0)} / ${CommonConstants.currency} ${provider.totalIncome.toStringAsFixed(0)}',
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
            '${CommonConstants.currency} ${provider.totalIncome.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColor.colorWhite,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Text(
            CommonConstants.income,
            style: TextStyle(color: AppColor.colorWhite70, fontSize: 12),
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
            '${CommonConstants.minus} ${CommonConstants.currency} ${provider.totalExpense.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColor.colorWhite,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Text(
            CommonConstants.expense,
            style: TextStyle(color: AppColor.colorWhite70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
