import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/constants/common_constans.dart';
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
        title: const Text(
          CommonConstants.categories,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColor.colorBlack),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          AddCategoryButton(
            onTap: () => CategoryDialogs.showCategoryDialog(context),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CategoryList(
              categories: categories,
              onEdit: (cat) =>
                  CategoryDialogs.showCategoryDialog(context, category: cat),
              onDelete: (id) =>
                  CategoryDialogs.showDeleteConfirmDialog(context, id),
            ),
          ),
        ],
      ),
    );
  }
}
