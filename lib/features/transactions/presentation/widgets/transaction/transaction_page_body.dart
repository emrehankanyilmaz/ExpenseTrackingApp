import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gider_takip/features/transactions/constants/app_color_constans.dart';
import 'package:gider_takip/features/transactions/constants/app_icons_constants.dart';
import 'package:gider_takip/features/transactions/constants/days_months_constants.dart';
import 'package:gider_takip/features/transactions/data/models/category_type.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/icon_container_widget.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/edit_transaction_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../common/custom_container.dart';

class TransactionPageBody extends StatelessWidget {
  const TransactionPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final transactions = transactionProvider.filteredTransactions;
    return transactions.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_long_rounded,
                    size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('noTransaction'.tr(),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                transactions.length + (transactionProvider.hasMore ? 1 : 0),
            itemBuilder: (_, index) {
              if (index == transactions.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: TextButton(
                      onPressed: transactionProvider.loadMore,
                      child: Text('seeMore'.tr()),
                    ),
                  ),
                );
              }

              final t = transactions[index];
              final category = categoryProvider.getCategoryById(t.categoryId);
              final categoryIcon = AppIcons.fromName(category?.iconName ?? '');

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Slidable(
                  key: Key(t.id.toString()),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.4,
                    children: [
                      SlidableAction(
                        onPressed: (_) => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) =>
                              EditTransactionBottomSheet(transaction: t),
                        ),
                        backgroundColor: Colors.blue,
                        icon: Icons.edit_outlined,
                        label: 'edit'.tr(),
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12)),
                      ),
                      SlidableAction(
                        onPressed: (_) => context
                            .read<TransactionProvider>()
                            .deleteTransaction(t.id!),
                        backgroundColor: Colors.red,
                        icon: Icons.delete_outline,
                        label: 'delete'.tr(),
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(12)),
                      ),
                    ],
                  ),
                  child: CustomContainer(
                    padding: const EdgeInsets.all(12),
                    color: AppColor.colorWhite,
                    borderRadius: 12,
                    child: Row(
                      children: [
                        IconContainerWidget(
                          categoryIcon: categoryIcon,
                          size: 46,
                          iconSize: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category?.name ?? 'unknown'.tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              if (t.description.isNotEmpty)
                                Text(t.description,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${t.type == CategoryType.expense ? 'minus'.tr() : '+'}${'currency'.tr()}${t.amount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: t.type == CategoryType.expense
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            Text(
                              _formatDate(t.transactionDate),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${WeekDaysConstants.months[date.month - 1]} ${date.year}';
  }
}
