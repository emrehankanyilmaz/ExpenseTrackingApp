import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/category/category_list_item.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/common/custom_container.dart';
import '../../../constants/app_color_constans.dart';
import '../../../data/models/category_model.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CategoryModel> categories;
  final void Function(CategoryModel) onEdit;
  final void Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: AppColor.colorWhite,
      child: categories.isEmpty
          ? Center(
              child: Text(
                'noCategories'.tr(),
                style: const TextStyle(color: AppColor.colorGrey),
              ),
            )
          : ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColor.colorGrey200),
              itemBuilder: (_, index) => CategoryListItem(
                category: categories[index],
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
    );
  }
}
