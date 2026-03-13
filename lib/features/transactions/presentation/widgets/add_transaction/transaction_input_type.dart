import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gider_takip/features/transactions/constants/app_icons_constants.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/icon_container_widget.dart';
import '../../../constants/app_color_constans.dart';
import '../../../data/models/category_model.dart';

enum TransactionInputType {
  category,
  amount,
  date,
  description,
}

class TransactionInputWidget extends StatelessWidget {
  const TransactionInputWidget({
    super.key,
    required this.type,
    this.categories,
    this.selectedCategory,
    this.onCategoryChanged,
    this.amountController,
    this.selectedDate,
    this.onDateTap,
    this.descriptionController,
  });
  final TransactionInputType type;
  final List<CategoryModel>? categories;
  final CategoryModel? selectedCategory;
  final ValueChanged<CategoryModel?>? onCategoryChanged;
  final TextEditingController? amountController;
  final DateTime? selectedDate;
  final VoidCallback? onDateTap;
  final TextEditingController? descriptionController;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TransactionInputType.category:
        return _buildCategory();
      case TransactionInputType.amount:
        return _buildAmount();
      case TransactionInputType.date:
        return _buildDate();
      case TransactionInputType.description:
        return _buildDescription();
    }
  }

  Widget _buildCategory() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColor.colorWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.colorGrey300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CategoryModel>(
          value: selectedCategory,
          isExpanded: true,
          hint: Text(
            'select'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: AppColor.colorBlack,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: (categories ?? []).map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Row(
                children: [
                  IconContainerWidget(
                    categoryIcon: AppIcons.fromName(cat.iconName),
                    size: 28,
                    iconSize: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(cat.name),
                ],
              ),
            );
          }).toList(),
          onChanged: onCategoryChanged,
        ),
      ),
    );
  }

  Widget _buildAmount() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.colorWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.colorGrey300),
      ),
      child: Row(
        children: [
          Text(
            "currency".tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          Expanded(
            child: TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  color: AppColor.colorBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
                border: InputBorder.none,
                hintText: 'moneyHintText'.tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDate() {
    final date = selectedDate ?? DateTime.now();
    return GestureDetector(
      onTap: onDateTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.colorWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.colorGrey300),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, size: 25),
            const SizedBox(width: 8),
            Text(
              _formatDate(date),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.colorWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.colorGrey300),
      ),
      child: TextField(
        controller: descriptionController,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontStyle: FontStyle.italic,
            color: AppColor.colorGrey,
          ),
          border: InputBorder.none,
          hintText: 'descriptionHintText'.tr(),
        ),
      ),
    );
  }
}
