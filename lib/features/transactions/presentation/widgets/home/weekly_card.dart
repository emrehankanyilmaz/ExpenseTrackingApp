import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_color_constans.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/custom_container.dart';
import 'package:provider/provider.dart';
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
              BaseText.titleLarge(context, data: 'expenses'.tr()),
              CustomContainer(
                  border: Border.all(color: AppColor.colorGrey300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: BaseText.labelMedium(context, data: 'thisWeek'.tr())),
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
                        CustomContainer(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          color: AppColor.colorBlue,
                          child: BaseText.labelSmall(
                            context,
                            data:
                                '${'currency'.tr()}${e.value.toStringAsFixed(0)}',
                            color: AppColor.colorWhite,
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
                      BaseText.labelSmall(
                        context,
                        data: e.key,
                        color: AppColor.colorGrey,
                      )
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
