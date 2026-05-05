import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_color_constans.dart';
import 'package:gider_takip/features/transactions/data/models/date_filter.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/custom_container.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/home/pie_chart.dart';
import 'package:provider/provider.dart';
import '../../providers/filter_provider.dart';
import '../../providers/transaction_provider.dart';

class WeeklyCard extends StatelessWidget {
  const WeeklyCard({super.key});

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
    final transactionProvider = context.watch<TransactionProvider>();
    final filterProvider = context.watch<FilterProvider>();
    final data =
        transactionProvider.getExpensesByFilter(filterProvider.dateFilter);

    return CustomContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaseText.titleLarge(context, data: 'expenses'.tr()),
              PopupMenuButton<DateFilter>(
                onSelected: filterProvider.setWeeklyFilter,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: CustomContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  border: Border.all(color: AppColor.colorGrey300),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BaseText.labelMedium(context,
                          data: _filterLabel(filterProvider.dateFilter)),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down,
                          size: 16, color: AppColor.colorGrey),
                    ],
                  ),
                ),
                itemBuilder: (_) => DateFilter.values
                    .map((f) => PopupMenuItem(
                          value: f,
                          child: Text(_filterLabel(f)),
                        ))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          filterProvider.dateFilter == DateFilter.thisWeek
              ? _BarChart(data: data)
              : ExpensePieChart(data: data),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.data});
  final Map<String, double> data;

  @override
  Widget build(BuildContext context) {
    final maxVal =
        data.values.isEmpty ? 1.0 : data.values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: data.entries.map((entry) {
          final barHeight = maxVal > 0 ? (entry.value / maxVal) * 100 : 4.0;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (entry.value > 0)
                  CustomContainer(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: AppColor.colorBlue,
                    borderRadius: 6,
                    child: BaseText.labelSmall(
                      context,
                      data:
                          '${'currency'.tr()}${entry.value.toStringAsFixed(0)}',
                      color: AppColor.colorWhite,
                    ),
                  ),
                const SizedBox(height: 4),
                CustomContainer(
                  width: 28,
                  height: barHeight.clamp(5, 100),
                  color: AppColor.colorBlue,
                  borderRadius: 6,
                  child: const SizedBox(),
                ),
                const SizedBox(height: 4),
                BaseText.labelSmall(context,
                    data: entry.key, color: AppColor.colorGrey),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
