import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';
import 'package:provider/provider.dart';
import '../../constants/app_color_constans.dart';
import '../dialogs/category_dialogs.dart';
import '../providers/category_provider.dart';
import '../widgets/category/add_category_button.dart';
import '../widgets/category/category_list.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.colorGrey100,
        elevation: 0,
        centerTitle: true,
        title: BaseText.displaySmall(context, data: 'categories'.tr()),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          AddCategoryButton(
            onTap: () => context.showCategoryDialog(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CategoryList(
              categories: categories,
              onEdit: (cat) => context.showCategoryDialog(category: cat),
              onDelete: (id) => context.showDeleteConfirmDialog(id),
            ),
          ),
        ],
      ),
    );
  }
}
