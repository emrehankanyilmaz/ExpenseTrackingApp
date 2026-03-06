import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/transaction_constans.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/add_transaction/transaction_row.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/add_transaction/transaction_save_button.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/add_transaction/transaction_type_selector.dart';
import 'package:provider/provider.dart';
import '../../constants/app_color_constans.dart';
import '../helper/transaction_helper.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/add_transaction/transaction_input_type.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final descController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.colorBlack),
          onPressed: () {
            context.read<TransactionProvider>().resetForm();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          TransactionConstants.newTransaction,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.colorBlack,
            fontSize: 20,
          ),
        ),
      ),
      body: _AddTransactionBody(
        amountController: amountController,
        descController: descController,
      ),
    );
  }
}

class _AddTransactionBody extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController descController;

  const _AddTransactionBody({
    required this.amountController,
    required this.descController,
  });

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
                  label: TransactionConstants.type,
                  child:
                      TransactionTypeSelector(provider: transactionProvider)),
              const DividerWidget(height: 2),
              TransactionRow(
                label: TransactionConstants.category,
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
                label: TransactionConstants.amount,
                child: TransactionInputWidget(
                  type: TransactionInputType.amount,
                  amountController: amountController,
                ),
              ),
              const DividerWidget(
                height: 2,
              ),
              TransactionRow(
                label: TransactionConstants.date,
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
  final double height;

  const DividerWidget({
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(height: height);
  }
}
