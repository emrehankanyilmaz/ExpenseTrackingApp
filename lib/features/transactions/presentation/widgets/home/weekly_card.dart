import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_color_constans.dart';
import 'package:provider/provider.dart';
import '../../../constants/common_constans.dart';
import '../../../constants/home_page_constans.dart';
import '../../providers/transaction_provider.dart';

class WeeklyCard extends StatelessWidget {
  const WeeklyCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final data = provider.weeklyExpenses;
    final maxVal =
        data.values.isEmpty ? 1.0 : data.values.reduce((a, b) => a > b ? a : b);

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
              const Text(
                HomePageConstans.expenses,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.colorGrey300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  HomePageConstans.thisWeek,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data.entries.map((e) {
                final isMax = e.value == maxVal && maxVal > 0;
                final barHeight = maxVal > 0 ? (e.value / maxVal) * 100 : 4.0;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isMax)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColor.colorBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${CommonConstants.currency}${e.value.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppColor.colorWhite,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: barHeight.clamp(5, 100),
                        decoration: BoxDecoration(
                          color: isMax
                              ? AppColor.colorBlue
                              : AppColor.colorBlue100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.key,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColor.colorGrey,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
