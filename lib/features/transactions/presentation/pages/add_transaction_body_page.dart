import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/providers/category_provider.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/add_transaction/transaction_save_button.dart';
import 'package:provider/provider.dart';
import '../helper/transaction_helper.dart';
import '../widgets/add_transaction/transaction_input_type.dart';
import '../widgets/add_transaction/transaction_row.dart';
import '../widgets/add_transaction/transaction_type_selector.dart';

class AddTransactionBody extends StatelessWidget {
  const AddTransactionBody({
    super.key,
    required this.amountController,
    required this.descController,
  });
  final TextEditingController amountController;
  final TextEditingController descController;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final categories = transactionProvider.selectedType == 0
        ? categoryProvider.expenseCategories
        : categoryProvider.incomeCategories;

    return Column(
      children: [
        const SizedBox(height: 10),
        const DividerWidget(height: 2),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              TransactionRow(
                  label: 'type'.tr(),
                  child:
                      TransactionTypeSelector(provider: transactionProvider)),
              const DividerWidget(height: 2),
              TransactionRow(
                label: 'category'.tr(),
                child: TransactionInputWidget(
                  type: TransactionInputType.category,
                  categories: categories,
                  selectedCategory: transactionProvider.selectedCategory,
                  onCategoryChanged: (cat) {
                    if (cat != null) {
                      transactionProvider.setSelectedCategory(cat);
                    }
                  },
                ),
              ),
              const DividerWidget(
                height: 2,
              ),
              TransactionRow(
                label: 'amount'.tr(),
                child: TransactionInputWidget(
                  type: TransactionInputType.amount,
                  amountController: amountController,
                ),
              ),
              const DividerWidget(
                height: 2,
              ),
              TransactionRow(
                label: 'date'.tr(),
                child: TransactionInputWidget(
                  type: TransactionInputType.date,
                  selectedDate: transactionProvider.selectedDate,
                  onDateTap: () =>
                      TransactionHelper.pickDate(context, transactionProvider),
                ),
              ),
              const DividerWidget(height: 2),
              const SizedBox(height: 20),
              TransactionInputWidget(
                type: TransactionInputType.description,
                descriptionController: descController,
              ),
            ],
          ),
        ),
        TransactionSaveButton(
            amountController: amountController, descController: descController),
      ],
    );
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    required this.height,
    super.key,
  });
  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height);
  }
}
