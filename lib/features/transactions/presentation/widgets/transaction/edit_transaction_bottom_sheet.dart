import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_color_constans.dart';
import 'package:gider_takip/features/transactions/data/models/category_model.dart';
import 'package:gider_takip/features/transactions/data/models/transaction_model.dart';
import 'package:gider_takip/features/transactions/presentation/providers/category_provider.dart';
import 'package:gider_takip/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/add_transaction/transaction_input_type.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/amount_field.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/date_button.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/type_chip.dart';
import 'package:provider/provider.dart';

class EditTransactionBottomSheet extends StatefulWidget {
  const EditTransactionBottomSheet({
    super.key,
    required this.transaction,
  });
  final TransactionModel transaction;

  @override
  State<EditTransactionBottomSheet> createState() =>
      _EditTransactionBottomSheetState();
}

class _EditTransactionBottomSheetState
    extends State<EditTransactionBottomSheet> {
  late int selectedType;
  late DateTime selectedDate;
  late CategoryModel? selectedCategory;
  late TextEditingController amountController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    final categoryProvider = context.read<CategoryProvider>();
    selectedType = widget.transaction.type;
    selectedDate = widget.transaction.transactionDate;
    selectedCategory =
        categoryProvider.getCategoryById(widget.transaction.categoryId);
    amountController = TextEditingController(
        text: widget.transaction.amount.toStringAsFixed(0));
    descController =
        TextEditingController(text: widget.transaction.description);
  }

  @override
  void dispose() {
    amountController.dispose();
    descController.dispose();
    super.dispose();
  }

  List<CategoryModel> get _categories {
    final categoryProvider = context.read<CategoryProvider>();
    return selectedType == 0
        ? categoryProvider.expenseCategories
        : categoryProvider.incomeCategories;
  }

  Future<void> _save() async {
    if (selectedCategory == null) return;
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    await context.read<TransactionProvider>().updateTransaction(
          TransactionModel(
            id: widget.transaction.id,
            type: selectedType,
            categoryId: selectedCategory!.id!,
            amount: amount,
            transactionDate: selectedDate,
            description: descController.text.trim(),
          ),
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseText.headlineSmall(context, data: 'editCategory'.tr()),
            const SizedBox(height: 16),
            Row(
              children: [
                TypeChipWidget(
                  label: 'expense'.tr(),
                  isSelected: selectedType == 0,
                  color: AppColor.colorRed,
                  onTap: () => setState(() {
                    selectedType = 0;
                    selectedCategory = null;
                  }),
                ),
                const SizedBox(width: 8),
                TypeChipWidget(
                  label: 'income'.tr(),
                  isSelected: selectedType == 1,
                  color: AppColor.colorGreen,
                  onTap: () => setState(() {
                    selectedType = 1;
                    selectedCategory = null;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CategoryModel>(
              initialValue: selectedCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: BaseText.titleLarge(
                context,
                data: 'select'.tr(),
                color: AppColor.colorGrey,
              ),
              items: _categories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name),
                      ))
                  .toList(),
              onChanged: (cat) => setState(() => selectedCategory = cat),
            ),
            const SizedBox(height: 16),
            AmountFieldWidget(
              hint: 'currency'.tr(),
              controller: amountController,
            ),
            const SizedBox(height: 16),
            DateButtonWidget(
              label:
                  '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
              onTap: () async {
                final picked = await context
                    .read<TransactionProvider>()
                    .pickDate(context, initial: selectedDate);
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            const SizedBox(height: 16),
            TransactionInputWidget(
              type: TransactionInputType.description,
              descriptionController: descController,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.colorBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: BaseText.titleLarge(
                  context,
                  data: 'save'.tr(),
                  color: AppColor.colorWhite,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
