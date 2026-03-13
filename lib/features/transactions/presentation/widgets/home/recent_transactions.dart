import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_icons_constants.dart';
import 'package:gider_takip/features/transactions/presentation/providers/category_provider.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/icon_container_widget.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_color_constans.dart';
import '../../pages/transaction_page.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final transactionProvider = context.watch<TransactionProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('lastTransactions'.tr(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionPage()),
                );
              },
              child: Text('seeAll'.tr(),
                  style: const TextStyle(color: AppColor.colorBlue)),
            ),
          ],
        ),
        ...transactionProvider.recentTransactions.map((t) {
          final category = categoryProvider.getCategoryById(t.categoryId);
          final categoryIcon = AppIcons.fromName(category?.iconName ?? '');
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColor.colorWhite,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                IconContainerWidget(
                  categoryIcon: categoryIcon,
                  size: 52,
                  iconSize: 35,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category?.name ?? 'unknownCategory'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (t.description.isNotEmpty)
                        Text(t.description,
                            style: const TextStyle(
                                color: AppColor.colorGrey, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${t.type == 0 ? '${'minus'.tr()} ' : ''}${'currency'.tr()} ${t.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: t.type == 0
                              ? AppColor.colorRed
                              : AppColor.colorGreen),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
