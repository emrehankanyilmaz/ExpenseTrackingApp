import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_icons_constants.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/extensions/transaction_extension.dart';
import 'package:gider_takip/features/transactions/presentation/providers/category_provider.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/custom_container.dart';
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
            BaseText.titleLarge(
              context,
              data: 'lastTransactions'.tr(),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TransactionPage()),
                  );
                },
                child: BaseText.titleSmall(
                  context,
                  data: 'seeAll'.tr(),
                  color: AppColor.colorBlue,
                )),
          ],
        ),
        ...transactionProvider.recentTransactions.map((t) {
          final category = categoryProvider.getCategoryById(t.categoryId);
          final categoryIcon = AppIcons.fromName(category?.iconName ?? '');
          return CustomContainer(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            color: AppColor.colorWhite,
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
                      BaseText.bodyMedium(
                        context,
                        data: category?.name ?? 'unknownCategory'.tr(),
                      ),
                      if (t.description.isNotEmpty)
                        BaseText.bodySmall(context, data: t.description)
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      t.formattedAmount,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: t.type == CategoryType.expense
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
