import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/app_color_constans.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/amount_field.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/category_chip.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/date_button.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/transaction/type_chip.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/filter_provider.dart';
import '../../providers/transaction_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final TextEditingController minController = TextEditingController();
  final TextEditingController maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final filter = context.read<FilterProvider>();
    minController.text = filter.minAmount?.toStringAsFixed(0) ?? '';
    maxController.text = filter.maxAmount?.toStringAsFixed(0) ?? '';
  }

  @override
  void dispose() {
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate(FilterProvider filter) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: filter.startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) filter.setStartDate(picked);
  }

  Future<void> _pickEndDate(FilterProvider filter) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: filter.endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) filter.setEndDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FilterProvider, CategoryProvider>(
      builder: (_, filter, categoryProvider, __) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BaseText.headlineSmall(context, data: 'filter'.tr()),
                      TextButton(
                        onPressed: () => filter.reset(),
                        child: BaseText.titleSmall(
                          context,
                          data: 'clear'.tr(),
                          color: AppColor.colorRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BaseText.labelLarge(context, data: 'type'.tr()),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TypeChipWidget(
                          label: 'all'.tr(),
                          isSelected: filter.type == null,
                          color: Colors.blue,
                          onTap: () => filter.setType(null)),
                      const SizedBox(width: 8),
                      TypeChipWidget(
                          label: 'income'.tr(),
                          isSelected: filter.type == 1,
                          color: Colors.green,
                          onTap: () => filter.setType(1)),
                      const SizedBox(width: 8),
                      TypeChipWidget(
                          label: 'expense'.tr(),
                          isSelected: filter.type == 0,
                          color: Colors.red,
                          onTap: () => filter.setType(0)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BaseText.labelLarge(context, data: 'dateRange'.tr()),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: DateButtonWidget(
                              label: filter.startDate != null
                                  ? '${filter.startDate!.day}.${filter.startDate!.month}.${filter.startDate!.year}'
                                  : 'begin'.tr(),
                              onTap: () => _pickStartDate(filter))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: BaseText.bodyMedium(context,
                            data: '—', color: Colors.grey),
                      ),
                      Expanded(
                          child: DateButtonWidget(
                              label: filter.endDate != null
                                  ? '${filter.endDate!.day}.${filter.endDate!.month}.${filter.endDate!.year}'
                                  : 'end'.tr(),
                              onTap: () => _pickEndDate(filter))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BaseText.labelLarge(context, data: 'amountRange'.tr()),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: AmountFieldWidget(
                              controller: minController,
                              hint: '${'min'.tr()} ${'currency'.tr()}',
                              onChanged: (v) => filter.setMinAmount(
                                  v.isNotEmpty ? double.tryParse(v) : null))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: BaseText.bodyMedium(context,
                            data: '—', color: AppColor.colorGrey),
                      ),
                      Expanded(
                          child: AmountFieldWidget(
                              controller: maxController,
                              hint: '${'max'.tr()} ${'currency'.tr()}',
                              onChanged: (v) => filter.setMaxAmount(
                                  v.isNotEmpty ? double.tryParse(v) : null))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BaseText.labelLarge(context, data: 'category'.tr()),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryChipWidget(
                            label: 'all'.tr(),
                            isSelected: filter.categoryId == null,
                            onTap: () => filter.setCategory(null)),
                        const SizedBox(width: 8),
                        ...categoryProvider.categories.map((cat) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CategoryChipWidget(
                                  label: cat.name,
                                  isSelected: filter.categoryId == cat.id,
                                  onTap: () => filter.setCategory(cat.id)),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.colorBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        context.read<TransactionProvider>().applyFilter(
                              startDate: filter.startDate,
                              endDate: filter.endDate,
                              minAmount: filter.minAmount,
                              maxAmount: filter.maxAmount,
                              categoryId: filter.categoryId,
                              type: filter.type,
                            );
                        Navigator.pop(context);
                      },
                      child: BaseText.titleMedium(context,
                          data: 'apply'.tr(), color: AppColor.colorWhite),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
