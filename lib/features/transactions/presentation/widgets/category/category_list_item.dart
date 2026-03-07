import 'package:flutter/material.dart';

import '../../../constants/app_color_constans.dart';
import '../../../constants/app_icons_constants.dart';
import '../../../constants/common_constans.dart';
import '../../../data/models/category_model.dart';
import '../common/icon_container_widget.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  final CategoryModel category;
  final void Function(CategoryModel) onEdit;
  final void Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    //burası değişti
    final categoryIcon = AppIcons.fromName(category.iconName);
    final isIncome = category.type == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          IconContainerWidget(
              categoryIcon: categoryIcon, size: 52, iconSize: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  isIncome ? CommonConstants.income : CommonConstants.expense,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isIncome ? AppColor.colorGreen : AppColor.colorRed,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_square,
                color: AppColor.colorBlue, size: 26),
            onPressed: () => onEdit(category),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: AppColor.colorRed, size: 26),
            onPressed: () => onDelete(category.id!),
          ),
        ],
      ),
    );
  }
}
